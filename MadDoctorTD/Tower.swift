//
//  Tower.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-04.
//

import Foundation
import SpriteKit


class Tower: SKSpriteNode{
    
    var builtUponFoundation: FoundationPlate?
    
    var attackRange: CGFloat = TowerData.ATTACK_RANGE
    
    var projectileType: Int = ProjectileTypes.gunProjectile.rawValue
    
    var fireRate: Int = TowerData.FIRE_RATE
    var currentFireRateTick: Int = 0
    
    var currentTarget: Enemy? = nil
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint, foundation: FoundationPlate){
        
        self.builtUponFoundation = foundation
        let texture: SKTexture = SKTexture(imageNamed: "Sand_Grid_DownRightInterior")
        super.init(texture: texture, color: .clear, size: TowerData.size)
        
        name = "Tower"
        self.position = position
        zPosition = 3
    
    }
    
    func onClick(){
        
        let communicator = GameSceneCommunicator.instance
        communicator.cancelAllMenus()
        
        communicator.currentTower = self
        
        communicator.showUpgradeMenu = true
        
    }

    private func findNewTarget() {
        
        let gameScene = GameScene.instance!
        
        let enemies = gameScene.enemiesNode.children
        
        var closestDistance = CGFloat(attackRange+1)
        
        
        for node in enemies {
            
            let enemy = node as! Enemy
            
            let enemyDistance = position.distance(point: enemy.position)
            
            if enemyDistance < closestDistance {
                closestDistance = enemyDistance
                if enemyDistance <= attackRange {
                    currentTarget = enemy
                    print("Target found!")
                }
            }
        }
        
    }
    
    private func attackTarget() {


        if currentFireRateTick <= 0 {
            
            
            let gameScene = GameScene.instance!
            
            switch projectileType {
                
            case ProjectileTypes.gunProjectile.rawValue:
                
                if gameScene.gunProjectilesPool.isEmpty {
                    let projectile = GunProjectile(position: self.position, target: currentTarget!)
                    gameScene.projectilesNode.addChild(projectile)
                }
                else {
                    //let projectile = GunProjectile(position: self.position, target: currentTarget!)
                    let projectile = gameScene.gunProjectilesPool[0]
                    gameScene.gunProjectilesPool.remove(at: 0)
                    projectile.reuseFromPool(position: self.position, target: currentTarget!)
                    gameScene.projectilesNode.addChild(projectile)
                }
                
                
                
            default:
                print("Error: Could not find projectile type!")
                
            }
            
            currentFireRateTick = fireRate
        }
        
        
    }
    
    func update() {
        
        if currentFireRateTick > 0 {
            currentFireRateTick -= 1
        }
        
        if currentTarget == nil {
            findNewTarget()
        }
        else {
            let distance = position.distance(point: currentTarget!.position)
            if distance > attackRange {
                currentTarget = nil
                self.constraints = []
                print("Target out of sight.")
            }
            else {
                let lookAtConstraint = SKConstraint.orient(to: currentTarget!,
                                            offset: SKRange(constantValue: -CGFloat.pi / 2))
                self.constraints = [ lookAtConstraint ]
                attackTarget()
            }
        }
        
        
        
    }
    
}
