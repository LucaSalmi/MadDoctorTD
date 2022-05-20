//
//  GameSceneView.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    
    var gameScene: SKScene
    
    @ObservedObject var communicator = GameSceneCommunicator.instance
    @ObservedObject var gameManager = GameManager.instance
    
    init() {
        
        if GameScene.instance == nil {
            gameScene = SKScene(fileNamed: "GameScene")!
        }
        else {
            gameScene = GameScene.instance!
        }
        gameScene.scaleMode = .aspectFill
        communicator.cancelAllMenus()

    }

    var body: some View {

        ZStack {
            SpriteView(scene: gameScene, debugOptions: [.showsFPS, .showsNodeCount])
                .ignoresSafeArea()
                .blur(radius: gameManager.isPaused ? 5 : 0)
                
            
            VStack {
                
                if gameManager.isPaused {
                    
                    VStack(spacing: 20){
                        SettingsView(title: "Paused")
                        
                        Button {
                            AppManager.appManager.state = .startMenu
                        } label: {
                            Text("Main Menu")
                        }
                        

                    }.padding(50)
                        .background(Color.white.opacity(0.5))
                    
                        
                }else if GameManager.instance.isGameOver{
                    
                    GameOverView()
                    
                }
                else {
                    HStack {
                        
                        HStack(alignment: .center){
                        
                        
                        
                            Text("\(gameManager.currentMoney)$")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(.black)
                                .cornerRadius(10)
                        }
                        .frame(minWidth: UIScreen.main.bounds.width * 0.25)
                        
                        Spacer()
                        
                        HStack(alignment: .center){
                        
                        Text("Wave: \(gameManager.currentWave)")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(.black)
                            .cornerRadius(10)
                            
                            }
                            .frame(minWidth: UIScreen.main.bounds.width * 0.25)
                            
                        Spacer()
                        
                        HStack(alignment: .center){
                            
                            Text("HP: \(gameManager.baseHp)")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(.black)
                                .cornerRadius(10)
                        
                            Button {
                                communicator.cancelAllMenus()
                                withAnimation{
                                    gameManager.isPaused = true
                                }
                                
                            } label: {
                                Text("||")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(.black)
                                    .cornerRadius(10)
                            }.disabled(communicator.foundationEditMode ? true : false)

                            
                        }
                        .frame(minWidth: UIScreen.main.bounds.width * 0.25)
                            
                    }
                    .padding(10)
                    
                    HStack{
                    
                    HStack(alignment: .center){
                        
                        if communicator.foundationEditMode {
                            Text("total cost:\(communicator.newFoundationTotalCost)")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(.black)
                                .cornerRadius(10)
                        }
                    }
                    .frame(minWidth: UIScreen.main.bounds.width * 0.25)
                        
                        Spacer()
                        
                    }
                    .padding(10)
                    
                    Spacer()
                    
                  
                    
                    //TODO: DISPLAY ALERT WHEN NEW WAVE IS INCOMMING!
                    
                    
//                    if communicator.isBuildPhase && !communicator.openDoors {
//                        HStack() {
//
//                            Spacer()
//
//                            if !communicator.foundationEditMode {
//                                Button {
//                                    AppManager.appManager.state = .labMenu
//                                    SoundManager.playBGM(bgmString: SoundManager.researchViewAtmosphere)
//
//                                } label: {
//                                    Text("Research")
//                                }
//                            }
//
//
//
//                            Spacer()
//
//
//
//
//                    }
//                        .padding(.bottom, 130)
//                }

            }

            
//            if communicator.showTowerMenu{
//
//                VStack(spacing: 25) {
//
//                    //Foundation options:
//                    Button {
//                        communicator.repairFoundation()
//                    } label: {
//                        Text("Repair Foundation")
//                    }.disabled(communicator.isBuildPhase ? false : true)
//                        .disabled(communicator.currentFoundation!.isStartingFoundation ? true : false)
//                    Button {
//                        communicator.upgradeFoundation()
//                    } label: {
//                        Text("Upgrade Foundation")
//                    }.disabled(communicator.isBuildPhase ? false : true)
//                        .disabled(communicator.currentFoundation!.isStartingFoundation ? true : false)
//                    Button {
//                        communicator.sellFoundation()
//                    } label: {
//                        Text("Sell Foundation")
//                    }.disabled(communicator.isBuildPhase ? false : true)
//                        .disabled(communicator.currentFoundation!.isStartingFoundation ? true : false)
//                    Button {
//                        communicator.cancelAllMenus()
//                    } label: {
//                        Text("Cancel")
//                    }
//
//                }.font(.title)
//                    .background(.black.opacity(0.5))

                
            }
//            if communicator.showUpgradeMenu{
//                
//                VStack(spacing: 25){
//                    Text("Upgrade menu")
//                    
//                    Button {
//                        communicator.upgradeTower(upgradeType: .damage)
//                    } label: {
//                        Text("Upgrade damage")
//                    }
//                    Button {
//                        communicator.upgradeTower(upgradeType: .range)
//                    } label: {
//                        Text("Upgrade range")
//                    }
//                    Button {
//                        communicator.upgradeTower(upgradeType: .firerate)
//                    } label: {
//                        Text("Upgrade attack speed")
//                    }
//                    Button {
//                        communicator.sellTower()
//                        
//                    } label: {
//                        Text("Sell tower")
//                    }
//                    
//                    //Foundation options:
//                    Button {
//                        communicator.currentFoundation = communicator.currentTower!.builtUponFoundation
//                        communicator.repairFoundation()
//                    } label: {
//                        Text("Repair Foundation")
//                    }
//                    Button {
//                        communicator.currentFoundation = communicator.currentTower!.builtUponFoundation
//                        communicator.upgradeFoundation()
//                    } label: {
//                        Text("Upgrade Foundation")
//                    }
//
//                }.font(.title)
//                    .foregroundColor(communicator.currentTower!.upgradeCount <= TowerData.MAX_UPGRADE ? Color.white : Color.gray)
//                    .background(.black.opacity(0.5))
//                    
//            }
        }
        
    }


}
