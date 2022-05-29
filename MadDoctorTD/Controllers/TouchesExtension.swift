//
//  InputManager.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation
import SpriteKit
import GameplayKit

extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if GameManager.instance.isPaused || uiManager!.lockCamera {
            return
        }
        
        if uiManager!.rangeIndicator != nil{
            uiManager!.rangeIndicator!.removeFromParent()
        }
        
        uiManager!.foundationIndicator!.alpha = 0
        
        let communicator = GameSceneCommunicator.instance
        communicator.cancelAllMenus()
        
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            
            if node.name == "SellTowerButton" || node.name == "SellFoundationButton" || node.name == "BuildFoundationButton"
                || node.name == "BuildTowerButton" || node.name == "ReadyButton" || node.name == "ResearchButton" || node.name == "BackButton"{
                
                extraButtons(nodeName: node.name!)
                return
            }
        }
        
        if GameSceneCommunicator.instance.foundationEditMode {
            communicator.editFoundationTouchStart(touchedNodes: touchedNodes)
            return
        }
        
        for node in touchedNodes{
            if node.name == "UpgradeFoundation" || node.name == "RepairFoundation"{
                switch node.name{
                    
                case "UpgradeFoundation":
                    communicator.upgradeFoundation()
                    
                case "RepairFoundation":
                    
                    communicator.repairFoundation()
                    
                    
                default: print("error")
                }
                
                return
            }
        }
        
        for node in touchedNodes {
            
            
            if node.name == "GunTower" || node.name == "SpeedTower" ||
                node.name == "CannonTower" || node.name == "SniperTower"{
                //SoundManager.playSFX(sfxName: SoundManager.buttonSFX_two, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
                
                //call function that takes in name of node
                if uiManager!.dragAndDropBuild(node: node, location: location){
                    uiManager!.startTouchingTower(location: location)
                    
                }

                return
            }
        }
        
        for node in touchedNodes{
            
            if node.name == "RateOfFireButton" || node.name == "RangeButton" ||
                node.name == "AttackButton"{
                
                touchStarted = true
                uiManager!.upgradeTowerMenu(nodeName: node.name!)
                return
                
            }
        }
        
        for node in touchedNodes{
            
            if node.name == "FoundationMenuToggle"{
                uiManager!.showFoundationUI()
                return
            }
        }
        
        for node in touchedNodes{
            if node.name == "UpgradeMenuToggle"{
                uiManager!.showUpgradeUI()
                uiManager!.displayRangeIndicator(attackRange: communicator.currentTower!.attackRange, position: communicator.currentTower!.position)
                
                return
            }
        }
        
        for node in touchedNodes{
            if node.name == "TowerLogo"{
                
                uiManager!.showTowerInfo()
                uiManager!.displayRangeIndicator(attackRange: communicator.currentTower!.attackRange, position: communicator.currentTower!.position)
                
                return
            }
            
            
        }
        
        for node in touchedNodes {
            
            if node is Tower{
                let tower = node as! Tower
                tower.onClick()
             
                return
                
            }
        }
        
        if communicator.isBuildPhase{
            for node in touchedNodes {
                
                if node is FoundationPlate {
                    
                    let foundationPlate = node as! FoundationPlate
                    foundationPlate.onClick()
                    
                    return
                }
            }
        }
        
        
        if uiManager!.upgradeUI?.alpha == 1{
            
        }
        uiManager!.showTowerUI()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if GameManager.instance.isPaused || uiManager!.lockCamera {
            return
        }
        
        guard let touch = touches.first else{return}
        let location = touch.location(in: self)
        
        if GameSceneCommunicator.instance.foundationEditMode {
            
            if touch.tapCount >= 2 {
                panForTranslation(touch: touch)
            }
            else {
                let touchedNodes = nodes(at: location)
                GameSceneCommunicator.instance.editFoundationTouchMove(touchedNodes: touchedNodes)
            }
            
            return
        }
        
        if uiManager!.touchingTower != nil{
            
            
            uiManager!.moveTouchingTower(location: location)
            return
        }
        
        
        panForTranslation(touch: touch)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if uiManager!.lockCamera {
            return
        }
        
        if uiManager!.touchingTower == nil{
            
            guard let touch = touches.first else {return}
            
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)
            
            for node in touchedNodes{
                
                if node.name == "RateOfFireButton" || node.name == "RangeButton" ||
                    node.name == "AttackButton" || node.name == "FoundationMenuToggle"{
                    
                    touchStarted = false
                    uiManager!.upgradeTowerMenu(nodeName: node.name!)
                    uiManager!.statUpgradePopUp?.alpha = 0
                    return
                    
                }
            }
            touchStarted = false
            return
        }
        
        touchStarted = false
                
        if uiManager!.snappedToFoundation != nil{
            uiManager!.movePriceTag()
        }
        else{
            uiManager!.priceTag?.alpha = 0
        }
        
        for node in uiManager!.towerPriceTags{
            node.alpha = 1
        }
        
        uiManager!.updateTouchingTower()
        
    }
    
    func extraButtons(nodeName: String){
        
        let communicator = GameSceneCommunicator.instance
        
        switch nodeName{
            
        case "SellTowerButton":
            GameSceneCommunicator.instance.sellTower()
            
        case "SellFoundationButton":
            
            GameSceneCommunicator.instance.sellFoundation()
            
        case "BuildFoundationButton":
            
            
            if communicator.foundationEditMode {
                communicator.confirmFoundationEdit()
                //Sound for finish foundationBuild
                //SoundManager.playSFX(sfxName: SoundManager.buttonSFX_three, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
                
            }else{
                communicator.foundationEditMode = true
                communicator.toggleFoundationGrid()
                uiManager!.hideAllMenus()
                uiManager!.buildFoundationButton?.texture = SKTexture(imageNamed: "done_build_foundation_button_standard")
                //Sound for activate foundationBuild
                SoundManager.playSFX(sfxName: SoundManager.buttonSFX_two, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
                
            }
            
        case "BuildTowerButton":
            print("Put TowerMenu here")
            
        case "ReadyButton":
            if uiManager!.readyButton?.alpha == 1{
                
                let newCameraScale = 0.5
                self.camera!.xScale = newCameraScale
                self.camera!.yScale = newCameraScale
                
                let cameraPosition = self.camera!.position
                uiManager!.setupCamera()
                self.camera!.position = cameraPosition
                
                uiManager!.lockCamera = true
                uiManager!.moveCameraToDoors = true
                 

                //uiManager!.onCameraReachedPortal()
            }
            
            
            
        case "ResearchButton":
            if uiManager!.researchButton?.alpha == 1{
                AppManager.appManager.state = .labMenu
                SoundManager.playSFX(sfxName: SoundManager.switchToResearchRoomSFX, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
                SoundManager.playBGM(bgmString: SoundManager.researchViewAtmosphere, bgmExtension: SoundManager.mp3Extension)
                
                AppManager.appManager.transitionOpacity = 1
                
                if let labScene = LabScene.instance {
                    labScene.fadeInScene = true
                }
                
            }
            
        case "BackButton":
            uiManager!.waveSummary?.alpha = 0
            uiManager!.mainHubBackground?.alpha = 1
            uiManager!.readyButton?.alpha = 1
            uiManager!.buildFoundationButton?.alpha = 1
            uiManager!.researchButton?.alpha = 1
            uiManager!.upgradeMenuToggle?.alpha = 1
            SoundManager.playSFX(sfxName: SoundManager.buttonSFX_one, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
            uiManager!.showTowerUI()
            
            
        default:
            print("error with extra buttons")
        }
        
        if uiManager!.upgradeUI?.alpha == 1{
            uiManager!.towerUI?.alpha = 1
            uiManager!.upgradeUI?.alpha = 0
        }
        
    }
    
    func panForTranslation(touch: UITouch) {
        
        if touchStarted || uiManager!.lockCamera {
            return
        }
        
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: (positionInScene.x) - (previousPosition.x), y: (positionInScene.y) - (previousPosition.y))
        
        let position = camera!.position
        let aNewPosition = CGPoint(x: position.x - translation.x, y: position.y - translation.y)
        camera!.position = aNewPosition
    }
    
    
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        
        if uiManager!.lockCamera {
            return
        }
        
        guard let camera = self.camera else {
            return
        }
        
        if sender.state == .began {
            
            uiManager!.previousCameraScale = camera.xScale
        }
        
        let newCameraScale = uiManager!.previousCameraScale * 1 / sender.scale
        
        if newCameraScale < 0.5 || newCameraScale > 2.3{
            
            return
            
        }
        
        let cameraPosition = self.camera!.position
        camera.setScale(newCameraScale)
        uiManager!.setupCamera()
        self.camera!.position = cameraPosition
    }


    func handleLongPress() {
        
        if uiManager!.lockCamera {
            return
        }
       
        guard let currentTower = GameSceneCommunicator.instance.currentTower else{return}
        
        if touchStarted && uiManager!.upgradeTypePreview != nil{
            
            uiManager!.upgradeTypePreviewUI(currentTower: currentTower)
            
        }
    }
    
}


