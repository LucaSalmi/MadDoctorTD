//
//  Animatable.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-25.
//

import Foundation
import SpriteKit

enum AnimatableData{
    
    static let standardSlimeNOF = 11
    static let fastSlimeNOF = 8
    static let heavySlimeNOF = 11
    static let flyingSlimeNOF = 8
    static let bossSlimeNOF = 11
    static let timePerFrameSlime = 0.5
    
}

protocol Animatable: AnyObject{
    
    var animationFrames: [SKAction] {get set}
    
}

extension Animatable{
    
    
    func createSlimeAnimations(enemyType: EnemyTypes){
        
        switch enemyType {
            
        case .standard:
            
            for i in 1...AnimatableData.standardSlimeNOF - 1{
                
                let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "slime animation \(i)"),
                SKTexture(imageNamed: "slime animation \(i+1)")
                ], timePerFrame: AnimatableData.timePerFrameSlime)
                animationFrames.append(frame)
            }
            
            let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "slime animation \(AnimatableData.standardSlimeNOF)"),
            SKTexture(imageNamed: "slime animation \(1)")
            ], timePerFrame: AnimatableData.timePerFrameSlime)
            animationFrames.append(frame)
            
        case .fast:
            
            for i in 1...AnimatableData.fastSlimeNOF - 1{
                
                let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "slime_fast_\(i)"),
                SKTexture(imageNamed: "slime_fast_\(i+1)")
                ], timePerFrame: AnimatableData.timePerFrameSlime)
                animationFrames.append(frame)
            }
            
            let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "slime_fast_\(AnimatableData.fastSlimeNOF)"),
            SKTexture(imageNamed: "slime_fast_\(1)")
            ], timePerFrame: AnimatableData.timePerFrameSlime)
            animationFrames.append(frame)
            
        case .heavy:
            
            for i in 1...AnimatableData.heavySlimeNOF - 1{
                
                let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "heavy_slime_animation_\(i)"),
                SKTexture(imageNamed: "heavy_slime_animation_\(i+1)")
                ], timePerFrame: AnimatableData.timePerFrameSlime)
                animationFrames.append(frame)
            }
            
            let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "heavy_slime_animation_\(AnimatableData.heavySlimeNOF)"),
            SKTexture(imageNamed: "heavy_slime_animation_\(1)")
            ], timePerFrame: AnimatableData.timePerFrameSlime)
            animationFrames.append(frame)
            
        case .flying:
            
            for i in 1...AnimatableData.flyingSlimeNOF - 1{
                
                let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "fly_slime_animation_\(i)"),
                SKTexture(imageNamed: "fly_slime_animation_\(i+1)")
                ], timePerFrame: AnimatableData.timePerFrameSlime)
                animationFrames.append(frame)
            }
            
            let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "fly_slime_animation_\(AnimatableData.flyingSlimeNOF)"),
            SKTexture(imageNamed: "fly_slime_animation_\(1)")
            ], timePerFrame: AnimatableData.timePerFrameSlime)
            animationFrames.append(frame)
            
            
        case .boss:
            
            for i in 1...AnimatableData.bossSlimeNOF - 1{
                
                let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "boss_slime_animation_\(i)"),
                SKTexture(imageNamed: "boss_slime_animation_\(i+1)")
                ], timePerFrame: AnimatableData.timePerFrameSlime)
                animationFrames.append(frame)
            }
            
            let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "boss_slime_animation_\(AnimatableData.bossSlimeNOF)"),
            SKTexture(imageNamed: "boss_slime_animation_\(1)")
            ], timePerFrame: AnimatableData.timePerFrameSlime)
            animationFrames.append(frame)
        }
        
    }
}
