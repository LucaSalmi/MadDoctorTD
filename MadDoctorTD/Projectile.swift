//
//  Projectile.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-04.
//

import Foundation
import SpriteKit

class Projectile: SKSpriteNode {
    
    var currentTick = 5
    
    let targetPoint: CGPoint
    
    var direction: CGPoint = CGPoint(x: 0, y: 0)

    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint, target: Enemy){
        
        self.targetPoint = target.position
        
        super.init(texture: nil, color: .clear, size: ProjectileData.size)
        
        self.position = position
        self.zPosition = 2
        self.speed = ProjectileData.speed
        let lookAtConstraint = SKConstraint.orient(to: target,
                                    offset: SKRange(constantValue: -CGFloat.pi / 2))
        self.constraints = [ lookAtConstraint ]
        setDirection()
    }
    
    private func setDirection() {
        
        var differenceX = targetPoint.x - self.position.x
        var differenceY = targetPoint.y - self.position.y
        
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

    func update() {
        
        if currentTick > 0 {
            currentTick -= 1
        }
        else {
            self.constraints = []
        }
        
        self.position.x += (direction.x * speed)
        self.position.y += (direction.y * speed)
        
    }
    
}
