//
//  RandomNumberGenerator.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-06.
//

import Foundation

struct RandomNumberGenerator{
    
    static func rNG(start: Int, end: Int) -> Int{
        
        return Int.random(in: start...end)
        
    }
    
    
}


