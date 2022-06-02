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
    //var placeboCount: Int = 1
    
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
        GameScene.instance!.uiManager!.towerIndicatorsNode.addChild(noPowerTexture)
        
    }
    
    func getName() -> String{
        return self.towerName
    }
    
    func onClick() {
        
        guard let gameScene = GameScene.instance else { return }
        
        gameScene.uiManager!.displayRangeIndicator(attackRange: attackRange, position: self.position)
        let communicator = GameSceneCommunicator.instance
        communicator.cancelAllMenus()
        
        communicator.currentTower = self
        communicator.currentFoundation = self.builtUponFoundation
        
        communicator.showUpgradeMenu = true
        communicator.showUpgradeMenuUI = true
        
        gameScene.uiManager!.towerImage?.texture = towerTexture.texture!
        
        if self is GunTower && damageUpgradeCount == 3{
            
            gameScene.uiManager!.damageImage?.texture = SKTexture(imageNamed: "power_upgrade_\(self.damageUpgradeCount)_bounce")
        }else {
            gameScene.uiManager!.damageImage?.texture = SKTexture(imageNamed: "power_upgrade_\(self.damageUpgradeCount)")
        }
        
        if self is CannonTower && rangeUpgradeCount == 3{
            gameScene.uiManager!.rangeImage?.texture = SKTexture(imageNamed: "range_upgrade_\(self.rangeUpgradeCount)_cannon_mine")
        } else {
            gameScene.uiManager!.rangeImage?.texture = SKTexture(imageNamed: "range_upgrade_\(self.rangeUpgradeCount)")
        }
        
        if self is SniperTower && rateOfFireUpgradeCount == 3{
            gameScene.uiManager!.rateOfFireImage?.texture = SKTexture(imageNamed:"speed_upgrade_\(self.rateOfFireUpgradeCount)_poison")

        }else if self is RapidFireTower && rateOfFireUpgradeCount == 3{
            
            gameScene.uiManager!.rateOfFireImage?.texture = SKTexture(imageNamed: "speed_upgrade_\(self.rateOfFireUpgradeCount)_slow")
            
        }else {
            gameScene.uiManager!.rateOfFireImage?.texture = SKTexture(imageNamed: "speed_upgrade_\(self.rateOfFireUpgradeCount)")
        }
        
        
        
        gameScene.uiManager!.towerNameText?.text = self.getName()
        
        gameScene.uiManager!.sellFoundationButton?.alpha = 0
        gameScene.uiManager!.showUpgradeUI()
        updateUpgradePrice()
        
        if builtUponFoundation!.isStartingFoundation {
            gameScene.uiManager!.foundationMenuToggle?.alpha = 0
        }
        else {
            gameScene.uiManager!.foundationMenuToggle?.alpha = 1
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
                    let lookAtConstraint = SKConstraint.orient(
                        to: currentTarget!,
                        offset: SKRange(constantValue: -CGFloat.pi / 2)
                    )
                    self.towerTexture.constraints = [ lookAtConstraint ]
                    print("Target found!")
                }
            }
        }
    }
    
    func attackTarget() {
        
        if currentFireRateTick <= 0 {
            
            ProjectileFactory(firingTower: self).createProjectile()
            currentFireRateTick = fireRate
        }
    }

    func upgradeParticle() {

    }
    
    func upgrade(upgradeType : UpgradeTypes){

        switch upgradeType {
            
        case .damage:
            
            attackDamage = Int(Double(attackDamage) * TowerData.UPGRADE_DAMAGE_BONUS_PCT)
            damageUpgradeCount += 1
            if damageUpgradeCount < 3 {
                GameScene.instance?.uiManager!.damageImage?.texture = SKTexture(imageNamed: "power_upgrade_\(damageUpgradeCount)")
            }
            SoundManager.playSFX(sfxName: SoundManager.wrench_upgradeSounds[upgradeCount - 1], scene: scene!, sfxExtension: SoundManager.mp3Extension)
            
            
            
            GameScene.instance?.uiManager!.damageImage?.texture = SKTexture(imageNamed: "power_upgrade_\(damageUpgradeCount)")
            SoundManager.playSFX(sfxName: SoundManager.wrench_upgradeSounds[upgradeCount - 1], scene: scene!, sfxExtension: SoundManager.mp3Extension)

        case .range:
            
            attackRange = CGFloat(Double(attackRange) * TowerData.UPGRADE_RANGE_BONUS_PCT)
            GameScene.instance!.uiManager!.displayRangeIndicator(attackRange: attackRange, position: self.position)
            rangeUpgradeCount += 1
            if rangeUpgradeCount < 3 {
                
                GameScene.instance?.uiManager!.rangeImage?.texture = SKTexture(imageNamed: "range_upgrade_\(rangeUpgradeCount)")
            }
            GameScene.instance?.uiManager!.rangeImage?.texture = SKTexture(imageNamed: "range_upgrade_\(rangeUpgradeCount)")
            SoundManager.playSFX(sfxName: SoundManager.wrench_upgradeSounds[upgradeCount - 1], scene: scene!, sfxExtension: SoundManager.mp3Extension)
        case .firerate:
            
            fireRate = Int(Double(fireRate) * TowerData.UPGRADE_FIRE_RATE_REDUCTION_PCT)
            rateOfFireUpgradeCount += 1
            if rateOfFireUpgradeCount < 3 {
                GameScene.instance?.uiManager!.rateOfFireImage?.texture = SKTexture(imageNamed: "speed_upgrade_\(rateOfFireUpgradeCount)")
            }
            GameScene.instance?.uiManager!.rateOfFireImage?.texture = SKTexture(imageNamed: "speed_upgrade_\(rateOfFireUpgradeCount)")
            SoundManager.playSFX(sfxName: SoundManager.wrench_upgradeSounds[upgradeCount - 1], scene: scene!, sfxExtension: SoundManager.mp3Extension)
        }
        
        upgradeCount += 1
        updateUpgradePrice()


    }
    
    func updateUpgradePrice(){
        
        if upgradeCount >= 6 {
            GameScene.instance?.uiManager!.upgradeDamagePrice?.text = ""
            GameScene.instance?.uiManager!.upgradeSpeedPrice?.text = "Max Level"
            GameScene.instance?.uiManager!.upgradeRangePrice?.text = ""
        }
        else {
            GameScene.instance?.uiManager!.upgradeDamagePrice?.text = "$\(GameSceneCommunicator.instance.getUpgradeTowerCost())"
            GameScene.instance?.uiManager!.upgradeSpeedPrice?.text = "$\(GameSceneCommunicator.instance.getUpgradeTowerCost())"
            GameScene.instance?.uiManager!.upgradeRangePrice?.text = "$\(GameSceneCommunicator.instance.getUpgradeTowerCost())"
        }
        
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



