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
    
    @ObservedObject var communicator = LabSceneCommunicator.instance
    
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
        
        LabSceneView.imageWidth = UIScreen.main.bounds.width * 0.175
        LabSceneView.imageHeight = LabSceneView.imageWidth
        //SoundManager.playBGM(bgmString: SoundManager.researchViewAtmosphere)
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: labScene)
                .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    
                    //Main content
                    VStack {
                        
                        TopArea()
                        
                        Spacer()
                        
                        MiddleArea()
                        
                        Spacer()
                        
                        BotArea()
                        
                    }
                    
                    //Pop-up content
                    ZStack {
                        //Info View
                        if communicator.showInfoView {
                            InfoView()
                        }
                        //Confirm View
                        else if communicator.showConfirmView {
                            ConfirmView()
                        }
                    }
                    .padding(50)
                    .foregroundColor(Color.white)
                    .background(Color.black.opacity(0.75))
                    .cornerRadius(8)
                    .frame(width: UIScreen.main.bounds.width*0.8)
                    .opacity((communicator.showInfoView || communicator.showConfirmView) ? 1.0 : 0.0)
                    
                }
                
                
            }
        }
    }
}

struct TopArea: View {
    
    @ObservedObject var communicator = LabSceneCommunicator.instance
    @ObservedObject var gameManager = GameManager.instance
    
    let imageHeight = LabSceneView.imageHeight
    let imageWidth = LabSceneView.imageWidth
    
    var body: some View {
        
        VStack {
            
            Text("Research Points: \(gameManager.researchPoints)")
                .foregroundColor(Color.white)
                .font(.title)
            
            Text("Slime materials: \(gameManager.slimeMaterials)")
                .foregroundColor(Color.white)
                .font(.title3)
            
            Text("Squid materials: \(gameManager.squidMaterials)")
                .foregroundColor(Color.white)
                .font(.title3)
            
            HStack {
                
                Button {
                    communicator.selectType(type: .gunTower)
                    SoundManager.playSFX(sfxName: SoundManager.buttonOneSFX, scene: LabScene.instance!, sfxExtension: SoundManager.mp3Extension)
                    updateTreeImages()
                    print("gunTower button pressed")
                } label: {
                    
                    ZStack {
                        Image(communicator.selectedTowerType == .gunTower ? "item_frame_research_tower_select" : "item_frame_research_tower_not_selected")
                            .resizable()
                            .frame(width: imageWidth , height: imageHeight)
                        Image("blast_tower")
                            .resizable()
                            .frame(width: imageWidth , height: imageHeight)
                    }
                    
                    
                }.padding(16)
                
                Button {
                    communicator.selectType(type: .rapidFireTower)
                    SoundManager.playSFX(sfxName: SoundManager.buttonTwoSFX, scene: LabScene.instance!, sfxExtension: SoundManager.mp3Extension)
                    updateTreeImages()
                    print("rapidFire button pressed")
                } label: {
                    
                    ZStack {
                        Image(communicator.selectedTowerType == .rapidFireTower ? "item_frame_research_tower_select" : "item_frame_research_tower_not_selected")
                            .resizable()
                            .frame(width: imageWidth , height: imageHeight)
                        Image("speed_tower")
                            .resizable()
                            .frame(width: imageWidth , height: imageHeight)
                    }
                    
                    
                }.padding([.top, .bottom, .trailing], 16)
                
                Button {
                    communicator.selectType(type: .cannonTower)
                    SoundManager.playSFX(sfxName: SoundManager.buttonFourSFX, scene: LabScene.instance!, sfxExtension: SoundManager.mp3Extension)
                    updateTreeImages()
                    print("cannonTower button pressed")
                } label: {
                    
                    ZStack {
                        Image(communicator.selectedTowerType == .cannonTower ? "item_frame_research_tower_select" : "item_frame_research_tower_not_selected")
                            .resizable()
                            .frame(width: imageWidth , height: imageHeight)
                        Image("cannon_tower")
                            .resizable()
                            .frame(width: imageWidth , height: imageHeight)
                    }
                    
                }.padding([.top, .bottom, .trailing], 16)
                
                Button {
                    communicator.selectType(type: .sniperTower)
                    SoundManager.playSFX(sfxName: SoundManager.buttonThreeSFX, scene: LabScene.instance!, sfxExtension: SoundManager.mp3Extension)
                    updateTreeImages()
                    print("sniperTower button pressed")
                } label: {
                    ZStack {
                        
                        Image(communicator.selectedTowerType == .sniperTower ? "item_frame_research_tower_select" : "item_frame_research_tower_not_selected")
                            .resizable()
                            .frame(width: imageWidth , height: imageHeight)
                        Image("sniper_tower_static_legs")
                            .resizable()
                            .frame(width: imageWidth , height: imageHeight)
                        Image("sniper_tower_rotate")
                            .resizable()
                            .frame(width: imageWidth , height: imageHeight)
                    }
                }.padding([.top, .bottom, .trailing], 16)
                
            }.background(.black)
                .padding()
                .onAppear(perform: {
                    updateTreeImages()
                })
            
        }
        
    }
    
    private func updateTreeImages() {
        switch communicator.selectedTowerType {
            
        case .gunTower:
            communicator.image3a = "bouncing_projectile"
            communicator.image3b = "Daniel"
            communicator.image3c = "Daniel"
        case .rapidFireTower:
            communicator.image3a = "Daniel"
            communicator.image3b = "money_object"
            communicator.image3c = "Daniel"
        case .sniperTower:
            communicator.image3a = "Daniel"
            communicator.image3b = "money_object"
            communicator.image3c = "Daniel"
        case .cannonTower:
            communicator.image3a = "Daniel"
            communicator.image3b = "Daniel"
            communicator.image3c = "cannon_projectile"
        }
    }
    
}

struct MiddleArea: View {
    
    @ObservedObject var communicator = LabSceneCommunicator.instance
    @ObservedObject var gameManager = GameManager.instance
    //@State private var confirmation: ErrorInfo?
    //@State private var error: ErrorInfo?
    
    var body: some View {
        
        VStack {
            
            VStack {
                
                Button(action: {
                    communicator.selectedTreeButtonId = "1"
                    checkIfBuyable()
                    
                }, label: {
                    ZStack {
                        
                        LabButtonImage("1")
                        Image(communicator.selectedTowerImage)
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                        Image("faded_button_layer")
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "1"))
                        
                    }
                })
                
            }
            
            HStack {
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/8, height: LabSceneView.imageHeight/2)
                
            }
            
            HStack {
                
                Button {
                    communicator.selectedTreeButtonId = "2a"
                    checkIfBuyable()
                } label: {
                    ZStack {
                        
                        LabButtonImage("2a")
                        Image(communicator.image2a)
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                        Image("faded_button_layer")
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "2a"))
                    }
                }
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/2, height: LabSceneView.imageHeight/8)
                
                Button {
                    communicator.selectedTreeButtonId = "2b"
                    checkIfBuyable()
                } label: {
                    ZStack {
                        
                        LabButtonImage("2b")
                        Image(communicator.image2b)
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                        Image("faded_button_layer")
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "2b"))
                    }
                }
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/2, height: LabSceneView.imageHeight/8)
                
                Button {
                    communicator.selectedTreeButtonId = "2c"
                    checkIfBuyable()
                } label: {
                    ZStack {
                        
                        LabButtonImage("2c")
                        Image(communicator.image2c)
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                        Image("faded_button_layer")
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "2c"))
                    }
                }
            }
            
            HStack {
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/8, height: LabSceneView.imageHeight/2)
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/8, height: LabSceneView.imageHeight/2)
                    .padding([.leading, .trailing], 115)
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/8, height: LabSceneView.imageHeight/2)
                
            }
            
            HStack {
                
                Button {
                    communicator.selectedTreeButtonId = "3a"
                    checkIfBuyable()
                } label: {
                    ZStack {
                        
                        LabButtonImage("3a")
                        Image(communicator.image3a)
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                        Image("faded_button_layer")
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "3a"))
                    }
                }
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/2, height: LabSceneView.imageHeight/8)
                    .opacity(0)
                
                Button {
                    communicator.selectedTreeButtonId = "3b"
                    checkIfBuyable()
                } label: {
                    ZStack {
                        
                        LabButtonImage("3b")
                        Image(communicator.image3b)
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                        Image("faded_button_layer")
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "3b"))
                    }
                }
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/2, height: LabSceneView.imageHeight/8)
                    .opacity(0)
                
                Button(action: {
                    communicator.selectedTreeButtonId = "3c"
                    checkIfBuyable()
                }, label: {
                    ZStack {
                        
                        LabButtonImage("3c")
                        Image(communicator.image3c)
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                        Image("faded_button_layer")
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "3c"))
                        
                    }
                })
                
            }
            
        }
        /*
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
         */
        
       

        
    }
    
    
    func createTowerDescription() -> String{
        
        switch communicator.selectedTreeButtonId{
            
        case "1":
            
            switch communicator.selectedTowerType{
                
            case .gunTower:
                return "The trusted AlienSmasher 3000, well balanced and reliable. cost: \(LabData.getCost(selected: communicator.selectedTreeButtonId)) RP"
            case .cannonTower:
                return "I found this in a museum, what a shame! Powerful but very slow. cost: \(LabData.getCost(selected: communicator.selectedTreeButtonId)) RP"
            case .rapidFireTower:
                return "Is there somthing better then a gatling gun? No! Very fast, but with a short range and low damage. cost: \(LabData.getCost(selected: communicator.selectedTreeButtonId)) RP"
            case .sniperTower:
                return "Better then a Finnish sniper. long range, high damage shots with a long cooldown. cost: \(LabData.getCost(selected: communicator.selectedTreeButtonId)) RP"
            }
            
        case "2a":
            
            switch communicator.selectedTowerType {
                
            case .gunTower:
                return "Unlock level 2 damage for Gun Towers?"
            case .rapidFireTower:
                return "Unlock level 2 damage for Rapid Fire Towers?"
            case .sniperTower:
                return "Unlock level 2 damage for Sniper Towers?"
            case .cannonTower:
                return "Unlock level 2 damage for Cannon Towers?"
            }
            
        case "2b":
            
            switch communicator.selectedTowerType {
                
            case .gunTower:
                return "Unlock level 2 attack speed for Gun Towers?"
            case .rapidFireTower:
                return "Unlock level 2 attack speed for Rapid Fire Towers?"
            case .sniperTower:
                return "Unlock level 2 attack speed for Sniper Towers?"
            case .cannonTower:
                return "Unlock level 2 attack speed for Cannon Towers?"
            }
            
        case "2c":
            
            switch communicator.selectedTowerType {
                
            case .gunTower:
                return "Unlock level 2 range for Gun Towers?"
            case .rapidFireTower:
                return "Unlock level 2 range for Rapid Fire Towers?"
            case .sniperTower:
                return "Unlock level 2 range for Sniper Towers?"
            case .cannonTower:
                return "Unlock level 2 range for Cannon Towers?"
            }
            
        case "3a":
            
            switch communicator.selectedTowerType {
                
            case .gunTower:
                return "Unlock bouncing projectiles for Gun Towers?"
            case .rapidFireTower:
                return "ERROR"
            case .sniperTower:
                return "ERROR"
            case .cannonTower:
                return "ERROR"
            }
            
        case "3b":
            
            switch communicator.selectedTowerType {
                
            case .gunTower:
                return "ERROR"
            case .rapidFireTower:
                return "Unlock slowing projectiles for Rapid Fire Towers?"
            case .sniperTower:
                return "Unlock poison projectiles for Sniper Towers?"
            case .cannonTower:
                return "ERROR"
            }
            
        case "3c":
            
            switch communicator.selectedTowerType {
                
            case .gunTower:
                return "ERROR"
            case .rapidFireTower:
                return "ERROR"
            case .sniperTower:
                return "ERROR"
            case .cannonTower:
                return "Unlock mine projectiles for Cannon Towers?"
            }
            
        default:
            return "ERROR"
        }
        
        
        
    }
    
    
    func checkIfBuyable(){
        
        if let labScene = LabScene.instance {
            SoundManager.playSFX(sfxName: SoundManager.upgradePressed, scene: labScene, sfxExtension: SoundManager.mp3Extension)
        }
        
        if checkIfUpgraded() == .unlocked{
            communicator.displayInfoView(title: "Info", description: "Upgrade already unlocked")
            return
        }
        
        if GameManager.instance.researchPoints < getPrice() {
            communicator.displayInfoView(title: "Insufficient Funds", description: "Not enough Research point")
            return
        }
        
        if costsSlimeMaterial() && gameManager.slimeMaterials <= 0 {
            communicator.displayInfoView(title: "Insufficient Funds", description: "Not enough Slime materials")
            return
        }
        
        if costsSquidMaterial() && gameManager.squidMaterials <= 0 {
            communicator.displayInfoView(title: "Insufficient Funds", description: "Not enough Squid materials")
            return
        }
        
        communicator.confirmViewHeader = "Do you really want to buy this upgrade?"
        communicator.confirmViewText = createTowerDescription()
        communicator.showConfirmView = true
        
    }
    
    
    
    private func getPrice() -> Int {
        
        if communicator.selectedTreeButtonId == "1" {
            return 2
        }
        
        if communicator.selectedTreeButtonId == "2a" || communicator.selectedTreeButtonId == "2b" || communicator.selectedTreeButtonId == "2c" {
            return 4
        }
        
        return 6
    }
    
    private func costsSlimeMaterial() -> Bool {
        
        switch communicator.selectedTowerType {
            
        case .gunTower:
            
            switch communicator.selectedTreeButtonId {
                
            case "3a":
                return true
                
            default:
                return false
                
            }
            
        case .rapidFireTower:
            switch communicator.selectedTreeButtonId {
                
            case "3b":
                return true
                
            default:
                return false
                
            }
            
        case .sniperTower:
            switch communicator.selectedTreeButtonId {
                
            case "3b":
                return true
                
            default:
                return false
                
            }
            
        case .cannonTower:
            switch communicator.selectedTreeButtonId {
                
            case "3c":
                return true
                
            default:
                return false
                
            }
            
        }
        
    }
    
    private func costsSquidMaterial() -> Bool {
        return false
    }
    
    func checkIfUpgraded() -> ErrorType{
        
        switch communicator.selectedTowerType{
            
        case .gunTower:
            for upgrade in communicator.gunTowerResearchLevel{
                if communicator.selectedTreeButtonId == upgrade{
                    return .unlocked
                }
                return .success
            }
        case .rapidFireTower:
            for upgrade in communicator.rapidTowerResearchLevel{
                if communicator.selectedTreeButtonId == upgrade{
                    return .unlocked
                }
                return .success
            }
        case .sniperTower:
            for upgrade in communicator.sniperTowerResearchLevel{
                if communicator.selectedTreeButtonId == upgrade{
                    return .unlocked
                }
                return .success
            }
        case .cannonTower:
            for upgrade in communicator.cannonTowerResearchLevel{
                if communicator.selectedTreeButtonId == upgrade{
                    return .unlocked
                }
                return .success
            }
        }
        
        return .error
    }
    
    
    
    func changeOpacity(buttonId: String) -> Double{
        
        switch communicator.selectedTowerType {
            
        case .gunTower:
            if communicator.gunTowerResearchLevel.contains(buttonId) {
                return 0.0
            }
        case .rapidFireTower:
            if communicator.rapidTowerResearchLevel.contains(buttonId) {
                return 0.0
            }
        case .sniperTower:
            if communicator.sniperTowerResearchLevel.contains(buttonId) {
                return 0.0
            }
        case .cannonTower:
            if communicator.cannonTowerResearchLevel.contains(buttonId) {
                return 0.0
            }
        }
        
        return 1.0
        
    }
    
    
    
    
}

struct BotArea: View {
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            Button {
                AppManager.appManager.state = .gameScene
                SoundManager.playBGM(bgmString: SoundManager.ambienceOne, bgmExtension: SoundManager.mp3Extension)
                //SoundManager.playBGM(bgmString: SoundManager.simplifiedTheme, bgmExtension: SoundManager.wavExtension)
            } label: {
                Image("play_button")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
            }

            
            /*
            Button {
                AppManager.appManager.state = .gameScene
                SoundManager.playBGM(bgmString: SoundManager.ambienceOne, bgmExtension: SoundManager.mp3Extension)
                //SoundManager.playBGM(bgmString: SoundManager.simplifiedTheme, bgmExtension: SoundManager.wavExtension)
            } label: {
                Text("Return")
                    .foregroundColor(Color.white)
                
                
            }
            .frame(width: 120, height: 30)
            .background(Color.blue)
            .cornerRadius(1)
             */
            
            Spacer()
            
        }
    }
    
    
}

struct LabButtonImage: View {
    
    @ObservedObject var communicator = LabSceneCommunicator.instance
    
    let id: String
    
    init(_ _id: String) {
        id = _id
    }
    
    var body: some View {
        
        Image("item_frame_research_bg")
            .resizable()
            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
            .background(communicator.selectedTreeButtonId == id ? .white : .black)
            .opacity(communicator.selectedTreeButtonId == id ? 1.0 : 0.5)
    }
    
}

struct InfoView: View {
    
    @ObservedObject var communicator = LabSceneCommunicator.instance
    
    var body: some View {
        
        VStack {
            
            Text(communicator.infoViewHeader)
                .font(.title)
            
            Text(communicator.infoViewText)
                .font(.title2)
                .padding(.top, 20)
            
            //Buttons
            HStack {
                
                Button {
                    communicator.showInfoView = false
                } label: {
                    Image("done_build_foundation_button_standard")
                        .resizable()
                        .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                }
                
            }
            .padding(.top, 40)
            
        }
        
    }
    
}

struct ConfirmView: View {
    
    @ObservedObject var communicator = LabSceneCommunicator.instance
    
    var body: some View {
        
        VStack {
            
            Text(communicator.confirmViewHeader)
                .font(.title)
            
            Text(communicator.confirmViewText)
                .font(.title2)
                .padding(.top, 20)
            
            //Buttons
            HStack {
                
                Spacer()
                
                Button {
                    communicator.buyUpgrade()
                    communicator.showConfirmView = false
                } label: {
                    Image("done_build_foundation_button_standard")
                        .resizable()
                        .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                }
                
                Spacer()
                
                Button {
                    communicator.showConfirmView = false
                } label: {
                    Image("sniper_tower_static_legs")
                        .resizable()
                        .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                }
                
                Spacer()
                
            }
            .padding(.top, 40)
            
        }
        
    }
    
}

