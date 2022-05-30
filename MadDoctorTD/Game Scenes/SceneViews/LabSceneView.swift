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
                    
                    //Info and Confirm View
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
                    .frame(width: UIScreen.main.bounds.width*0.9)
                    .opacity((communicator.showInfoView || communicator.showConfirmView) ? 1.0 : 0.0)
                    
                    //Toast View
                    ToastView()
                    
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
            communicator.image3a = "blast_tower_slime"
            communicator.image3b = "Daniel"
            communicator.image3c = "Daniel"
        case .rapidFireTower:
            communicator.image3a = "Daniel"
            communicator.image3b = "speed_tower_slime"
            communicator.image3c = "Daniel"
        case .sniperTower:
            communicator.image3a = "Daniel"
            communicator.image3b = "sniper_tower_rotate_slime"
            communicator.image3c = "Daniel"
        case .cannonTower:
            communicator.image3a = "Daniel"
            communicator.image3b = "Daniel"
            communicator.image3c = "slime_cannon"
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
                        Image(checkAvailable(buttonId: "1"))
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "1"))
                        
                        Text("2 RP")
                            .foregroundColor(.white)
                            .padding([.leading,.trailing], 5)
                            .background(.black.opacity(0.4))
                            .cornerRadius(5)
                            .padding(5)
                            .offset(y: -LabSceneView.imageHeight/3)
                            .opacity(checkIfPriceIsNeeded(buttonId: "1"))
                           
                    }
                })
                
            }
            
            HStack {
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/8, height: LabSceneView.imageHeight/2)
                
            }
            .padding(.top, -10)
            .padding(.bottom, -8)
            
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
                        Image(checkAvailable(buttonId: "2a"))
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "2a"))
                        
                        Text("4 RP")
                            .foregroundColor(.white)
                            .padding([.leading,.trailing], 5)
                            .background(.black.opacity(0.4))
                            .cornerRadius(5)
                            .padding(5)
                            .offset(y: -LabSceneView.imageHeight/3)
                            .opacity(checkIfPriceIsNeeded(buttonId: "2a"))
                    }
                }
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/2, height: LabSceneView.imageHeight/8)
                    .padding(.leading, -8)
                    .padding(.trailing, -9)
                
                Button {
                    communicator.selectedTreeButtonId = "2b"
                    checkIfBuyable()
                } label: {
                    ZStack {
                        
                        LabButtonImage("2b")
                        Image(communicator.image2b)
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                        Image(checkAvailable(buttonId: "2b"))
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "2b"))
                        
                        Text("4 RP")
                            .foregroundColor(.white)
                            .padding([.leading,.trailing], 5)
                            .background(.black.opacity(0.4))
                            .cornerRadius(5)
                            .padding(5)
                            .offset(y: -LabSceneView.imageHeight/3)
                            .opacity(checkIfPriceIsNeeded(buttonId: "2b"))
                    }
                }
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/2, height: LabSceneView.imageHeight/8)
                    .padding(.leading, -8)
                    .padding(.trailing, -9)
                
                Button {
                    communicator.selectedTreeButtonId = "2c"
                    checkIfBuyable()
                } label: {
                    ZStack {
                        
                        LabButtonImage("2c")
                        Image(communicator.image2c)
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                        Image(checkAvailable(buttonId: "2c"))
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "2c"))
                        
                        Text("4 RP")
                            .foregroundColor(.white)
                            .padding([.leading,.trailing], 5)
                            .background(.black.opacity(0.4))
                            .cornerRadius(5)
                            .padding(5)
                            .offset(y: -LabSceneView.imageHeight/3)
                            .opacity(checkIfPriceIsNeeded(buttonId: "2c"))
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
                    .padding([.leading, .trailing], 94)
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/8, height: LabSceneView.imageHeight/2)
                
            }
            .padding(.top, -8)
            .padding(.bottom, -8)
            
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
                        Image(checkAvailable(buttonId: "3a"))
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "3a"))
                        
                        Text("6 RP..")
                            .foregroundColor(.white)
                            .padding([.leading,.trailing], 5)
                            .background(.black.opacity(0.4))
                            .cornerRadius(5)
                            .padding(5)
                            .offset(y: -LabSceneView.imageHeight/3)
                            .opacity(checkIfPriceIsNeeded(buttonId: "3a"))
                    }
                }
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/2, height: LabSceneView.imageHeight/8)
                    .opacity(0)
                    .padding(.leading, -9)
                    .padding(.trailing, -8)
                
                Button {
                    communicator.selectedTreeButtonId = "3b"
                    checkIfBuyable()
                } label: {
                    ZStack {
                        
                        LabButtonImage("3b")
                        Image(communicator.image3b)
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                        Image(checkAvailable(buttonId: "3b"))
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "3b"))
                        
                        Text("6 RP..")
                            .foregroundColor(.white)
                            .padding([.leading,.trailing], 5)
                            .background(.black.opacity(0.4))
                            .cornerRadius(5)
                            .padding(5)
                            .offset(y: -LabSceneView.imageHeight/3)
                            .opacity(checkIfPriceIsNeeded(buttonId: "3b"))
                    }
                }
                
                Image("skill_tree_connector")
                    .resizable()
                    .frame(width: LabSceneView.imageWidth/2, height: LabSceneView.imageHeight/8)
                    .opacity(0)
                    .padding(.leading, -9)
                    .padding(.trailing, -8)
                
                Button(action: {
                    communicator.selectedTreeButtonId = "3c"
                    checkIfBuyable()
                }, label: {
                    ZStack {
                        
                        LabButtonImage("3c")
                        Image(communicator.image3c)
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                        Image(checkAvailable(buttonId: "3c"))
                            .resizable()
                            .frame(width: LabSceneView.imageWidth, height: LabSceneView.imageHeight)
                            .opacity(changeOpacity(buttonId: "3c"))
                        
                        Text("6 RP..")
                            .foregroundColor(.white)
                            .padding([.leading,.trailing], 5)
                            .background(.black.opacity(0.4))
                            .cornerRadius(5)
                            .padding(5)
                            .offset(y: -LabSceneView.imageHeight/3)
                            .opacity(checkIfPriceIsNeeded(buttonId: "3c"))
                        
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
            
            let cost = LabData.UPGRADE_COST_2
            
            switch communicator.selectedTowerType {
                
            case .gunTower:
                return "Unlock level 2 damage for Gun Towers? cost: \(cost) RP"
            case .rapidFireTower:
                return "Unlock level 2 damage for Rapid Fire Towers? cost: \(cost) RP"
            case .sniperTower:
                return "Unlock level 2 damage for Sniper Towers? cost: \(cost) RP"
            case .cannonTower:
                return "Unlock level 2 damage for Cannon Towers? cost: \(cost) RP"
            }
            
        case "2b":
            
            let cost = LabData.UPGRADE_COST_2
            
            switch communicator.selectedTowerType {
                
            case .gunTower:
                return "Unlock level 2 attack speed for Gun Towers? cost: \(cost) RP"
            case .rapidFireTower:
                return "Unlock level 2 attack speed for Rapid Fire Towers? cost: \(cost) RP"
            case .sniperTower:
                return "Unlock level 2 attack speed for Sniper Towers? cost: \(cost) RP"
            case .cannonTower:
                return "Unlock level 2 attack speed for Cannon Towers? cost: \(cost) RP"
            }
            
        case "2c":
            
            let cost = LabData.UPGRADE_COST_2
            
            switch communicator.selectedTowerType {
                
            case .gunTower:
                return "Unlock level 2 range for Gun Towers? cost: \(cost) RP"
            case .rapidFireTower:
                return "Unlock level 2 range for Rapid Fire Towers? cost: \(cost) RP"
            case .sniperTower:
                return "Unlock level 2 range for Sniper Towers? cost: \(cost) RP"
            case .cannonTower:
                return "Unlock level 2 range for Cannon Towers? cost: \(cost) RP"
            }
            
        case "3a":
            
            let cost = LabData.UPGRADE_COST_3
            
            switch communicator.selectedTowerType {
                
            case .gunTower:
                return "Unlock bouncing projectiles for Gun Towers?  cost: \(cost) RP and 1 Slime Material"
            case .rapidFireTower:
                return "ERROR"
            case .sniperTower:
                return "ERROR"
            case .cannonTower:
                return "ERROR"
            }
            
        case "3b":
            
            let cost = LabData.UPGRADE_COST_3
            
            switch communicator.selectedTowerType {
                
            case .gunTower:
                return "ERROR"
            case .rapidFireTower:
                return "Unlock slowing projectiles for Rapid Fire Towers? cost: \(cost) RP and 1 Slime Material"
            case .sniperTower:
                return "Unlock poison projectiles for Sniper Towers? cost: \(cost) RP and 1 Slime Material"
            case .cannonTower:
                return "ERROR"
            }
            
        case "3c":
            
            let cost = LabData.UPGRADE_COST_3
            
            switch communicator.selectedTowerType {
                
            case .gunTower:
                return "ERROR"
            case .rapidFireTower:
                return "ERROR"
            case .sniperTower:
                return "ERROR"
            case .cannonTower:
                return "Unlock mine projectiles for Cannon Towers? cost: \(cost) RP and 1 Slime Material"
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
    
    func checkIfPriceIsNeeded(buttonId: String) -> Double{
        
        var towerResearchLevel = [String]()
        
        switch communicator.selectedTowerType {
        
        case .gunTower:
            towerResearchLevel = communicator.gunTowerResearchLevel
        case .rapidFireTower:
            towerResearchLevel = communicator.rapidTowerResearchLevel
        case .sniperTower:
            towerResearchLevel = communicator.sniperTowerResearchLevel
        case .cannonTower:
            towerResearchLevel = communicator.cannonTowerResearchLevel
            
        }
        
            switch buttonId{
                
            case "1":
                if !towerResearchLevel.contains("1") {
                return 1.0
                }
                
                // 2
                
            case "2a":
                if towerResearchLevel.contains("1") && !towerResearchLevel.contains("2a") && !towerResearchLevel.contains("3a") {
                    return 1.0
                }
            case "2b":
                if towerResearchLevel.contains("1") && !towerResearchLevel.contains("2b") && !towerResearchLevel.contains("3b") {
                    return 1.0
                }
            case "2c":
                if towerResearchLevel.contains("1") && !towerResearchLevel.contains("2c") && !towerResearchLevel.contains("3c") {
                    return 1.0
                }
                
                // 3
                
            case "3a":
                if towerResearchLevel.contains("2a") && !towerResearchLevel.contains("3a"){
                    return 1.0
                }
            case "3b":
                if towerResearchLevel.contains("2b") && !towerResearchLevel.contains("3b"){
                    return 1.0
                }
            case "3c":
                if towerResearchLevel.contains("2c") && !towerResearchLevel.contains("3c"){
                    return 1.0
                }
            default:
                return 0.0
            }
        
        return 0.0
        
    }
    
    func checkAvailable(buttonId: String) -> String{
        
        var towerResearchLevel = [String]()
        
        switch communicator.selectedTowerType {
        
        case .gunTower:
            towerResearchLevel = communicator.gunTowerResearchLevel
        case .rapidFireTower:
            towerResearchLevel = communicator.rapidTowerResearchLevel
        case .sniperTower:
            towerResearchLevel = communicator.sniperTowerResearchLevel
        case .cannonTower:
            towerResearchLevel = communicator.cannonTowerResearchLevel
            
        }
        
            switch buttonId{
                
            case "1":
                return "locked_frame_ready"
                
                // 2
                
            case "2a":
                if towerResearchLevel.contains("1") {
                        return "locked_frame_ready"
                }
            case "2b":
                if towerResearchLevel.contains("1") {
                        return "locked_frame_ready"
                }
            case "2c":
                if towerResearchLevel.contains("1") {
                        return "locked_frame_ready"
                }
                
                // 3
                
            case "3a":
                if towerResearchLevel.contains("2a") {
                        return "locked_frame_ready"
                }
            case "3b":
                if towerResearchLevel.contains("2b") {
                        return "locked_frame_ready"
                }
            case "3c":
                if towerResearchLevel.contains("2c") {
                        return "locked_frame_ready"
                }
            default:
                return "locked_frame"
            }
        
        return "locked_frame"
        
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
                
                guard let labScene = LabScene.instance else { return }
                labScene.fadeOutScene = true
                
                
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
//            .background(communicator.selectedTreeButtonId == id ? .white : .black)
//            .opacity(communicator.selectedTreeButtonId == id ? 1.0 : 0.5)
    }
    
}

struct InfoView: View {
    
    @ObservedObject var communicator = LabSceneCommunicator.instance
    
    var body: some View {
        
        VStack {
            
            Text(communicator.infoViewHeader)
                .font(.title2)
            
            Text(communicator.infoViewText)
                .padding(.top, 10)
            
            //Buttons
            HStack {
                
                Button {
                    communicator.showInfoView = false
                } label: {
                    Image("done_build_foundation_button_standard")
                        .resizable()
                        .frame(width: LabSceneView.imageWidth*0.75, height: LabSceneView.imageHeight*0.75)
                }
                
            }
            .padding(.top, 20)
            
        }
        
    }
    
}

struct ConfirmView: View {
    
    @ObservedObject var communicator = LabSceneCommunicator.instance
    
    var body: some View {
        
        VStack {
            
            Text(communicator.confirmViewHeader)
                .font(.title2)
            
            Text(communicator.confirmViewText)
                .padding(.top, 10)
            
            //Buttons
            HStack {
                
                Spacer()
                
                Button {
                    communicator.buyUpgrade()
                    communicator.showConfirmView = false
                } label: {
                    Image("done_build_foundation_button_standard")
                        .resizable()
                        .frame(width: LabSceneView.imageWidth*0.75, height: LabSceneView.imageHeight*0.75)
                }
                
                Spacer()
                
                Button {
                    communicator.showConfirmView = false
                } label: {
                    Image("sniper_tower_static_legs")
                        .resizable()
                        .frame(width: LabSceneView.imageWidth*0.75, height: LabSceneView.imageHeight*0.75)
                }
                
                Spacer()
                
            }
            .padding(.top, 20)
            
        }
        
    }
    
}

struct ToastView: View {
    
    @ObservedObject var communicator = LabSceneCommunicator.instance
    
    var body: some View {
        
        VStack {
            
            VStack {
                Text(communicator.toastViewHeader)
                    .font(.title2)
                
                Text(communicator.toastViewText)
                    .padding(.top, 10)
            }.padding()
                .foregroundColor(Color.white)
                .background(Color.black.opacity(0.75))
                .cornerRadius(8)
                .opacity(communicator.toastOpacity)
                .position(x: UIScreen.main.bounds.width/2, y: communicator.toastPositionY)
            
        }
        
    }
    
}
