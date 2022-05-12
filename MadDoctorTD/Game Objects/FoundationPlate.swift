//
//  Foundation.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import Foundation
import SpriteKit

class FoundationPlate: SKSpriteNode{
    
    let isStartingFoundation: Bool
    
    var builtUponTile: ClickableTile?
    var hasTower = false
    
    var isPowered = true
    var isPoweredChecked = false
    
    var hp = FoundationData.BASE_HP
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint, tile: ClickableTile, isStartingFoundation: Bool = false){
        
        self.isStartingFoundation = isStartingFoundation
        self.builtUponTile = tile
        let texture: SKTexture = SKTexture(imageNamed: "F_tile_power_on")
        super.init(texture: texture, color: .clear, size: FoundationData.SIZE)
        name = "Foundation"
        self.position = position
        zPosition = 1
        physicsBody = SKPhysicsBody(circleOfRadius: FoundationData.SIZE.width/2)
        physicsBody?.categoryBitMask = PhysicsCategory.Foundation
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        physicsBody?.restitution = 0
        physicsBody?.isDynamic = true
        physicsBody?.friction = 0
        physicsBody?.allowsRotation = false
        
    }
    
    func updateFoundationsTexture() {
        
        //Get adjecent points
        let leftPoint = CGPoint(x: self.position.x - (self.size.width), y: self.position.y)
        let rightPoint = CGPoint(x: self.position.x + (self.size.width), y: self.position.y)
        let bottomPoint = CGPoint(x: self.position.x, y: self.position.y - (self.size.height))
        let topPoint = CGPoint(x: self.position.x, y: self.position.y + (self.size.height))
        
        var leftFound: FoundationPlate? = nil
        var rightFound: FoundationPlate? = nil
        var bottomFound: FoundationPlate? = nil
        var topFound: FoundationPlate? = nil
        
        var numberOfAdjecentFound = 0
        
        let foundationPlates = FoundationPlateNodes.foundationPlatesNode.children
        for node in foundationPlates {
            let foundationPlate = node as! FoundationPlate
            
            if foundationPlate.contains(leftPoint) {
                leftFound = foundationPlate
                numberOfAdjecentFound += 1
            }
            if foundationPlate.contains(rightPoint) {
                rightFound = foundationPlate
                numberOfAdjecentFound += 1
            }
            if foundationPlate.contains(topPoint) {
                topFound = foundationPlate
                numberOfAdjecentFound += 1
            }
            if foundationPlate.contains(bottomPoint) {
                bottomFound = foundationPlate
                numberOfAdjecentFound += 1
            }
        }
        
        switch numberOfAdjecentFound {
           
        case 1:
            
            if leftFound != nil{
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_connect_left")
                : SKTexture(imageNamed: "F_tile_power_off_connect_left")
            }
            if rightFound != nil{
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_connect_right")
                : SKTexture(imageNamed: "F_tile_power_off_connect_right")
            }
            if topFound != nil{
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_connect_top")
                : SKTexture(imageNamed: "F_tile_power_off_connect_top")
            }
            if bottomFound != nil{
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_connect_bot")
                : SKTexture(imageNamed: "F_tile_power_off_connect_bot")
            }
            
        case 2:
            
            if topFound != nil && bottomFound != nil{
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_miss_right_n_left")
                : SKTexture(imageNamed: "F_tile_power_off_miss_right_n_left")
            }
            if rightFound != nil && leftFound != nil{
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_miss_top_n_bot")
                : SKTexture(imageNamed: "F_tile_power_off_miss_top_n_bot")
            }
            if topFound != nil && rightFound != nil{
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_miss_left_n_bot")
                : SKTexture(imageNamed: "F_tile_power_off_miss_left_n_bot")
            }
            if rightFound != nil && bottomFound != nil{
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_miss_top_n_left")
                : SKTexture(imageNamed: "F_tile_power_off_miss_top_n_left")
            }
            if bottomFound != nil && leftFound != nil{
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_miss_top_n_right")
                : SKTexture(imageNamed: "F_tile_power_off_miss_top_n_right")
            }
            if leftFound != nil && topFound != nil{
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_miss_right_n_bot")
                : SKTexture(imageNamed: "F_tile_power_off_miss_right_n_bot")
            }

        case 3:
            
            if leftFound == nil {
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_miss_left")
                : SKTexture(imageNamed: "F_tile_power_off_miss_left")
            }
            if rightFound == nil {
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_miss_right")
                : SKTexture(imageNamed: "F_tile_power_off_miss_right")
            }
            if topFound == nil {
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_miss_top")
                : SKTexture(imageNamed: "F_tile_power_off_miss_top")
            }
            if bottomFound == nil {
                texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on_miss_bot")
                : SKTexture(imageNamed: "F_tile_power_off_miss_bot")
            }
            
        case 4:
            
            texture = isPowered ? SKTexture(imageNamed: "F_tile_power_on")
            : SKTexture(imageNamed: "F_tile_power_off")
            
        default:
            texture = SKTexture(imageNamed: "F_tile_power_off_no_connection")
        }
        
    }
    
    func onClick(){
        
        print("isPowered = \(isPowered)")
        
        if hasTower {
            return
            
        }
        let communicator = GameSceneCommunicator.instance
        communicator.cancelAllMenus()
        
        
        communicator.currentFoundation = self
        communicator.showTowerMenu = true
        
    }
    
    func checkIfPowered(gridStart: FoundationPlate) {
            
            if self == gridStart {
                isPoweredChecked = true
            }
            
            isPowered = true
            
            //Get adjecent points
            let leftPoint = CGPoint(x: self.position.x - (self.size.width), y: self.position.y)
            let rightPoint = CGPoint(x: self.position.x + (self.size.width), y: self.position.y)
            let bottomPoint = CGPoint(x: self.position.x, y: self.position.y - (self.size.height))
            let topPoint = CGPoint(x: self.position.x, y: self.position.y + (self.size.height))
            
            var found = [FoundationPlate]()
            
            let foundationPlates = FoundationPlateNodes.foundationPlatesNode.children
            for node in foundationPlates {
                let foundationPlate = node as! FoundationPlate
                
                if foundationPlate.contains(leftPoint) {
                    found.append(foundationPlate)
                }
                if foundationPlate.contains(rightPoint) {
                    found.append(foundationPlate)
                }
                if foundationPlate.contains(topPoint) {
                    found.append(foundationPlate)
                }
                if foundationPlate.contains(bottomPoint) {
                    found.append(foundationPlate)
                }
            }
            
            for foundationPlate in found {
                if !foundationPlate.isPoweredChecked {
                    foundationPlate.isPoweredChecked = true
                    foundationPlate.isPowered = true
                    foundationPlate.checkIfPowered(gridStart: gridStart)
                }
            }
        }
    
    
    func destroy(damageIn: Int) -> Bool{
        
        hp -= damageIn
        
        if hp <= 0{
            
            self.removeFromParent()
            
            GameSceneCommunicator.instance.updateFoundationPower()
            GameSceneCommunicator.instance.updateFoundationTexture()
            
            for node in TowerNode.towersNode.children{
                
                if node is SniperTower{
                    let sniper = node as! SniperTower
                    sniper.sniperLegs.removeFromParent()
                }
                
                let tower = node as! Tower
                
                if tower.builtUponFoundation == self{
                    
                    tower.removeFromParent()
                    tower.towerTexture.removeFromParent()
                    
                }
                
            }
            
            return true
        }
        
        return false
    }
    
    
    
}
