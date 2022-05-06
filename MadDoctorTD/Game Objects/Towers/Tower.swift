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
    var attackDamage: Int = TowerData.ATTACK_DAMAGE
    
    var currentFireRateTick: Int = 0
    
    var currentTarget: Enemy? = nil
    
    var towerTexture = SKSpriteNode()
    
    var upgradeCount: Int = 1
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(position: CGPoint, foundation: FoundationPlate, textureName: String){
        
        self.builtUponFoundation = foundation
        towerTexture = SKSpriteNode(texture: SKTexture(imageNamed: textureName), color: .clear, size: TowerData.TEXTURE_SIZE)
        super.init(texture: nil, color: .clear, size: TowerData.TILE_SIZE)
        
        name = "Tower"
        self.position = position
        zPosition = 3
        
        towerTexture.position = position
        towerTexture.zPosition = 2
        
        
    }
    
    func onClick(){
        
        displayRangeIndicator()
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
                    let projectile = GunProjectile(position: self.position, target: currentTarget!, attackDamage: attackDamage)
                    gameScene.projectilesNode.addChild(projectile)
                }
                else {
                    
                    let index = gameScene.gunProjectilesPool.count-1
                    //let projectile = GunProjectile(position: self.position, target: currentTarget!)
                    let projectile = gameScene.gunProjectilesPool[index]
                    gameScene.gunProjectilesPool.remove(at: index)
                    projectile.reuseFromPool(position: self.position, target: currentTarget!, attackDamage: attackDamage)
                    
                    if projectile.parent == nil{
                        gameScene.projectilesNode.addChild(projectile)
                        
                    }
                }
                
            case ProjectileTypes.rapidFireProjectile.rawValue:
                
                let rapidFireTower = self as! RapidFireTower
                
                let projectile = GunProjectile(position: self.position, target: currentTarget!, attackDamage: attackDamage)
                
                if rapidFireTower.fireLeft{
                    projectile.texture = SKTexture(imageNamed: "speed_projectile_left")
                }else{
                    projectile.texture = SKTexture(imageNamed: "speed_projectile_right")
                }
                rapidFireTower.fireLeft = !rapidFireTower.fireLeft
                gameScene.projectilesNode.addChild(projectile)
                
                
                
            case ProjectileTypes.sniperProjectile.rawValue:
                
                let projectile = SniperProjectile(position: self.position, target: currentTarget!, attackDamage: attackDamage)
                gameScene.projectilesNode.addChild(projectile)
                
                
            default:
                print("Error: Could not find projectile type!")
                
            }
            
            currentFireRateTick = fireRate
        }
        
        
    }
    
    func upgrade(upgradeType : UpgradeTypes){
        
        if upgradeCount <= TowerData.MAX_UPGRADE{
            
            switch upgradeType {
            case .damage:
                attackDamage = Int(Double(attackDamage) * TowerData.UPGRADE_DAMAGE_BONUS_PCT)
            case .range:
                attackRange = CGFloat(Double(attackRange) * TowerData.UPGRADE_RANGE_BONUS_PCT)
                displayRangeIndicator()
            case .firerate:
                fireRate = Int(Double(fireRate) * TowerData.UPGRADE_FIRE_RATE_REDUCTION_PCT)
            }
            
            upgradeCount += 1
            
        }
        
        
        
        
    }

    
    func update() {
        
        if !builtUponFoundation!.isPowered {
            return
        }
        
        if currentFireRateTick > 0 {
            currentFireRateTick -= 1
        }
        
        if currentTarget == nil || currentTarget!.hp <= 0 {
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
                self.towerTexture.constraints = [ lookAtConstraint ]
                attackTarget()
            }
        }
    }
    
    func displayRangeIndicator(){
        
        guard let gameScene = GameScene.instance else{return}
        
        if gameScene.rangeIndicator != nil{
            gameScene.rangeIndicator!.removeFromParent()
            
        }
        
        gameScene.rangeIndicator = SKShapeNode(circleOfRadius: attackRange)
        gameScene.rangeIndicator!.name = "RangeIndicator"
        gameScene.rangeIndicator!.fillColor = SKColor(.white.opacity(0.2))
        
        gameScene.rangeIndicator!.zPosition = 2
        gameScene.rangeIndicator!.position = position
        
        GameScene.instance?.addChild(gameScene.rangeIndicator!)
        
    }
    
}


