//
//  LabSceneView.swift
//  MadDoctorTD
//
//  Created by Daniel Falkedal on 2022-05-03.
//

import SwiftUI
import SpriteKit

struct LabSceneView: View {
    
    var labScene: SKScene
    
    static var imageWidth: CGFloat = 0
    static var imageHeight: CGFloat = 0
    
    init() {
        if LabScene.instance == nil {
            labScene = SKScene(fileNamed: "LabScene")!
        }
        else {
            labScene = LabScene.instance!
        }
        labScene.scaleMode = .fill
        
        LabSceneView.imageWidth = UIScreen.main.bounds.width * 0.15
        LabSceneView.imageHeight = LabSceneView.imageWidth
    }

    var body: some View {
        ZStack {
            SpriteView(scene: labScene)
                .ignoresSafeArea()
            
            VStack {
                
                TopArea()
                
                Spacer()
                
                MiddleArea()
                
                Spacer()
                
                BotArea()
                

            }
        }
    }
}

struct TopArea: View {
    
    @ObservedObject var communicator = LabSceneCommunicator.instance
    
    let imageHeight = LabSceneView.imageHeight
    let imageWidth = LabSceneView.imageWidth
    
    var body: some View {
        
        HStack {
            
            Button {
                communicator.selectType(type: .gunTower)
            } label: {
                Image("blast_tower")
                    .resizable()
                    .frame(width: imageWidth , height: imageHeight)
            }
            
            Button {
                communicator.selectType(type: .rapidFireTower)
            } label: {
                Image("speed_tower")
                    .resizable()
                    .frame(width: imageWidth , height: imageHeight)
            }
            
            Button {
                communicator.selectType(type: .sniperTower)
            } label: {
                ZStack {
                    Image("sniper_tower_static_legs")
                        .resizable()
                        .frame(width: imageWidth , height: imageHeight)
                    Image("sniper_tower_rotate")
                        .resizable()
                        .frame(width: imageWidth , height: imageHeight)
                }
            }
            
            Button {
                communicator.selectType(type: .cannonTower)
            } label: {
                Image("cannon_tower")
                    .resizable()
                    .frame(width: imageWidth , height: imageHeight)
            }
            
        }.background(.black)
        .padding()
        
    }
    
}

struct MiddleArea: View {
    
    @ObservedObject var communicator = LabSceneCommunicator.instance
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                ZStack {
                    SkillTreeBox()
                    Button(action: {
                        //code
                    }, label: {
                        Image(communicator.selectedTowerImage)
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                    })
                }
                
                
                
            }
            
            HStack {
                
                ZStack {
                    SkillTreeBox()
                    Button(action: {
                        //code
                    }, label: {
                        Text("2")
                    })
                }
                
            }
            
            HStack {
                
                VStack {
                    
                    ZStack {
                        SkillTreeBox()
                        Button(action: {
                            //code
                        }, label: {
                            Text("3a")
                        })
                    }
                    
                    ZStack {
                        SkillTreeBox()
                        Button(action: {
                            //code
                        }, label: {
                            Text("3b")
                        })
                    }
                    
                }
                
                VStack {
                    
                    ZStack {
                        SkillTreeBox()
                        Button(action: {
                            //code
                        }, label: {
                            Text("4a")
                        })
                    }
                    
                    ZStack {
                        SkillTreeBox()
                        Button(action: {
                            //code
                        }, label: {
                            Text("4b")
                        })
                    }
                    
                }
                
                VStack {
                    
                    ZStack {
                        SkillTreeBox()
                        Button(action: {
                            //code
                        }, label: {
                            Text("5a")
                        })
                    }
                    
                    ZStack {
                        SkillTreeBox()
                        Button(action: {
                            //code
                        }, label: {
                            Text("5b")
                        })
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

struct BotArea: View {
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            Button {
                AppManager.appManager.state = .gameScene
            } label: {
                Text("Return")
            }
            
            Spacer()
            
            Button {
                print("TODO...")
            } label: {
                Text("Research")
            }
            
            Spacer()
            
        }

    }
    
}

struct SkillTreeBox: View {
    
    var body: some View {
        
        Image("clickable_tile")
            .resizable()
            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)

    }
    
}
