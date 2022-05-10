//
//  CannonTower.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-10.
//

import Foundation
import SpriteKit

class CannonTower: Tower{
    
    let instance = GameScene.instance!
    var distance: CGFloat?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(position: CGPoint, foundation: FoundationPlate, textureName: String){
        
        super.init(position: position, foundation: foundation, textureName: textureName)
        
        projectileType = ProjectileTypes.sniperProjectile
        
        attackDamage = Int(Double(attackDamage) * 10)
        
        fireRate = Int(Double(fireRate) * 15)
        
        attackRange = attackRange * 1.5
        
        
        
    }
    
    override func attackTarget(){
        
        
        if currentFireRateTick <= 0 {
            let projectile = CannonProjectile(position: position, target: currentTarget!, attackDamage: attackDamage)
            
            
            ProjectileNodes.projectilesNode.addChild(projectile)
            currentFireRateTick = fireRate
        }
        
        distance = CGPointDistanceSquared(from: position, to: currentTarget!.position)
        
        
        
        print(distance)
        
        
        
        
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat{
        
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
}
