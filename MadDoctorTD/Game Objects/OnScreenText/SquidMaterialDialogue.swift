//
//  SquidMaterialDialogue.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-24.
//

import Foundation

class SquidMaterialObtainedDialogue: Dialogue{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init()")
    }
    
    init() {
        
        var dialogueLines = [String]()
        
        dialogueLines.append("This squid ink will help advance my research....in DESTRUCTION!!!")
        
        super.init(dialogueLines: dialogueLines)
        
    }
    
}
