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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint, tile: ClickableTile, isStartingFoundation: Bool = false){
        
        self.isStartingFoundation = isStartingFoundation
        self.builtUponTile = tile
        let texture: SKTexture = SKTexture(imageNamed: "F_tile_power_on")
        super.init(texture: texture, color: .clear, size: FoundationData.size)
        name = "Foundation"
        self.position = position
        zPosition = 1
        physicsBody = SKPhysicsBody(circleOfRadius: FoundationData.size.width/2)
        physicsBody?.categoryBitMask = PhysicsCategory.Foundation
        physicsBody?.collisionBitMask = 0
        physicsBody?.restitution = 0
        physicsBody?.isDynamic = true
        physicsBody?.friction = 0
        physicsBody?.allowsRotation = false
        
    }
    
    func updateFoundationsTexture(isCenterFoundation: Bool = true, isSelling: Bool = false) {
        
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
        
        let foundationPlates = GameScene.instance!.foundationPlatesNode.children
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
                texture = SKTexture(imageNamed: "F_tile_power_on_connect_left")
            }
            if rightFound != nil{
                texture = SKTexture(imageNamed: "F_tile_power_on_connect_right")
            }
            if topFound != nil{
                texture = SKTexture(imageNamed: "F_tile_power_on_connect_top")
            }
            if bottomFound != nil{
                texture = SKTexture(imageNamed: "F_tile_power_on_connect_bot")
            }
            
        case 2:
            
            if topFound != nil && bottomFound != nil{
                texture = SKTexture(imageNamed: "F_tile_power_on_miss_right_n_left")
            }
            if rightFound != nil && leftFound != nil{
                texture = SKTexture(imageNamed: "F_tile_power_on_miss_top_n_bot")
            }
            if topFound != nil && rightFound != nil{
                texture = SKTexture(imageNamed: "F_tile_power_on_miss_left_n_bot")
            }
            if rightFound != nil && bottomFound != nil{
                texture = SKTexture(imageNamed: "F_tile_power_on_miss_top_n_left")
            }
            if bottomFound != nil && leftFound != nil{
                texture = SKTexture(imageNamed: "F_tile_power_on_miss_top_n_right")
            }
            if leftFound != nil && topFound != nil{
                texture = SKTexture(imageNamed: "F_tile_power_on_miss_right_n_bot")
            }

        case 3:
            
            if leftFound == nil {
                if !isCenterFoundation {
                    print("DANNE: left missing!")
                }
                texture = SKTexture(imageNamed: "F_tile_power_on_miss_left")
            }
            if rightFound == nil {
                if !isCenterFoundation {
                    print("DANNE: right missing!")
                }
                texture = SKTexture(imageNamed: "F_tile_power_on_miss_right")
            }
            if topFound == nil {
                if !isCenterFoundation {
                    print("DANNE: top missing!")
                }
                texture = SKTexture(imageNamed: "F_tile_power_on_miss_top")
            }
            if bottomFound == nil {
                if !isCenterFoundation {
                    print("DANNE: bottom missing!")
                }
                texture = SKTexture(imageNamed: "F_tile_power_on_miss_bot")
            }
            
        case 4:
            
            texture = SKTexture(imageNamed: "F_tile_power_on")
            
        default:
            texture = SKTexture(imageNamed: "F_tile_power_off_no_connection")
        }
        
        if isCenterFoundation {
            leftFound?.updateFoundationsTexture(isCenterFoundation: false)
            rightFound?.updateFoundationsTexture(isCenterFoundation: false)
            topFound?.updateFoundationsTexture(isCenterFoundation: false)
            bottomFound?.updateFoundationsTexture(isCenterFoundation: false)
        }
        
    }
    
    func onClick(){
        
        
        if hasTower {
            return
            
        }
        let communicator = GameSceneCommunicator.instance
        communicator.cancelAllMenus()
        
        
        communicator.currentFoundation = self
        communicator.showTowerMenu = true
        
    }
    
}
