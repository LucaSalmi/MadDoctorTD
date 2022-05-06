//
//  RandomNumberGenerator.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-06.
//

import Foundation

struct RandomNumberGenerator{
    
    static func rNG(choises: [EnemyTypes]) -> EnemyTypes{
        
        let x = Int.random(in: 0...choises.count - 1)
        return choises[x]
        
    }
    
    
}


