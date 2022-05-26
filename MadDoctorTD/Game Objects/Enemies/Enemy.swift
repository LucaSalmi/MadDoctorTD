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
    var enemyRace: EnemyRaces? = nil
    var armorValue: Int = 0
    
    let poisonDuration = 240
    let poisonDamageInterval = 60
    var poisonTick = 0
    var poisonDamageTick = 60
    var poisonDamage = 0
    
    let slowDuration = 120
    var slowTick = 0
    var textureOffset = CGFloat(10)
    
    
    var isAttacker = false
    var attackTarget: FoundationPlate? = nil
    var precedentTargetPosition: CGPoint? = nil
    var attackPower: Int = EnemiesData.BASE_ATTACK_POWER_VALUE
    var attackSpeed: Int = EnemiesData.BASE_ATTACK_SPEED_VALUE
    var attackCounter: Int = 0
    
    var damageValue = EnemiesData.BASE_DAMAGE_VALUE

    var startHp = 0
    
    var hpBar: SKSpriteNode?
    var isSlowedTexture: SKSpriteNode?
    var isPoisonedTexture: SKSpriteNode?
    var killValue = EnemiesData.BASE_KILL_VALUE
    
    //Animations
    var animationFrames: [SKAction] = []
    var runningFrame = 0
    var frameLimiter = 0
    
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
        
        isSlowedTexture = SKSpriteNode(texture: SKTexture(imageNamed: "slow_icon1"))
        isSlowedTexture!.size.width = 20
        isSlowedTexture!.size.height = 20
        isSlowedTexture!.alpha = 0
        isSlowedTexture!.zPosition = 50
        
        isPoisonedTexture = SKSpriteNode(texture: SKTexture(imageNamed: "poison_icon1"))
        isPoisonedTexture!.size.width = 20
        isPoisonedTexture!.size.height = 20
        isPoisonedTexture!.alpha = 0
        isPoisonedTexture!.zPosition = 50
        
        GameScene.instance!.hpBarsNode.addChild(hpBar!)
        GameScene.instance!.hpBarsNode.addChild(isSlowedTexture!)
        GameScene.instance!.hpBarsNode.addChild(isPoisonedTexture!)
        self.name = "Enemy"

    }
    
    func changeToAtkTexture() {
        // overiding in subclasses for specific texrures (ex. slime_fast_atker...))
    }
    
    
    func update(){
        
        if hpBar!.alpha < 1 {
            hpBar!.alpha = 1
        }
        
        if poisonTick > 0{
            poisonTick -= 1
            poisonDamageTick -= 1
            
            if poisonDamageTick <= 0{
                print("Poisondamage taken")
                getDamage(dmgValue: poisonDamage)
                
                poisonDamageTick = poisonDamageInterval
                
            }
        }
        else{
            if isPoisonedTexture!.alpha != 0{
                isPoisonedTexture?.alpha = 0
            }
        }
        
        if slowTick > 0{
            slowTick -= 1
        }
        else{
            if isSlowedTexture!.alpha != 0{
                isSlowedTexture!.alpha = 0
            }
        }
        
        hpBar!.position.x = self.position.x
        hpBar!.position.y = self.position.y + 35
        
        isSlowedTexture!.position.x = hpBar!.position.x + ((hpBar?.size.width)!/2) + textureOffset
        isSlowedTexture!.position.y = hpBar!.position.y
        
        isPoisonedTexture!.position.x = hpBar!.position.x + ((hpBar?.size.width)!/2) + textureOffset
        isPoisonedTexture!.position.y = hpBar!.position.y
        
        if !isMoving {
            movePoints = GameScene.instance!.pathfindingTestEnemy!.movePoints
            isMoving = true
        }
                
        if self.enemyType == .flying || self.enemyType == .boss{
            
            if movePoints.count > 1 {
                let finalPoint = movePoints[movePoints.count-1]
                movePoints = [finalPoint]
            }
        }
        
        if movePoints.isEmpty {
            
            GameManager.instance.getDamage(incomingDamage: self.damageValue)
            //CHECKPOINT
            SoundManager.playSFX(sfxName: SoundManager.base_hp_loss_1, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
            self.hp = 0
            isSlowedTexture!.removeFromParent()
            isPoisonedTexture!.removeFromParent()
            self.removeFromParent()
            self.hpBar?.removeFromParent()
            
            if self.enemyType == .boss{
                
                let boss = self as! Boss
                boss.bossTexture?.removeFromParent()
                
            }
            return
        }
        
        //Runs Animation
        
        if runningFrame > animationFrames.count-1{
            runningFrame = 0
        }
        if self.enemyType != .boss{
            self.run(animationFrames[runningFrame], withKey: "animation")
        }else{
            let boss = self as? Boss
            boss?.bossTexture!.run(animationFrames[runningFrame], withKey: "animation")
        }
        
        if frameLimiter >= 5{
            runningFrame += 1
            frameLimiter = 0
        }else{
            frameLimiter += 1
        }
        

        
        
        move()
        
    }
    
    
    private func move() {
        
        if isAttacker && enemyType != .boss {
            
            if attackTarget != nil{
                
                attack()
                return
                
            }else{
                
                let targetPosition = seekAndDestroy()
                if targetPosition != nil{
                    
                    setDirection(targetPoint: targetPosition!)
                    if slowTick <= 0{
                        print("CH not slowed")
                        position.x += direction.x * baseSpeed
                        position.y += direction.y * baseSpeed
                    }
                    else{
                        print("CH slowed")
                        position.x += direction.x * (baseSpeed * ProjectileData.SLOW_EFFECT_PERCENT)
                        position.y += direction.y * (baseSpeed * ProjectileData.SLOW_EFFECT_PERCENT)
                    }
                    
                    return
                }
            }
        }
        
        let nextPoint = movePoints[0]
        
        setDirection(targetPoint: nextPoint)
        
        
        if slowTick <= 0{
            print("CH not slowed")
            position.x += direction.x * baseSpeed
            position.y += direction.y * baseSpeed
        }
        else{
            print("CH slowed")
            position.x += direction.x * (baseSpeed * ProjectileData.SLOW_EFFECT_PERCENT)
            position.y += direction.y * (baseSpeed * ProjectileData.SLOW_EFFECT_PERCENT)
        }
        
        
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
    
    func attack(){
        
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
        
        var closestDistance = CGFloat(self.size.width * 4)
        
        for node in foundationPlates {
            
            let plate = node as! FoundationPlate
            
            let plateDistance = position.distance(point: plate.position)
            
            if plateDistance < closestDistance {
                closestDistance = plateDistance
                if plateDistance <= self.size.width * 4 {
                    
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
    
    func onDestroy() {
        
        var moneyTarget = GameScene.instance!.camera!.position
        moneyTarget.x -= 300
        moneyTarget.y += 600
        let moneyObject = MoneyObject(startPosition: self.position)
        GameScene.instance!.moneyNode.addChild(moneyObject)
        
        hpBar!.removeFromParent()
        isSlowedTexture!.removeFromParent()
        isPoisonedTexture!.removeFromParent()
        
        GameManager.instance.currentMoney += self.killValue
        print("KILL VALUE = \(GameManager.instance.currentMoney)")
        
        if self.enemyType == .boss{
            
            let boss = self as! Boss
            var materialTarget = GameScene.instance!.camera!.position
            materialTarget.x -= 300
            materialTarget.y += 600
            let bossDrop = DropObject(startPoint: self.position, targetPoint: materialTarget, materialType: self.enemyRace!)
            
            let dialog = createDialog()
            GameScene.instance?.dialoguesNode.addChild(dialog)
            GameScene.instance!.moneyNode.addChild(bossDrop)
            boss.bossTexture?.removeFromParent()
            
        }
        
        self.removeFromParent()
        print("Current enemy wave count = \(EnemyNodes.enemiesNode.children.count)")
        SoundManager.playSFX(sfxName: SoundManager.slimeDeathSFX, scene: GameScene.instance!, sfxExtension: SoundManager.wavExtension)
        
    }
        
    private func createDialog()-> Dialogue{
        
        switch self.enemyRace{
            
        case .slime:
            return SlimeMaterialObtainedDialogue()
        case .squid:
            return SquidMaterialObtainedDialogue()
        case .none:
            return SlimeMaterialObtainedDialogue()
        }
        
        
    }
    
    func getDamage(dmgValue: Int, projectile: Projectile? = nil){
        
        if projectile is PoisonProjectile{
            poisonTick = poisonDuration
            isPoisonedTexture?.alpha = 1
            poisonDamage = Int(CGFloat(projectile!.attackDamage) * ProjectileData.POISON_DAMAGE_PERCENT)
            
            //PoisonTexture here
            
        }
        
        if projectile is GunProjectile{
            let gunProjectile = projectile as! GunProjectile
            
            if gunProjectile.isSlowUpgraded{
                
                let rand = Int.random(in: 1...20)
                if rand == 7{
                    slowTick = slowDuration
                    isSlowedTexture!.alpha = 1
                    
                    //slow icon here
                }
                
                
            }
        }
        
        hp -= (dmgValue - armorValue)
        
        if hp <= 0{
            
            onDestroy()
            
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
                    if enemy.movePoints.count-1 > i || enemy.oldMovePoints.count-1 > i{
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

extension Enemy: Animatable{}
