//
//  Money.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-19.
//

import Foundation
import SpriteKit

class PriceObject: SKSpriteNode {
    
    let targetNode = SKSpriteNode()
    
    var direction: CGPoint = CGPoint(x: 0, y: 0)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(startPosition: CGPoint, targetPoint: CGPoint) {
        super.init(texture: nil, color: .red, size: FoundationData.SIZE)
        self.position = startPosition
        self.speed = CGFloat(15.0)
        self.zPosition = 5
        
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
