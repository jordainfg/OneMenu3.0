//
//  LandingPageForAppClip.swift
//  OneMenuAppClip
//
//  Created by Jordain Gijsbertha on 16/10/2020.
//

import SwiftUI
import StoreKit

enum appClipViewState {
    case showLoadingIndicator
    case isLoading
    case noDataAvailable
    case dataAvailable
    case dataAvailableButStillLoadingImages
    case tryagain
}
struct RootForScannedRestaurant: View {
    @State var  viewState : appClipViewState = .isLoading
    @State private var turnOnNotificationsForSelectedRestaurant = true
    @State private var presentingAppStoreOverlay = false
    @StateObject var store = DataStore()
    @State var selectedRestaurant : Restaurant?
    @State private var selection: String? = nil
    @EnvironmentObject var appClipState: AppClipsState
    @State var isRoot = false
    @State var showAllRestaurants = false
    
    
    func getRestaurant(){
        print("Getting restaurant")
        if selectedRestaurant == nil {
        store.getRestaurant { result in
            switch result {
            case .success:
                withAnimation(.easeIn(duration: 0.6), {
                    selectedRestaurant = store.restaurant
                    viewState = .dataAvailable
                })
                
            case .failure:
                FirebaseService.shared.refreshToken { result in
                    switch result {
                    case .success:
                        getRestaurant()
                    case .failure:
                        viewState = .noDataAvailable
                    }
                }
                
            }
            
        }
        } else {
            withAnimation(.easeIn(duration: 0.6), {
                store.restaurant = selectedRestaurant
                if let restID = selectedRestaurant?.restaurantID{
                    store.restaurantID = restID
                }
                viewState = .dataAvailable
            })
        }
    }
    var body: some View {
        
        switch viewState{
        case .showLoadingIndicator:
            loading
        case .isLoading:
            loading.onAppear{
                getRestaurant()
            }
        case .noDataAvailable:
            tryagain
        case .dataAvailable:
            if isRoot {
            NavigationView{
            content
            }
            } else {
                content
            }
        default:
            tryagain
        }
    }
    
    var loading : some View{
        VStack{
            CustomProgressView(showText: true)
            
        }.frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }
    
    var tryagain : some View{
        
        VStack(spacing: 25 ){
            Image(systemName: "cloud")
                .renderingMode(.template)
                .font(.system(size: 80))
                .foregroundColor(.primary)
            VStack(spacing: 10 ){
                Text("failedTitle").font(.headline).fontWeight(.semibold).multilineTextAlignment(.center).lineLimit(10)
                Text("failedsubTitle").font(.subheadline).fontWeight(.regular).lineLimit(10).multilineTextAlignment(.center)
            }
            Button(action: {
                FirebaseService.shared.refreshToken { result in
                    switch result {
                    case .success:
                        viewState = .isLoading
                    case .failure:
                        viewState = .noDataAvailable
                    }
                }
            }){
                HStack{
                    Text("tryagain").font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                
            }.buttonStyle(NavigationDrawerPresableButtonStyle())
           
            
            Button(action: {
                showAllRestaurants = true
            }){
                HStack{
                    Text("Manual search").font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.secondaryTwo)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                
            }.buttonStyle(NavigationDrawerPresableButtonStyle(fadeOnPress: true, color: Color.secondaryTwo))
            .fullScreenCover(isPresented: $showAllRestaurants){
                RootForAllRestaurants(store: store)
            }
     
            
        }.padding(.horizontal, 50)
        
    }
    
    var content: some View {
       
            List {
                
                Section(header: SectionText2(text: "Menu").padding(.top)){
                    Button(action: {
                        store.selectedRestaurant = selectedRestaurant
                        store.needsToLoadConsumables = true
                        self.selection = "Meals"
                    }){
                        NavigationLink(destination: ChooseLanguageView(collectionName: .Meals, store: store), tag: "Meals", selection: $selection) {
                            SettingsOption(settingName: "Meals", settingIconSystemName: "", settingIconName: "icConsumables", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)), isBold: true)
                            
                        }
                    }
                    
                    Button(action: {
                        store.selectedRestaurant = selectedRestaurant
                        store.needsToLoadConsumables = true
                        self.selection = "Beverages"
                        
                    }){
                        NavigationLink(destination: ChooseLanguageView(collectionName: .Beverages, store: store), tag: "Beverages", selection: $selection) {
                            SettingsOption(settingName: "Beverages", settingIconSystemName: "", settingIconName: "icons8-coffee-50", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)), isBold: true)
                            
                        }
                    }
                                
                                
                }.onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        presentingAppStoreOverlay = true
                    })
                }
                
                
                Section(header: SectionText2(text: "About"), footer: Text(LocalizedStringKey("TermsofuseSum")).padding(.top,10).padding(.bottom,10)){
                    
                    if let  selectedRestaurant = selectedRestaurant{
                        
                        Button(action: {
                            let originalString = selectedRestaurant.address
                            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                            print(escapedString!)
                            if let string = escapedString {
                                let directionsURL = "http://maps.apple.com/?saddr=Current%20Location&daddr=\(string)"
                                guard let url = URL(string: directionsURL) else {
                                    return
                                }
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                            
                        }){
                            SettingsOption(settingName: selectedRestaurant.address, settingIconSystemName: "mappin", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                        }
                        
                        
                        Button(action: {
                            let telephone = "tel://"
                            let formattedString = telephone + selectedRestaurant.phone
                            guard let url = URL(string: formattedString) else { return }
                            UIApplication.shared.open(url)
                        }) {
                            SettingsOption(settingName: selectedRestaurant.phone, settingIconSystemName: "phone", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                        }
                        
                        if #available(iOS 14, *) {
                            if let url = URL(string: selectedRestaurant.websiteURL){
                                Link(destination: url, label: {
                                    SettingsOption(settingName: selectedRestaurant.websiteURL, settingIconSystemName: "link", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                                })
                            }
                        } else {
                            if selectedRestaurant.websiteURL.count > 3 {
                                Button(action: {
                                    
                                    let formattedString = selectedRestaurant.websiteURL
                                    guard let url = URL(string: formattedString) else { return }
                                    UIApplication.shared.open(url)
                                }) {
                                    SettingsOption(settingName: selectedRestaurant.websiteURL, settingIconSystemName: "link", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                                }
                            }
                        }
                        
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.restIDReceived)) { _ in
                if viewState == .dataAvailable {
                    viewState = .isLoading
                    appClipState.moveToRoot = true
                }
                
            }
            .navigationBarTitle("\(selectedRestaurant?.name ?? "Menu")" , displayMode: .large)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        presentingAppStoreOverlay = true
                                    }, label: {
                                        HStack{
                                            Spacer()
                                            Image(systemName: "arrow.down.app").font(.system(size: 22))
                                        }
                                        .frame(width: 70,height: 40)
                                        .appStoreOverlay(isPresented: $presentingAppStoreOverlay) {
                                            SKOverlay.AppClipConfiguration(position: .bottom)
                                        }
                                    }).foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
            )
            .listStyle(InsetGroupedListStyle())
            
            .onReceive(self.appClipState.$moveToRoot) { moveToRoot in
                if moveToRoot {
                    print("Move to dashboard: \(moveToRoot)")
                    selection = nil
                    self.appClipState.moveToRoot = false
                }
            }
        
    }
}

var isiOS13 = false
extension NSNotification {
    static let restIDReceived = NSNotification.Name.init("restIDReceived")
}
