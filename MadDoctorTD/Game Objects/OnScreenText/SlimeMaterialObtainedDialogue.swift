//
//  SlimeMaterialObtainedDialogue.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-19.
//

import Foundation

class SlimeMaterialObtainedDialogue: Dialogue{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init() {
        
        var dialogueLines = [String]()
        
        dialogueLines.append("I found some slime material for my research! NICE!")
        
        super.init(dialogueLines: dialogueLines)
        
    }
    
}
