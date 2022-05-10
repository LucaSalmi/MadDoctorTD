//
//  ContentView.swift
//  MadDoctorTD
//
//  Created by Luca Salmi on 2022-05-03.
//

import SwiftUI
import CoreData
import SpriteKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @ObservedObject var appManager = AppManager.appManager

    var body: some View {
        
        ZStack {
            
            switch (appManager.state) {
            case AppState.startMenu:
                MainMenuView()
            case AppState.gameScene:
                GameSceneView()
            case AppState.settingsMenu:
                SettingsView(title: "Settings")
            default:
                LabSceneView()
            }
            
            /*
            VStack {
                HStack {
                    Button(action: {
                        appManager.state = AppState.startMenu
                    }, label: {
                        Text("Start Menu")
                    })
                    Button(action: {
                        appManager.state = AppState.gameScene
                    }, label: {
                        Text("Game")
                    })
                    Button(action: {
                        appManager.state = AppState.labMenu
                    }, label: {
                        Text("Lab")
                    })
                }
                Spacer()
            }
             */
            
        }

    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
