//
//  MineProjectile.swift
//  MadDoctorTD
//
//  Created by Calle Höglund on 2022-05-25.
//

import Foundation
import SpriteKit


class MineProjectile: AoeProjectile{
    
    var mineTimer: Int = 900
    var tick: Int = 0
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    override init(position: CGPoint, target: Enemy, attackDamage: Int){
        
        super.init(position: position, target: target, attackDamage: attackDamage)
        self.alpha = 1
        texture = SKTexture(imageNamed: "cannon_projectile_slime")
        
        
        
    }
    override func update() {
        
        if !hasReachedTargetPoint(){
            if currentTick > 0 {
                currentTick -= 1
            }
            else {
                self.constraints = []
            }
            
            self.position.x += (direction.x * speed)
            self.position.y += (direction.y * speed)
            
            projectileShadow.position = self.position
            
            
            currentDuration += 1
            
            if currentDuration < (travelDuration/2){
                self.size.width += 0.5
                self.size.height += 0.5
                
                projectileShadow.alpha -= 0.005
                
                
            }
            else{
                self.size.width -= 0.5
                self.size.height -= 0.5
                

                projectileShadow.alpha += 0.005
            }
        }
        else{
            let enemies = findEnemiesInRadius(radius: self.size.height)
            if enemies.count >= 1{
                tick = mineTimer
            }
            if tick >= mineTimer{
                print("thing goes boom")
                destroy()
            }
            tick += 1
        }
        
    
        guard let worldEdge = GameScene.instance!.childNode(withName: "superBackground") else {return}
        
        if position.x > worldEdge.frame.size.width / 2 || position.x < (worldEdge.frame.size.width / 2) * -1 ||
            position.y > worldEdge.frame.size.height / 2 || position.y < (worldEdge.frame.size.height / 2) * -1
        {
            destroy()
        }
        
    }
    
    override func destroy() {
        
        super.destroy()
        print("self removed")
        //Spawn explosion here
        let enemies = findEnemiesInRadius(radius: blastRadius)
        
        for enemy in enemies {
            enemy.getDamage(dmgValue: attackDamage)
        }
        
        let gameScene = GameScene.instance!
        
        SoundManager.playSFX(
            sfxName: SoundManager.cannonTowerImpactSFX,
            scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension
        )
        if let particle = SKEmitterNode(fileNamed: "CannonExplosion") {
            particle.position = position
            particle.zPosition = 5
            gameScene.addChild(particle)

            gameScene.run(SKAction.wait(forDuration: 1)) {
                particle.removeFromParent()
            }
        }
                
        
        self.removeFromParent()
        
        
        
    }
    
}
