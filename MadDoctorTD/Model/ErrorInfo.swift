//
//  ErrorInfo.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-20.
//

import Foundation
import SwiftUI
struct ErrorInfo: Identifiable {
    
    var id: String = UUID().uuidString
    let title: String
    let description: String
    
}
