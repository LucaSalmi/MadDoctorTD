//
//  MadDoctorTDApp.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import SwiftUI

@main
struct MadDoctorTDApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}
