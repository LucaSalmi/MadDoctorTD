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
    
    var projectileType: ProjectileTypes = ProjectileTypes.gunProjectile
    
    var fireRate: Int = TowerData.FIRE_RATE
    var attackDamage: Int = TowerData.ATTACK_DAMAGE
    
    var currentFireRateTick: Int = 0
    
    var currentTarget: Enemy? = nil
    
    var towerTexture = SKSpriteNode()
    var noPowerTexture = SKSpriteNode()
    
    var upgradeCount: Int = 1
    
    var damageUpgradeCount: Int = 0
    var rangeUpgradeCount: Int = 0
    var rateOfFireUpgradeCount: Int = 0
    
    var towerName = "Default Tower"
    
    
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
        towerTexture.zPosition = 4
        
        noPowerTexture = SKSpriteNode(texture: SKTexture(imageNamed: "no_power_symbol"), color: .clear, size: TowerData.POWER_OFF_SIZE)
        noPowerTexture.zPosition = self.zPosition + 1
        noPowerTexture.position = self.position
        noPowerTexture.alpha = 0
        GameScene.instance!.towerIndicatorsNode.addChild(noPowerTexture)
        
    }
    
    func getName() -> String{
        return self.towerName
    }
    
    func onClick() {
        
        guard let gameScene = GameScene.instance else { return }
        
        gameScene.displayRangeIndicator(attackRange: attackRange, position: self.position)
        let communicator = GameSceneCommunicator.instance
        communicator.cancelAllMenus()

        communicator.currentTower = self
        communicator.currentFoundation = self.builtUponFoundation

        communicator.showUpgradeMenu = true
        communicator.showUpgradeMenuUI = true
        
        gameScene.towerImage?.texture = towerTexture.texture!
        gameScene.damageImage?.texture = SKTexture(imageNamed: "power_upgrade_\(self.damageUpgradeCount)")

        gameScene.rangeImage?.texture = SKTexture(imageNamed: "range_upgrade_\(self.rangeUpgradeCount)")

        gameScene.rateOfFireImage?.texture = SKTexture(imageNamed: "speed_upgrade_\(self.rateOfFireUpgradeCount)")
        
        gameScene.towerNameText?.text = self.getName()
        
        gameScene.sellFoundationButton?.alpha = 0
        gameScene.showUpgradeUI()
        
        if builtUponFoundation!.isStartingFoundation {
            gameScene.foundationMenuToggle?.alpha = 0
        }
        else {
            gameScene.foundationMenuToggle?.alpha = 1
        }
        
    }
    
    private func findNewTarget() {

        let enemies = EnemyNodes.enemiesNode.children
        
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
    
    func attackTarget() {
        
        if currentFireRateTick <= 0 {
            
            
            ProjectileFactory(firingTower: self).createProjectile()
            
            
            //                let gameScene = GameScene.instance!
            //                if gameScene.gunProjectilesPool.isEmpty {
            //
            //
            //                }
            //                else {
            //
            //                    let index = gameScene.gunProjectilesPool.count-1
            //                    //let projectile = GunProjectile(position: self.position, target: currentTarget!)
            //                    let projectile = gameScene.gunProjectilesPool[index]
            //                    gameScene.gunProjectilesPool.remove(at: index)
            //                    projectile.reuseFromPool(position: self.position, target: currentTarget!, attackDamage: attackDamage)
            //
            //                    if projectile.parent == nil{
            //                        gameScene.projectilesNode.addChild(projectile)
            //
            //                    }
            //                }
            currentFireRateTick = fireRate
        }
        
        
    }
    
    func upgrade(upgradeType : UpgradeTypes){
        
        let gameManager = GameManager.instance
        
        switch upgradeType {
        case .damage:
            
            //Base upgrade
            if self is GunTower && damageUpgradeCount == 1 && !gameManager.gunTowerDamageUnlocked {
                return
            }
            if self is RapidFireTower && damageUpgradeCount == 1 && !gameManager.rapidFireTowerDamageUnlocked {
                return
            }
            if self is SniperTower && damageUpgradeCount == 1 && !gameManager.sniperTowerDamageUnlocked {
                return
            }
            if self is CannonTower && damageUpgradeCount == 1 && !gameManager.cannonTowerDamageUnlocked {
                return
            }
            
            //Material upgrade
            if self is GunTower && damageUpgradeCount == 2 && !gameManager.bouncingProjectilesUnlocked {
                return
            }
            else if self is GunTower {
                let gunTower = self as! GunTower
                gunTower.activateBouncingProjectiles()
            }
            if self is RapidFireTower && damageUpgradeCount == 2 {
                return
            }
            else if self is RapidFireTower {
                //material upgrade goes here
            }
            if self is SniperTower && damageUpgradeCount == 2 {
                return
            }
            else if self is SniperTower {
                //material upgrade goes here
            }
            if self is CannonTower && damageUpgradeCount == 2 {
                return
            }
            else if self is CannonTower {
                //material upgrade goes here
            }
            
            attackDamage = Int(Double(attackDamage) * TowerData.UPGRADE_DAMAGE_BONUS_PCT)
            damageUpgradeCount += 1
            GameScene.instance?.damageImage?.texture = SKTexture(imageNamed: "power_upgrade_\(damageUpgradeCount)")
            SoundManager.playSFX(sfxName: SoundManager.upgradeSounds[damageUpgradeCount - 1], scene: scene!, sfxExtension: SoundManager.mp3Extension)

            
        case .range:
            
            //Base upgrade
            if self is GunTower && rangeUpgradeCount == 1 && !gameManager.gunTowerRangeUnlocked {
                return
            }
            if self is RapidFireTower && rangeUpgradeCount == 1 && !gameManager.rapidFireTowerRangeUnlocked {
                return
            }
            if self is SniperTower && rangeUpgradeCount == 1 && !gameManager.sniperTowerRangeUnlocked {
                return
            }
            if self is CannonTower && rangeUpgradeCount == 1 && !gameManager.cannonTowerRangeUnlocked {
                return
            }
            
            //Material upgrade
            if self is GunTower && rangeUpgradeCount == 2 {
                return
            }
            else if self is GunTower {
                //material upgrade goes here
            }
            if self is RapidFireTower && rangeUpgradeCount == 2 {
                return
            }
            else if self is RapidFireTower {
                //material upgrade goes here
            }
            if self is SniperTower && rangeUpgradeCount == 2 {
                return
            }
            else if self is SniperTower {
                //material upgrade goes here
            }
            if self is CannonTower && rangeUpgradeCount == 2 {
                return
            }
            else if self is CannonTower {
                //material upgrade goes here
            }
            
            attackRange = CGFloat(Double(attackRange) * TowerData.UPGRADE_RANGE_BONUS_PCT)
            GameScene.instance!.displayRangeIndicator(attackRange: attackRange, position: self.position)
            rangeUpgradeCount += 1
            GameScene.instance?.rangeImage?.texture = SKTexture(imageNamed: "range_upgrade_\(rangeUpgradeCount)")
            SoundManager.playSFX(sfxName: SoundManager.upgradeSounds[rangeUpgradeCount - 1], scene: scene!, sfxExtension: SoundManager.mp3Extension)

        case .firerate:
            
            //Base upgrade
            if self is GunTower && rateOfFireUpgradeCount == 1 && !gameManager.gunTowerSpeedUnlocked {
                return
            }
            if self is RapidFireTower && rateOfFireUpgradeCount == 1 && !gameManager.rapidFireTowerSpeedUnlocked {
                return
            }
            if self is SniperTower && rateOfFireUpgradeCount == 1 && !gameManager.sniperTowerSpeedUnlocked {
                return
            }
            if self is CannonTower && rateOfFireUpgradeCount == 1 && !gameManager.cannonTowerSpeedUnlocked {
                return
            }
            
            //Material upgrade
            if self is GunTower && rateOfFireUpgradeCount == 2 {
                return
            }
            else if self is GunTower {
                //material upgrade goes here
            }
            if self is RapidFireTower && rateOfFireUpgradeCount == 2 {
                return
            }
            else if self is RapidFireTower {
                //material upgrade goes here
            }
            if self is SniperTower && rateOfFireUpgradeCount == 2 {
                return
            }
            else if self is SniperTower {
                //material upgrade goes here
            }
            if self is CannonTower && rateOfFireUpgradeCount == 2 {
                return
            }
            else if self is CannonTower {
                //material upgrade goes here
            }
            
            fireRate = Int(Double(fireRate) * TowerData.UPGRADE_FIRE_RATE_REDUCTION_PCT)
            rateOfFireUpgradeCount += 1
            GameScene.instance?.rateOfFireImage?.texture = SKTexture(imageNamed: "speed_upgrade_\(rateOfFireUpgradeCount)")
            SoundManager.playSFX(sfxName: SoundManager.upgradeSounds[rateOfFireUpgradeCount - 1], scene: scene!, sfxExtension: SoundManager.mp3Extension)

        }
        
        upgradeCount += 1
    }

    func update() {
        
        if !builtUponFoundation!.isPowered {
            if noPowerTexture.alpha != 1{
                noPowerTexture.alpha = 1
            }
            return
        }
        
        if noPowerTexture.alpha != 0{
            noPowerTexture.alpha = 0
        }
        
        if currentFireRateTick > 0 {
            currentFireRateTick -= 1
        }
        
        if currentTarget == nil || currentTarget!.hp <= 0 {
            if self is RapidFireTower{
                let rapidFireTower = self as! RapidFireTower
                
                if !rapidFireTower.resetTexture{
                    rapidFireTower.resetTexture = true
                }
            }
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

    func onDestroy(){
        
        self.removeFromParent()
        self.towerTexture.removeFromParent()
        self.noPowerTexture.removeFromParent()
        
    }
}



