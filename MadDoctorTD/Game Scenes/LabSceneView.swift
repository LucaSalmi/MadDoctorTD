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
    
    @ObservedObject var gameManager = GameManager.instance
    
    
    
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
        //SoundManager.playBGM(bgmString: SoundManager.researchViewAtmosphere)
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: labScene)
                .ignoresSafeArea()
            
            VStack {
                
                Text("Research Points: \(gameManager.researchPoints)")
                    .foregroundColor(Color.white)
                    .font(.title)
                
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
                SoundManager.playSFX(sfxName: SoundManager.buttonOneSFX, scene: LabScene.instance!, sfxExtension: SoundManager.mp3Extension)
                print("gunTower button pressed")
            } label: {
                Image("blast_tower")
                    .resizable()
                    .frame(width: imageWidth , height: imageHeight)
            }
            
            Button {
                communicator.selectType(type: .rapidFireTower)
                SoundManager.playSFX(sfxName: SoundManager.buttonTwoSFX, scene: LabScene.instance!, sfxExtension: SoundManager.mp3Extension)
                print("rapidFire button pressed")
            } label: {
                Image("speed_tower")
                    .resizable()
                    .frame(width: imageWidth , height: imageHeight)
            }
            
            Button {
                communicator.selectType(type: .sniperTower)
                SoundManager.playSFX(sfxName: SoundManager.buttonThreeSFX, scene: LabScene.instance!, sfxExtension: SoundManager.mp3Extension)
                print("sniperTower button pressed")
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
                SoundManager.playSFX(sfxName: SoundManager.buttonFourSFX, scene: LabScene.instance!, sfxExtension: SoundManager.mp3Extension)
                print("cannonTower button pressed")
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
    @ObservedObject var gameManager = GameManager.instance
    @State private var confirmation: ErrorInfo?
    @State private var error: ErrorInfo?
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Button(action: {
                    communicator.selectedTreeButtonId = "1"
                    checkIfBuyable()
                    
                }, label: {
                    ZStack {
                        
                        LabButtonImage("clickable_tile", "1")
                        Image(communicator.selectedTowerImage)
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                        Image("faded_button_layer")
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity())
                        
                    }
                })
                
            }
            
            HStack {
                
                Button {
                    communicator.selectedTreeButtonId = "2"
                    checkIfBuyable()
                } label: {
                    ZStack {
                        LabButtonImage("clickable_tile", "2")
                        Text("2")
                    }
                }
                
            }
            
            HStack {
                
                VStack {
                    
                    Button {
                        communicator.selectedTreeButtonId = "3a"
                    } label: {
                        ZStack {
                            LabButtonImage("clickable_tile", "3a")
                            Text("3a")
                        }
                    }
                    
                    Button {
                        communicator.selectedTreeButtonId = "3b"
                    } label: {
                        ZStack {
                            LabButtonImage("clickable_tile", "3b")
                            Text("3b")
                        }
                    }
                    
                }
                
                VStack {
                    
                    Button {
                        communicator.selectedTreeButtonId = "4a"
                    } label: {
                        ZStack {
                            LabButtonImage("clickable_tile", "4a")
                            Text("4a")
                        }
                    }
                    
                    Button {
                        communicator.selectedTreeButtonId = "4b"
                    } label: {
                        ZStack {
                            LabButtonImage("clickable_tile", "4b")
                            Text("4b")
                        }
                    }
                }
                
                VStack {
                    
                    Button {
                        communicator.selectedTreeButtonId = "5a"
                    } label: {
                        ZStack {
                            LabButtonImage("clickable_tile", "5a")
                            Text("5a")
                        }
                    }
                    
                    ZStack {
                        LabButtonImage("clickable_tile", "5b")
                        Button(action: {
                            communicator.selectedTreeButtonId = "5b"
                        }, label: {
                            Text("5b")
                        })
                    }
                }
            }
            
        }
        .alert(item: $confirmation) { confirmation in
            
            Alert(
                title: Text(confirmation.title),
                message: Text(confirmation.description),
                primaryButton: .cancel(Text("Yes")){
                    buyUpgrade()
                },
                secondaryButton: .destructive(Text("No"))
            )}
        VStack{
            
        }
        .alert(item: $error) { error in
            
            Alert(
                title: Text(error.title),
                message: Text(error.description)
        )}
        
       

        
    }
    
    
    func checkIfBuyable(){
        
        if GameManager.instance.researchPoints <= 0 {
            error = ErrorInfo(title: "Error", description: "Not enough Research point")
        }
        
        confirmation = ErrorInfo(title: "buy this upgrade", description: "Do you really want to buy this upgrade?")
        
    }
    
    func buyUpgrade(){
        
        let answer = applyResearch()
        print(answer)
        switch answer{
            
        case .researchPoints:
            error = ErrorInfo(title: "Error", description: "Not enough Research point")
        case .unlocked:
            error = ErrorInfo(title: "Error", description: "Upgrade already unlocked")
        case .success:
            error = ErrorInfo(title: "Great", description: "You unlocked this upgrade for \(communicator.selectedTowerType)")
        case .error:
            error = ErrorInfo(title: "What?", description: "Somthing unexpected happened")
            
        }
        print(error)
        
    }
    
    func changeOpacity() -> Double{
        
        switch communicator.selectedTowerType{
            
        case .gunTower:
            return 0.0
        case .rapidFireTower:
            if GameManager.instance.rapidFireTowerUnlocked{
                return 0.0
            }
        case .sniperTower:
            if GameManager.instance.sniperTowerUnlocked{
                return 0.0
            }
        case .cannonTower:
            if GameManager.instance.cannonTowerUnlocked{
                return 0.0
            }
        }
        return 1.3
    }
    
    func applyResearch() -> ErrorType {
        
        let gameManager = GameManager.instance
        let communicator = LabSceneCommunicator.instance
        
        switch communicator.selectedTowerType {
            
        case .gunTower:
            switch communicator.selectedTreeButtonId {
            case "1":
                return .unlocked
            default:
                print("not implemented")
            }
        case .rapidFireTower:
            switch communicator.selectedTreeButtonId {
            case "1":
                if gameManager.rapidFireTowerUnlocked {
                    return .unlocked
                }
                GameScene.instance!.towerUI!.childNode(withName: "SpeedTower")!.alpha = 1
                gameManager.rapidFireTowerUnlocked = true
                gameManager.researchPoints -= 1
                return .success
            default:
                print("not implemented")
            }
        case .sniperTower:
            switch communicator.selectedTreeButtonId {
            case "1":
                if gameManager.sniperTowerUnlocked {
                    return .unlocked                }
                GameScene.instance!.towerUI!.childNode(withName: "SniperTower")!.alpha = 1
                gameManager.sniperTowerUnlocked = true
                gameManager.researchPoints -= 1
                return .success
            default:
                print("not implemented")
            }
        default:
            switch communicator.selectedTreeButtonId {
            case "1":
                if gameManager.cannonTowerUnlocked {
                    return .unlocked
                }
                GameScene.instance!.towerUI!.childNode(withName: "CannonTower")!.alpha = 1
                gameManager.cannonTowerUnlocked = true
                gameManager.researchPoints -= 1
                return .success
            default:
                print("not implemented")
            }
        }
        return .error
    }
    
    
}

struct BotArea: View {
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            Button {
                AppManager.appManager.state = .gameScene
                SoundManager.playBGM(bgmString: SoundManager.airlockDoorsTheme, bgmExtension: SoundManager.wavExtension)
            } label: {
                Text("Return")
                    .foregroundColor(Color.white)
                
                
            }
            .frame(width: 120, height: 30)
            .background(Color.blue)
            .cornerRadius(15)
            
            Spacer()
            
        }
    }
    
    
}

struct LabButtonImage: View {
    
    @ObservedObject var communicator = LabSceneCommunicator.instance
    
    let imageString: String
    let id: String
    
    init(_ _imageString: String, _ _id: String) {
        id = _id
        imageString = _imageString
    }
    
    var body: some View {
        
        Image(imageString)
            .resizable()
            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
            .background(communicator.selectedTreeButtonId == id ? .white : .black)
            .opacity(communicator.selectedTreeButtonId == id ? 1.0 : 0.5)
    }
    
}
