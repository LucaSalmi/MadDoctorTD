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
        zPosition = 2
    
    }
    
    func onClick(){
        
        let communicator = GameSceneCommunicator.instance
        communicator.cancelAllMenus()
        
        communicator.currentTower = self
        
        communicator.showUpgradeMenu = true
        
    }

    private func findNewTarget() {
        
        print("Searching for target...")
        
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
        print("Attacking target: \(currentTarget!)")

        
        
        
    }
    
    func update() {
        
        if currentTarget == nil {
            findNewTarget()
        }
        else {
            let distance = position.distance(point: currentTarget!.position)
            if distance > attackRange {
                currentTarget = nil
                self.constraints = []
                print("Target moved out of sight.")
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
