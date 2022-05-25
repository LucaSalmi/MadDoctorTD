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
    
    func createSlimeAnimations(enemyType: EnemyTypes, textureName: String){
        
        switch enemyType {
            
        case .standard:
            
            for i in 1...AnimatableData.standardSlimeNOF - 1{
                
                let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "\(textureName)\(i)"),
                SKTexture(imageNamed: "\(textureName)\(i+1)")
                ], timePerFrame: AnimatableData.timePerFrameSlime)
                animationFrames.append(frame)
            }
            
            let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "\(textureName)\(AnimatableData.standardSlimeNOF)"),
            SKTexture(imageNamed: "\(textureName)\(1)")
            ], timePerFrame: AnimatableData.timePerFrameSlime)
            animationFrames.append(frame)
            
        case .fast:
            
            for i in 1...AnimatableData.fastSlimeNOF - 1{
                
                let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "\(textureName)\(i)"),
                SKTexture(imageNamed: "\(textureName)\(i+1)")
                ], timePerFrame: AnimatableData.timePerFrameSlime)
                animationFrames.append(frame)
            }
            
            let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "\(textureName)\(AnimatableData.fastSlimeNOF)"),
            SKTexture(imageNamed: "s\(textureName)\(1)")
            ], timePerFrame: AnimatableData.timePerFrameSlime)
            animationFrames.append(frame)
            
        case .heavy:
            
            for i in 1...AnimatableData.heavySlimeNOF - 1{
                
                let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "\(textureName)\(i)"),
                SKTexture(imageNamed: "\(textureName)\(i+1)")
                ], timePerFrame: AnimatableData.timePerFrameSlime)
                animationFrames.append(frame)
            }
            
            let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "\(textureName)\(AnimatableData.heavySlimeNOF)"),
            SKTexture(imageNamed: "\(textureName)\(1)")
            ], timePerFrame: AnimatableData.timePerFrameSlime)
            animationFrames.append(frame)
            
        case .flying:
            
            for i in 1...AnimatableData.flyingSlimeNOF - 1{
                
                let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "\(textureName)\(i)"),
                SKTexture(imageNamed: "\(textureName)\(i+1)")
                ], timePerFrame: AnimatableData.timePerFrameSlime)
                animationFrames.append(frame)
            }
            
            let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "\(textureName)\(AnimatableData.flyingSlimeNOF)"),
            SKTexture(imageNamed: "\(textureName)\(1)")
            ], timePerFrame: AnimatableData.timePerFrameSlime)
            animationFrames.append(frame)
            
            
        case .boss:
            
            for i in 1...AnimatableData.bossSlimeNOF - 1{
                
                let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "\(textureName)\(i)"),
                SKTexture(imageNamed: "\(textureName)\(i+1)")
                ], timePerFrame: AnimatableData.timePerFrameSlime)
                animationFrames.append(frame)
            }
            
            let frame: SKAction = SKAction.animate(with: [
                SKTexture(imageNamed: "\(textureName)\(AnimatableData.bossSlimeNOF)"),
            SKTexture(imageNamed: "\(textureName)\(1)")
            ], timePerFrame: AnimatableData.timePerFrameSlime)
            animationFrames.append(frame)
        }
        
    }
}
