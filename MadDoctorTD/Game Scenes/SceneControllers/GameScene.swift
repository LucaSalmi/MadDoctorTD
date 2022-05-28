//
//  GameScene.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import Foundation
import GameplayKit
import SpriteKit
import SwiftUI
import UIKit

class GameScene: SKScene {

    @ObservedObject var gameManager = GameManager.instance
    
    static var instance: GameScene? = nil
    
    //Enemy stuff
    var pathfindingTestEnemy: Enemy?
    var nodeGraph: GKObstacleGraph? = nil
    var waveManager: WaveManager? = nil
    var enemyRaceSwitch: [EnemyRaces] = [.slime, .squid]
    
    //UI Stuff
    
    var uiManager: UIManager? = nil
    
    var fadeInScene = false
    var fadeOutScene = false
    var transitionAmount: Double = 0.02
    
    var portalPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    //user input stuff
    var touchStarted = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        
        AppManager.appManager.transitionOpacity = 1
        fadeInScene = true
        
        if GameManager.instance.isGameOver{
            gameSetup()
            return
        }
        
        if GameScene.instance != nil {
            return
        }
        
        GameScene.instance = self
        physicsWorld.contactDelegate = self
        gameSetup()
        
    }
    
    func gameSetup(){
        
        GameManager.instance.isGameOver = false
        GameSceneCommunicator.instance.isBuildPhase = true
        
        uiManager = UIManager()
        
        //creates and adds clickable tiles to GameScene
        let _ = ClickableTileFactory()
        addChild(ClickableTilesNodes.clickableTilesNode)
        
        
        setupEdges()
        
        
        setupCamera()
        
        //creates start foundations and adds the node to the GameScene
        FoundationPlateFactory().setupStartPlates()
        addChild(FoundationPlateNodes.foundationPlatesNode)
        
        //add towerNode and towerTextureNode to GameScene
        addChild(TowerNode.towersNode)
        addChild(TowerNode.towerTextureNode)
        
        //add ProjectilesNote to GameScene
        addChild(ProjectileNodes.projectilesNode)
        
        setupEnemies()
        addChild(EnemyNodes.enemiesNode)
        
    }
    
    private func setupCamera(){
        
        let myCamera = self.camera
        let backgroundMap = (childNode(withName: "edge") as! SKTileMapNode)
        let scaledSize = CGSize(width: size.width * myCamera!.xScale, height: size.height * myCamera!.yScale)
        
        let xInset = min((scaledSize.width/2) - 100.0, backgroundMap.frame.width/2)
        let yInset = min((scaledSize.height/2) - 100.0, backgroundMap.frame.height/2)
        
        let constrainRect = backgroundMap.frame.insetBy(dx: xInset, dy: yInset)
        
        let yLowerLimit = constrainRect.minY
        
        let xRange = SKRange(lowerLimit: constrainRect.minX, upperLimit: constrainRect.maxX)
        let yRange = SKRange(lowerLimit: yLowerLimit, upperLimit: constrainRect.maxY)
        
        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        edgeConstraint.referenceNode = backgroundMap
        
        myCamera!.constraints = [edgeConstraint]
        
        if view?.gestureRecognizers == nil{
            
            let pinchGesture = UIPinchGestureRecognizer()
            pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)))
            view?.addGestureRecognizer(pinchGesture)

        }
        
        myCamera!.position = CGPoint(x: 0, y: yLowerLimit)
        
    }
    
    private func setupEdges(){
        
        guard let edgesTileMap = childNode(withName: "edge")as? SKTileMapNode else {
            return
        }
        
        for row in 0..<edgesTileMap.numberOfRows{
            for column in 0..<edgesTileMap.numberOfColumns{
                
                guard let tile = tile(in: edgesTileMap, at: (column, row)) else {continue}
                guard tile.userData?.object(forKey: "isEdge") != nil else {continue}
                
                let edge = Edge()
                
                edge.position = edgesTileMap.centerOfTile(atColumn: column, row: row)
                uiManager!.edgesTilesNode.addChild(edge)
                
            }
        }
        
        //edgesTileMap.removeFromParent()
    }
    
    private func setupEnemies(){
        
        //build phase pathfinding test
        pathfindingTestEnemy = Enemy(texture: SKTexture(imageNamed: "joystick"), color: .clear)
        pathfindingTestEnemy?.alpha = 0
        let spawnPoint = childNode(withName: "SpawnPoint")
        pathfindingTestEnemy!.position = spawnPoint!.position
        pathfindingTestEnemy!.movePoints = pathfindingTestEnemy!.getMovePoints()
        addChild(pathfindingTestEnemy!)
        
        waveManager = WaveManager(totalSlots: WaveData.WAVE_STANDARD_SIZE, choises: [.standard])
        
        portalPosition = spawnPoint!.position
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if GameManager.instance.isPaused {
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if GameManager.instance.isPaused{
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
                showFoundationUI()
                return
            }
        }
        
        for node in touchedNodes{
            if node.name == "UpgradeMenuToggle"{
                showUpgradeUI()
                displayRangeIndicator(attackRange: communicator.currentTower!.attackRange, position: communicator.currentTower!.position)
                
                return
            }
        }
        
        for node in touchedNodes{
            if node.name == "TowerLogo"{
                
                showTowerInfo()
                displayRangeIndicator(attackRange: communicator.currentTower!.attackRange, position: communicator.currentTower!.position)
                
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
        
        
        if upgradeUI?.alpha == 1{
            
        }
        showTowerUI()
        
    }
    
    func showTowerInfo(){
        
        guard let currentTower = GameSceneCommunicator.instance.currentTower else {return}
        attackStatLabel?.text = "Attack Power: \(currentTower.attackDamage)"
        fireRateStatLabel?.text = "Fire Rate: \(currentTower.fireRate)"
        rangeStatLabel?.text = "Range: \(Int(currentTower.attackRange))"
        towerLogoInfo?.texture = currentTower.towerTexture.texture
        
        
        towerInfoMenu?.alpha = 1
        towerUI?.alpha = 0
        upgradeUI?.alpha = 0
        foundationUI?.alpha = 0
        
        if GameSceneCommunicator.instance.isBuildPhase{
            foundationMenuToggle?.alpha = 1
        }
        else{foundationMenuToggle?.alpha = 0}
        
    }
    
    func showTowerUI(){
        
        towerUI?.alpha = 1
        upgradeUI?.alpha = 0
        foundationUI?.alpha = 0
        towerInfoMenu?.alpha = 0
        
        if GameSceneCommunicator.instance.isBuildPhase{
            foundationMenuToggle?.alpha = 1
        }
        else{foundationMenuToggle?.alpha = 0}
    
    }
    func showUpgradeUI(){
        towerUI?.alpha = 0
        upgradeUI?.alpha = 1
        foundationUI?.alpha = 0
        towerInfoMenu?.alpha = 0
        
        
        if GameSceneCommunicator.instance.isBuildPhase{
            upgradeMenuToggle?.alpha = 1
        }
    }
    
    func showFoundationUI(){
        towerUI?.alpha = 0
        upgradeUI?.alpha = 0
        foundationUI?.alpha = 1
        towerInfoMenu?.alpha = 0
        let foundation = GameSceneCommunicator.instance.currentFoundation!
        foundation.updateUpgradeButtonTexture()
        displayFoundationIndicator(position: foundation.position)
        
        if foundation.hp < foundation.maxHp{
           
            foundationRepairButton?.alpha = 1
            
            foundationUpgradeButton?.alpha = 0.7
        }
        else{
            
            foundationRepairButton?.alpha = 0.7
            
            foundationUpgradeButton?.alpha = 1
        }
    }
    
    func hideAllMenus(){
        towerUI?.alpha = 0
        upgradeUI?.alpha = 0
        foundationUI?.alpha = 0
        towerInfoMenu?.alpha = 0
        statUpgradePopUp?.alpha = 0
        researchButton?.alpha = UIData.INACTIVE_BUTTON_ALPHA
        readyButton?.alpha = UIData.INACTIVE_BUTTON_ALPHA
    }
    
    func showSummary(){
        hideAllMenus()
        mainHubBackground?.alpha = 0
        baseHPLostNumber?.text = ("\(gameManager.baseHPLost)")
        creditsGainedNumber?.text = ("$\(gameManager.moneyEarned)")
        summaryTitle?.text = ("Wave \(gameManager.currentWave) completed!")
        researchPointsGained?.text = ("\(gameManager.researchPoints)")
        survivalBonusNumber?.text = ("\(gameManager.survivalBonusNumber)")
        
        if waveManager?.waveNumber == 10 || waveManager?.waveNumber == 20{
            bossMaterialGained?.text = "Boss Material: +1"

        } 
        
        waveSummary?.alpha = 1
    }
    
    
    private func extraButtons(nodeName: String){
        
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
                hideAllMenus()
                buildFoundationButton?.texture = SKTexture(imageNamed: "done_build_foundation_button_standard")
                //Sound for activate foundationBuild
                SoundManager.playSFX(sfxName: SoundManager.buttonSFX_two, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
                
            }
            
        case "BuildTowerButton":
            print("Put TowerMenu here")
            
        case "ReadyButton":
            if readyButton?.alpha == 1{
                communicator.startWavePhase()
                fadeInPortal = true
                waveManager?.waveStartCounter = 0
                showTowerUI()
                readyButton?.alpha = UIData.INACTIVE_BUTTON_ALPHA
                researchButton?.alpha = UIData.INACTIVE_BUTTON_ALPHA
                buildFoundationButton?.alpha = UIData.INACTIVE_BUTTON_ALPHA
                upgradeMenuToggle?.alpha = 0
                SoundManager.playSFX(sfxName: SoundManager.announcer, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
                GameManager.instance.moneyEarned = 0
                GameManager.instance.baseHPLost = 0
            }
            
            
            
        case "ResearchButton":
            if researchButton?.alpha == 1{
                AppManager.appManager.state = .labMenu
                SoundManager.playSFX(sfxName: SoundManager.switchToResearchRoomSFX, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
                SoundManager.playBGM(bgmString: SoundManager.researchViewAtmosphere, bgmExtension: SoundManager.mp3Extension)
                
                AppManager.appManager.transitionOpacity = 1
                
                if let labScene = LabScene.instance {
                    labScene.fadeInScene = true
                }
                
            }
            
        case "BackButton":
            waveSummary?.alpha = 0
            mainHubBackground?.alpha = 1
            GameScene.instance?.readyButton?.alpha = 1
            GameScene.instance?.buildFoundationButton?.alpha = 1
            GameScene.instance?.researchButton?.alpha = 1
            GameScene.instance?.upgradeMenuToggle?.alpha = 1
            SoundManager.playSFX(sfxName: SoundManager.buttonSFX_one, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
            showTowerUI()
            
            
        default:
            print("error with extra buttons")
        }
        
        if upgradeUI?.alpha == 1{
            towerUI?.alpha = 1
            upgradeUI?.alpha = 0
        }
        
    }
    
    func tile(in tileMap: SKTileMapNode, at coordinates: tileCoordinates) -> SKTileDefinition?{
        return tileMap.tileDefinition(atColumn: coordinates.column, row: coordinates.row)
    }
    
    
    
    private func animateDoors() {
        
        if GameSceneCommunicator.instance.openDoors {
            doorOne.position.x -= 1
            doorTwo.position.x += 1
        }
        
        if GameSceneCommunicator.instance.closeDoors {
            doorOne.position.x += 1
            doorTwo.position.x -= 1
        }
        
        doorsAnimationCount -= 1
        if doorsAnimationCount <= 0 {
            
            //fail safe to reset doors position to orginal position
            if GameSceneCommunicator.instance.closeDoors {
                doorOne.position.x = self.position.x - (doorOne.size.width/2)
                doorTwo.position.x = self.position.x + (doorTwo.size.width/2)
            }
            
            GameSceneCommunicator.instance.closeDoors = false
            GameSceneCommunicator.instance.openDoors = false
        }
    }
    
    func displayFoundationIndicator(position: CGPoint, display: Bool = true) {
        
        guard let foundationIndicator = foundationIndicator else {
            return
        }
        
        if display {
            foundationIndicator.position = position
            foundationIndicator.alpha = 0.005
            foundationIndicator.zPosition = 6
            foundationIndicatorIncrease = true
        }
        else {
            foundationIndicator.alpha = 0
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //Runs every frame
        
        if fadeInScene {
            AppManager.appManager.transitionOpacity -= transitionAmount
            if AppManager.appManager.transitionOpacity <= 0 {
                fadeInScene = false
            }
        }
        
        if fadeOutScene {
            
            AppManager.appManager.transitionOpacity += transitionAmount
            
            if AppManager.appManager.transitionOpacity >= 1 {
                fadeOutScene = false
                AppManager.appManager.transitionOpacity = 0
                AppManager.appManager.state = .gameScene
                SoundManager.playBGM(bgmString: SoundManager.ambienceOne, bgmExtension: SoundManager.mp3Extension)
            }
            
        }
        
        if touchStarted{
            handleLongPress()
        }else if statUpgradePopUp?.alpha == 1{
            statUpgradePopUp?.alpha = 0
        }
        
        if showNewMaterialMessage{
            
            for node in dialoguesNode.children{
                
                let dialog = node as! Dialogue
                dialog.update()
                
            }
            
            if dialoguesNode.children.count == 0{
                showNewMaterialMessage = false
            }
        }
        
        if GameManager.instance.isPaused || GameManager.instance.isGameOver{
            return
        }
        
        if fadeInPortal{
            fadePortal(fadeIn: true)
        }
        if fadeOutPortal{
            fadePortal(fadeIn: false)
        }
        
        if GameSceneCommunicator.instance.isBuildPhase && waveSummary?.alpha == 0{
            showBuildButtonsUI()
            //FadeoutPortal()
            //showTowerUI()
        }
        else {
            hideBuildButtonsUI()
        }
        
        if GameSceneCommunicator.instance.openDoors || GameSceneCommunicator.instance.closeDoors {
            animateDoors()
            
            if GameSceneCommunicator.instance.closeDoors {
                return
            }
        }
        
        if GameManager.instance.currentMoney < TowerData.BASE_COST{
            for node in towerUI!.children{
                if node.alpha != 0.5{
                    node.alpha = 0.5
                    for tag in towerPriceTags {
                        tag.fontColor = UIColor(Color.red)
                    }
                }
            }
        }
        
        if priceTag!.alpha > 0 && touchingTower == nil{
            priceTag!.alpha -= 0.03
            priceTag!.position.y += 1.5
        }
        
        
        if moveCameraToPortal {
            let cameraDirection = PhysicsUtils.getCameraDirection(camera: self.camera!, targetPoint: portalPosition)
            PhysicsUtils.moveCameraToTargetPoint(camera: self.camera!, direction: cameraDirection)
            
            let portal = SKSpriteNode()
            portal.position = portalPosition
            portal.size = CGSize(width: 86, height: 500)
                        
            if portal.contains(camera!.position) || !EnemyNodes.enemiesNode.children.isEmpty{
                moveCameraToPortal = false
                print("Im at portal with camera")
            }
        }
        
        for node in TowerNode.towersNode.children {
            let tower = node as! Tower
            tower.update()
            
        }
        
        if GameManager.instance.currentMoney < TowerData.BASE_COST{
            for node in towerUI!.children{
                if node.alpha != 0.5{
                    node.alpha = 0.5
                }
            }
        }

        for node in ProjectileNodes.projectilesNode.children {
            if node is Projectile{
                let projectile = node as! Projectile
                projectile.update()
            }
            else{
                let aoeProjectile = node as! AoeProjectile
                aoeProjectile.update()
            }
        }
        
        for node in moneyNode.children {
            
            if node is MoneyObject{
                
                let moneyObject = node as! MoneyObject
                moneyObject.update()
                
            }else if node is DropObject{
                
                let drop = node as! DropObject
                drop.update()
            }
        }
        
        if foundationIndicator!.alpha != 0 {
            
            let increaseAmount = 0.01
            let maxAlpha = 0.35
            
            if foundationIndicatorIncrease {
                foundationIndicator!.alpha += increaseAmount
                if foundationIndicator!.alpha >= maxAlpha {
                    foundationIndicator!.alpha = maxAlpha - increaseAmount
                    foundationIndicatorIncrease = false
                }
            }
            else {
                foundationIndicator!.alpha -= increaseAmount
                if foundationIndicator!.alpha <= increaseAmount {
                    foundationIndicator!.alpha = increaseAmount*2
                    foundationIndicatorIncrease = true
                }
            }
        }
        
        if !GameSceneCommunicator.instance.isBuildPhase {
            
            waveManager!.update()
            
            for node in EnemyNodes.enemiesNode.children{
                
                let enemy = node as! Enemy
                enemy.update()
            }
        }
        if showDamageIndicator{
            GameManager.instance.displayDamageIndicator()
        }
    }
    
    func fadePortal(fadeIn: Bool){
        
        let sizeDifference = CGFloat(0.01)
        
        
        if !fadeIn{
            
            if portal!.xScale >= 0{
                
                portal?.xScale -= sizeDifference
                portal?.yScale -= sizeDifference
                
                
            }
            else{
                portal!.alpha = 0
                fadeOutPortal = false
                return
            }
        }
        else{
            if portal!.alpha < 1{
                portal!.alpha = 1
            }
            
            if portal!.xScale <= 1{
                
                portal!.xScale += sizeDifference
                portal!.yScale += sizeDifference
            }
            else{
                fadeInPortal = false
                return
            }
        }
    }
    
    func resetGameScene(){
        
        //Tower
        TowerNode.towerArray.removeAll()
        TowerNode.towersNode.removeAllChildren()
        TowerNode.towersNode.removeFromParent()
        TowerNode.towerTextureNode.removeAllChildren()
        TowerNode.towerTextureNode.removeFromParent()
        towerIndicatorsNode.removeAllChildren()
        towerIndicatorsNode.removeFromParent()
        
        //Enemies
        EnemyNodes.enemiesNode.removeAllChildren()
        EnemyNodes.enemiesNode.removeFromParent()
        EnemyNodes.enemyArray.removeAll()
        
        //HP bars
        hpBarsNode.removeAllChildren()
        hpBarsNode.removeFromParent()
        
        //Projectile Shadows
        projectileShadowNode.removeAllChildren()
        projectileShadowNode.removeFromParent()
        
        //Foundation
        FoundationPlateNodes.foundationPlatesNode.removeAllChildren()
        FoundationPlateNodes.foundationPlatesNode.removeFromParent()
        foundationIndicatorsNode.removeAllChildren()
        foundationIndicatorsNode.removeFromParent()
        
        //ClickableTiles
        ClickableTilesNodes.clickableTilesNode.removeAllChildren()
        ClickableTilesNodes.clickableTilesNode.removeFromParent()
        
        //Projectiles
        ProjectileNodes.projectilesNode.removeAllChildren()
        ProjectileNodes.projectilesNode.removeFromParent()
        ProjectileNodes.gunProjectilesPool.removeAll()
        
        //Edge
        edgesTilesNode.removeAllChildren()
        edgesTilesNode.removeFromParent()
        
        //Economy
        GameManager.instance.currentMoney = PlayerData.START_MONEY
        GameManager.instance.researchPoints = PlayerData.START_RESEARCH_POINTS
        GameManager.instance.baseHp = PlayerData.BASE_HP
        gameManager.resetAllSkills()
        
        //Wave
        GameManager.instance.currentWave = 0
        GameManager.instance.nextWaveCounter = 0
        
        //Boss
        for child in self.children{
            
            if child.name == "BossTexture"{
                child.removeFromParent()
            }
        }
        
        //UI
        self.camera!.removeAllChildren()
        self.uiNode.removeFromParent()
        
        //Foundation edit mode
        clickableTileGridsNode.removeFromParent()
        
        //Money
        moneyNode.removeAllChildren()
        moneyNode.removeFromParent()
        
        dialoguesNode.removeAllChildren()
        dialoguesNode.removeFromParent()
        
        foundationIndicator!.removeFromParent()
    }
    
    func showBuildButtonsUI() {
        
        guard let buildButtonsUI = buildButtonsUI else {
            return
        }

        if buildButtonsUI.position.x <= UIData.BUILD_BUTTONS_UI_POS_X {
            return
        }
        
        buildButtonsUI.position.x -= UIData.BUILD_BUTTONS_UI_SPEED
    }
    
    func hideBuildButtonsUI() {
        
        guard let buildButtonsUI = buildButtonsUI else {
            return
        }

        if buildButtonsUI.position.x >= UIData.BUILD_BUTTONS_UI_POS_X*2 {
            return
        }
        
        buildButtonsUI.position.x += UIData.BUILD_BUTTONS_UI_SPEED
    }
    
    func panForTranslation(touch: UITouch) {
        
        if moveCameraToPortal || touchStarted{
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
        guard let camera = self.camera else {
            return
        }
        
        if sender.state == .began {
            
            previousCameraScale = camera.xScale
        }
        
        let newCameraScale = previousCameraScale * 1 / sender.scale
        
        if newCameraScale < 0.5 || newCameraScale > 2.3{
            
            return
            
        }
        
        camera.setScale(newCameraScale)
        setupCamera()
        
    }


    private func handleLongPress() {
       
        guard let currentTower = GameSceneCommunicator.instance.currentTower else{return}
        
        if touchStarted && upgradeTypePreview != nil{
            
            switch upgradeTypePreview{
                    
            case .damage:
                let newDmg = Double(currentTower.attackDamage) * TowerData.UPGRADE_DAMAGE_BONUS_PCT
                statUpgradePreviewText?.text = "Damage: \(currentTower.attackDamage) -> \(String(format: "%.0f", newDmg))"
            case .none:
                statUpgradePreviewText?.text = "ERROR"
            case .range:
                let newRange = Double(currentTower.attackRange) * TowerData.UPGRADE_RANGE_BONUS_PCT
                statUpgradePreviewText?.text = "Range: \(String(format: "%.0f", currentTower.attackRange)) -> \(String(format: "%.0f", newRange))"
            case .firerate:
                let newFIreRate = Double(currentTower.fireRate) * TowerData.UPGRADE_FIRE_RATE_REDUCTION_PCT
                statUpgradePreviewText?.text = "Shots per Second: \(currentTower.fireRate) -> \(String(format: "%.0f", newFIreRate))"
            }
            
            statUpgradePopUp?.alpha = 1
            
        }
    }
    
    
    
    
}

typealias tileCoordinates = (column: Int, row: Int)
