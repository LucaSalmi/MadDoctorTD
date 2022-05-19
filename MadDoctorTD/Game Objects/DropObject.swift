//
//  DropObject.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-19.
//

import Foundation
import SpriteKit

class DropObject: SKSpriteNode{
    
    var materialType: EnemyRaces? = nil
    let targetNode = SKSpriteNode()
    var direction: CGPoint = CGPoint(x: 0, y: 0)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(startPoint: CGPoint, targetPoint: CGPoint, bossTexture: SKTexture, materialType: EnemyRaces){
        
        let size = CGSize(width: FoundationData.SIZE.width/2, height: FoundationData.SIZE.height/2)
        super.init(texture: bossTexture, color: .clear, size: size)
        self.texture = bossTexture
        self.size.width /= 2
        self.size.height /= 2
        self.speed = CGFloat(10.0)
        self.zPosition = 5
        self.position = startPoint
        self.materialType = materialType
        
        targetNode.position = targetPoint
        targetNode.size = FoundationData.SIZE
        
        setDirection()
        
    }
    
    func setDirection() {
        
        var differenceX = targetNode.position.x - self.position.x
        var differenceY = targetNode.position.y - self.position.y
        
        var isNegativeX = false
        if differenceX < 0 {
            isNegativeX = true
            differenceX *= -1
        }
        
        var isNegativeY = false
        if differenceY < 0 {
            isNegativeY = true
            differenceY *= -1
        }
        
        let differenceH = sqrt((differenceX*differenceX) + (differenceY*differenceY))
        
        differenceX /= differenceH
        differenceY /= differenceH
        
        if isNegativeX {
            differenceX *= -1
        }
        if isNegativeY {
            differenceY *= -1
        }
        
        direction.x = differenceX
        direction.y = differenceY
        
    }
    
    func onDestroy() {
        
        switch materialType{
            
        case .slime:
            GameManager.instance.slimeMaterials += 1
            
        case .squid:
            print("Squid")
            
        case .none:
            print("none")
    
        }
        
        self.removeFromParent()
    }
    
    func update() {
        
        self.position.x += (speed * direction.x)
        self.position.y += (speed * direction.y)
        
        if self.contains(targetNode.position) {
            onDestroy()
        }
    }
    
    
}
