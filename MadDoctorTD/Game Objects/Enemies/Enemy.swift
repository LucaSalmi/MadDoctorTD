//
//  Enemy.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-04.
//

import Foundation
import SpriteKit
import GameplayKit

class Enemy: SKSpriteNode{
    
    var baseSpeed = EnemiesData.BASE_SPEED
    var isMoving: Bool = false
    var hp = EnemiesData.BASE_HP
    var movePoints = [CGPoint]()
    var oldMovePoints = [CGPoint]()
    var direction: CGPoint = CGPoint(x: 0, y: 0)
    var waveSlotSize = EnemiesData.STANDARD_ENEMY_SLOT
    var enemyType: EnemyTypes = .standard
    var armorValue: Int = 0
    
    var isAttacker = false
    var attackTarget: FoundationPlate? = nil
    var precedentTargetPosition: CGPoint? = nil
    var attackPower: Int = EnemiesData.BASE_ATTACK_POWER_VALUE
    var attackSpeed: Int = EnemiesData.BASE_ATTACK_SPEED_VALUE
    var attackCounter: Int = 0

    var startHp = 0
    
    var hpBar: SKSpriteNode?
    var killValue = EnemiesData.BASE_KILL_VALUE
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(texture: SKTexture, color: UIColor){
        
        
        
        let tempColor = UIColor(.indigo)
        super.init(texture: texture, color: tempColor, size: EnemiesData.SIZE)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        
        if GameScene.instance!.waveManager != nil{
            hp += GameScene.instance!.waveManager!.waveNumber * 5
        }
        
        hpBar = SKSpriteNode(texture: SKTexture(imageNamed: "hp_bar_100"))
        
        hpBar!.size.width = 70
        hpBar!.size.height = 15
        hpBar!.position = self.position
        hpBar!.alpha = 0
        hpBar!.zPosition = 50
        GameScene.instance!.hpBarsNode.addChild(hpBar!)
        self.name = "Enemy"

    }
    
    func changeTooAtkTexture() {
        // overiding in subclasses for specific texrures (ex. slime_fast_atker...))
    }
    
    
    func update(){
        
        if hpBar!.alpha < 1 {
            hpBar!.alpha = 1
        }
        
        hpBar!.position.x = self.position.x
        hpBar!.position.y = self.position.y + 35
        
        if !isMoving {
            movePoints = GameScene.instance!.pathfindingTestEnemy!.movePoints
            isMoving = true
        }
                
        if self.enemyType == .flying{
            
            if movePoints.count > 1 {
                let finalPoint = movePoints[movePoints.count-1]
                movePoints = [finalPoint]
            }
        }
        
        if movePoints.isEmpty {
            GameManager.instance.getDamage()
            self.hp = 0
            self.removeFromParent()
            self.hpBar?.removeFromParent()
            return
        }
        
        move()
        
    }
    
    
    private func move() {
        
        if isAttacker {
            
            if attackTarget != nil{
                
                attack()
                return
                
            }else{
                
                let targetPosition = seekAndDestroy()
                if targetPosition != nil{
                    
                    setDirection(targetPoint: targetPosition!)
                    position.x += direction.x * baseSpeed
                    position.y += direction.y * baseSpeed
                    return
                }
            }
        }
        
        let nextPoint = movePoints[0]
        
        setDirection(targetPoint: nextPoint)
        
        position.x += direction.x * baseSpeed
        position.y += direction.y * baseSpeed
        
        if hasReachedPoint(point: nextPoint) {
            
            oldMovePoints.append(movePoints[0])
            movePoints.remove(at: 0)
        }
    }
    
    private func findCenterInTile() -> CGPoint{
        
        guard let foundationsMap = GameScene.instance!.childNode(withName: "background")as? SKTileMapNode else {
            return self.position
        }
        
        return PhysicsUtils.findCenterOfClosestTile(map: foundationsMap, object: self) ?? self.position
        
    }
    
    private func attack(){
        
        if attackCounter >= attackSpeed{
            
            attackCounter = 0
            
            if attackTarget!.getDamage(damageIn: self.attackPower){
                
                attackTarget = nil
                
            }
            
        }else{
            
            attackCounter += 1
            
        }
    }
    
    private func seekAndDestroy() -> CGPoint?{
        
        let foundationPlates = FoundationPlateNodes.foundationPlatesNode.children
        
        var closestDistance = CGFloat(self.size.width * 3)
        
        for node in foundationPlates {
            
            let plate = node as! FoundationPlate
            
            let plateDistance = position.distance(point: plate.position)
            
            if plateDistance < closestDistance {
                closestDistance = plateDistance
                if plateDistance <= self.size.width * 3 {
                    
                    if !plate.isStartingFoundation{
                        return plate.position
                    }
                }
            }
        }
        
        return nil
        
    }
    
    private func setDirection(targetPoint: CGPoint) {
        
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
    
    func getDamage(dmgValue: Int){
        
        hp -= (dmgValue - armorValue)
        
        if hp <= 0{
            
            hpBar!.removeFromParent()
            
            GameManager.instance.currentMoney += self.killValue
            print("KILL VALUE = \(GameManager.instance.currentMoney)")
            
            self.removeFromParent()
            print("Current enemy wave count = \(EnemyNodes.enemiesNode.children.count)")
            SoundManager.playSFX(sfxName: SoundManager.slimeDeathSFX, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
            
        }
        
        var hpLeft = 0
        
        let tenthHP = startHp / 10
        if tenthHP > 0 {
            hpLeft  =  hp / tenthHP
        }
        
        if hpLeft == 0 {
            hpLeft = 1
        }
        hpBar!.texture = SKTexture(imageNamed: "hp_bar_\(hpLeft)0")
        
//        if hp <= Int(Double(startHp) * 0.1) {
//            //TODO: 10% HERE
//            hpBar!.texture = SKTexture(imageNamed: "hp_bar_10")
//        }
//        else if hp <= Int(Double(startHp) * 0.2) {
//            //TODO: 20% HERE
//            hpBar?.texture = SKTexture(imageNamed: "hp_bar_20")
//        }
//        else if hp <= Int(Double(startHp) * 0.3){
//            //TODO: 30% HERE
//            hpBar?.texture = SKTexture(imageNamed: "hp_bar_30")
//        }
//        else if hp <= Int(Double(startHp) * 0.4){
//            //TODO: 40% HERE
//            hpBar?.texture = SKTexture(imageNamed: "hp_bar_40")
//        }
//        else if hp <= Int(Double(startHp) * 0.5){
//            //TODO: 50% HERE
//            hpBar?.texture = SKTexture(imageNamed: "hp_bar_50")
//        }
//        else if hp <= Int(Double(startHp) * 0.6){
//            //TODO: 60% HERE
//            hpBar?.texture = SKTexture(imageNamed: "hp_bar_60")
//        }
//        else if hp <= Int(Double(startHp) * 0.7){
//            //TODO: 70% HERE
//            hpBar?.texture = SKTexture(imageNamed: "hp_bar_70")
//        }
//        else if hp <= Int(Double(startHp) * 0.8){
//            //TODO: 80% HERE
//            hpBar?.texture = SKTexture(imageNamed: "hp_bar_80")
//        }
//        else if hp <= Int(Double(startHp) * 0.9){
//            //TODO: 90% HERE
//            hpBar!.texture = SKTexture(imageNamed: "hp_bar_90")
//        }
    }
    
    private func hasReachedPoint(point: CGPoint) -> Bool {
        
        //create a rect with edges:
        let leftEdge: CGFloat = position.x - (size.width/4)
        let rightEdge: CGFloat = position.x + (size.width/4)
        let bottomEdge: CGFloat = position.y - (size.height/4)
        let topEdge: CGFloat = position.y + (size.height/4)
        
        if point.x > leftEdge && point.x < rightEdge {
            if point.y > bottomEdge && point.y < topEdge {
                return true
            }
        }
        
        return false
    }
    
    
    func getMovePoints() -> [CGPoint] {
        
        var newMovePoints = [CGPoint]()
        
        let gameScene = GameScene.instance!
        
        // Find the player in the scene.
        
        let player = self
        let goal = GameScene.instance!.childNode(withName: "goal")
        
        // Create an array of obstacles, which is every child node, apart from the player node.
        var obstacles = SKNode.obstacles(fromNodeBounds: FoundationPlateNodes.foundationPlatesNode.children.filter({ (element ) -> Bool in
            return element != player
        }))
        let edges = SKNode.obstacles(fromNodeBounds: gameScene.edgesTilesNode.children)
        obstacles.append(contentsOf: edges)
        
        // Assemble a graph based on the obstacles. Provide a buffer radius so there is a bit of space between the
        // center of the player node and the edges of the obstacles.
        let graph = GKObstacleGraph(obstacles: obstacles, bufferRadius: Float(Float(EnemiesData.SIZE.width)*0.8))
        
        // Create a node for the user's current position, and the user's destination.
        let startNode = GKGraphNode2D(point: SIMD2<Float>(Float(player.position.x), Float(player.position.y)))
        let endNode = GKGraphNode2D(point: SIMD2<Float>(Float(goal!.position.x), Float(goal!.position.y)))
        
        // Connect the two nodes just created to graph.
        graph.connectUsingObstacles(node: startNode)
        graph.connectUsingObstacles(node: endNode)
        
        // Find a path from the start node to the end node using the graph.
        let path:[GKGraphNode] = graph.findPath(from: startNode, to: endNode)
        
        // If the path has 0 nodes, then a path could not be found, so return.
        guard path.count > 0 else { print("Error: Path array is empty. No clear path found!"); return newMovePoints }
        
        // Create an array of actions that the player node can use to follow the path.
        //var actions = [SKAction]()
        
        for node:GKGraphNode in path {
            if let point2d = node as? GKGraphNode2D {
                let nextPoint = CGPoint(x: CGFloat(point2d.position.x), y: CGFloat(point2d.position.y))
                //print("Player pos = \(player.position). Next point = \(nextPoint)")
                if player.position == nextPoint {
                    continue
                }
                //                var duration = getDuration(pointA: player.position, pointB: nextPoint, speed: baseSpeed)
                //                if duration <= 0.0 {
                //                    duration = 0.1
                //                }
                //                print("Duration = \(duration)")
                //                let action = SKAction.move(to: nextPoint, duration: duration)
                //                actions.append(action)
                
                newMovePoints.append(nextPoint)
            }
        }
        
        //        // Convert those actions into a sequence action, then run it on the player node.
        //        let sequence = SKAction.sequence(actions)
        //        player.run(sequence, completion: { () -> Void in
        //            // When the action completes, allow the player to move again.
        //            self.moving = false
        //        })
        
        return newMovePoints
    }

    func updatePathfinding() {
        
        //Store old move points
        let oldMovePoints = movePoints
        
        //Get new move points
        movePoints = getMovePoints()
        
        var commonConnectingPoint = movePoints[0]
        
        for i in 0..<movePoints.count {
            
            if oldMovePoints.count-1 > i || movePoints.count-1 > i {
                break
            }
            
            if oldMovePoints[i].x == movePoints[i].x && oldMovePoints[i].y == movePoints[i].y {
                commonConnectingPoint = oldMovePoints[i]
            }
            else {
                break
            }
                
        }
        
        for node in EnemyNodes.enemiesNode.children {
            let enemy = node as! Enemy
            
            if enemy.isAttacker{
                return
            }
            //If enemy has not reached new connecting point, it gets the new path
            if enemy.movePoints.contains(commonConnectingPoint) {
                enemy.movePoints = movePoints
                
                if enemy.oldMovePoints.isEmpty {
                    continue
                }
                
                for i in 0..<enemy.oldMovePoints.count {
                    if enemy.movePoints.count-1 > i {
                        break
                    }
                    if enemy.oldMovePoints[i].x == enemy.movePoints[i].x &&
                            enemy.oldMovePoints[i].y == enemy.movePoints[i].y {
                        
                        enemy.movePoints.remove(at: i)
                        
                    }
                }
            }
        }
    }
    
    
    
}
