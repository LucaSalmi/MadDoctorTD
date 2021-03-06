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
            
            switch GameManager.instance.currentLevel {
                
            case 1:
                gameScene = SKScene(fileNamed: "GameScene")!
                
            case 2:
                gameScene = SKScene(fileNamed: "GameSceneTwo")!
                
            default:
                gameScene = SKScene(fileNamed: "GameScene")!
            }
            
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
                                SoundManager.playSFX(sfxName: SoundManager.buttonOneSFX, scene: GameScene.instance!, sfxExtension: SoundManager.mp3Extension)
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
                    

                }


                
            }

        }
        
    }


}

