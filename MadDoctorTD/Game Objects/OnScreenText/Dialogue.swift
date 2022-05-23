//
//  Dialogue.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-19.
//

import Foundation
import GameplayKit

enum DialogueSettings {
    
    static let defaultPositionOffsetY: CGFloat = 135
    static let cavePositionOffsetY: CGFloat = 85
    
    static let defaultFontSize: CGFloat = 20
    static let caveFontSize: CGFloat = 12
    
}

class Dialogue: SKSpriteNode {
    
    var shapeNode: SKShapeNode? = nil
    var labelNodes = [SKLabelNode]()
    
    let showingTime = 60 * 4
    var ticks: Int = 0
    
    let positionOffsetY: CGFloat = 150
    let textPadding: CGFloat = 40
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init(dialogueLines: [String]) {
        
        super.init(texture: nil, color: .clear, size: CGSize(width: 0, height: 0))
        
        setupLabelNodes(dialogueLines: dialogueLines)
        
        setupShapeNode()
                
        zPosition = 70
    }
    
    private func setupShapeNode() {
        
        let width = labelNodes[0].frame.width + textPadding
        let numOfLines = CGFloat(labelNodes.count)
        let height = (numOfLines * labelNodes[0].frame.height) + textPadding
        shapeNode = SKShapeNode(rectOf: CGSize(width: width, height: height), cornerRadius: 10.0)
        
        shapeNode!.fillColor = .black
        shapeNode!.alpha = 0.8
        shapeNode!.zPosition = 51
        addChild(shapeNode!)
        
        var lineStart = shapeNode!.position
        lineStart.y += (shapeNode!.frame.size.height/2)
        
        for i in 0..<labelNodes.count {
            let labelNode = labelNodes[i]
            labelNode.position = lineStart
            labelNode.position.y -= CGFloat(i+1) * labelNodes[0].frame.height
            labelNode.position.y -= textPadding/4
        }
        
        anchorPoint.y += (shapeNode!.frame.height/2)
    }
    
    private func setupLabelNodes(dialogueLines: [String]) {
        
        for line in dialogueLines {
            
            let labelNode = SKLabelNode()
            labelNode.text = line
            labelNode.fontColor = .white
            labelNode.fontName = "Chalkduster"
            labelNode.alpha = 1
            labelNode.zPosition = 52
            labelNode.fontSize = DialogueSettings.defaultFontSize
            
            self.labelNodes.append(labelNode)
            addChild(labelNode)
        }
        
    }
    

    
    func update() {
        
        ticks += 1
        if ticks >= showingTime {
            //GameViewController.currentGameScene?.currentDialogue = nil
            self.removeFromParent()
        }
        
    }
    
}

