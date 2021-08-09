//
//  SelectedRestaurant.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 19/08/2020.
//

import SwiftUI
import Firebase
import FirebaseMessaging
struct selectedRestaurant: View {
    
    @State private var notificationsAreOn = false
    @State private var revealDetailsTime = true
    @ObservedObject var store : DataStore
    var selectedRestaurant : Restaurant?
    @State private var selection: String? = nil
    let userDefaults = UserDefaults.standard
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        
        List {
            
            let firstBinding = Binding(
                get: { return self.notificationsAreOn },
                set: {
                    self.notificationsAreOn = $0
                            handleNotifications()
                }
            )
            Section(header: SectionText2(text: "Menu's").padding(.top)){
                Button(action: {
                    store.selectedRestaurant = selectedRestaurant
                    store.needsToLoadConsumables = true
                    
                    self.selection = "Meals"
                    
                }){
                    NavigationLink(destination: ChooseLanguageView(collectionName: .Meals, store: store), tag: "Meals", selection: $selection) {
                        SettingsOption(settingName: "Meals", settingIconSystemName: "", settingIconName: "icConsumables", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color.secondaryOne, isBold: true)
                        
                    }
                }
                            
                Button(action: {
                    store.selectedRestaurant = selectedRestaurant
                    store.needsToLoadConsumables = true
                    self.selection = "Beverages"
                   
                }){
                    NavigationLink(destination: ChooseLanguageView(collectionName: .Beverages, store: store), tag: "Beverages", selection: $selection) {
                        SettingsOption(settingName: "Beverages", settingIconSystemName: "", settingIconName: "icons8-coffee-50", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color.secondaryOne, isBold: true)
                        
                    }
                }
                            
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
                        SettingsOption(settingName: selectedRestaurant.address, settingIconSystemName: "mappin", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color.secondaryOne)
                    }
                    
                    
                    Button(action: {
                        let telephone = "tel://"
                        let formattedString = telephone + selectedRestaurant.phone
                        guard let url = URL(string: formattedString) else { return }
                        UIApplication.shared.open(url)
                    }) {
                        SettingsOption(settingName: selectedRestaurant.phone, settingIconSystemName: "phone", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color.secondaryOne)
                    }
                    
                    if #available(iOS 14, *) {
                        if let url = URL(string: selectedRestaurant.websiteURL){
                            Link(destination: url, label: {
                                SettingsOption(settingName: selectedRestaurant.websiteURL, settingIconSystemName: "link", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color.secondaryOne)
                            })
                        }
                    } else {
                        if selectedRestaurant.websiteURL.count > 3 {
                            Button(action: {
                                
                                let formattedString = selectedRestaurant.websiteURL
                                guard let url = URL(string: formattedString) else { return }
                                UIApplication.shared.open(url)
                            }) {
                                SettingsOption(settingName: selectedRestaurant.websiteURL, settingIconSystemName: "link", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color.secondaryOne)
                            }
                        }
                    }
                    
                }
            }
            
            if let  selectedRestaurant = selectedRestaurant{
                
                    Section(header: SectionText2(text: "Options"), footer: Text("notificationsFooter").padding(.top)){
                        HStack {
                            Toggle(isOn: firstBinding) {
                                SettingsOption(settingName: "Notifications", settingIconSystemName: "app.badge", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color.secondaryOne, isBold: true)
                            }.onAppear{
                                if let news  = userDefaults.array(forKey: "News") as? [String]{
                                if news.contains(selectedRestaurant.restaurantID) {
                                    notificationsAreOn = true
                                } else {
                                    notificationsAreOn = false
                                }
                                }
                            }
                            
                        }
                    }
              
            }
            
        }
        .onAppear{
            store.selectedRestaurant = selectedRestaurant
        }
        .navigationBarTitle("\(selectedRestaurant?.name ?? "")" , displayMode: .inline)
        .listStyle(InsetGroupedListStyle())
        .animation(nil)
    }
    
    
    func handleNotifications(){
        let news  =  userDefaults.array(forKey: "News") as? [String]
        if let selectedRestaurant = selectedRestaurant{
        if var news = news{
            news.append(selectedRestaurant.restaurantID)
            UserDefaults.standard.set(news, forKey: "News")
 
            if news.contains(selectedRestaurant.restaurantID) && notificationsAreOn{
                Messaging.messaging().subscribe(toTopic: selectedRestaurant.messagingTopic) { error in
                  print("Subscribed to \(selectedRestaurant.messagingTopic) topic")
                }
            } else {
                let news = news.filter { $0 != selectedRestaurant.restaurantID }
                UserDefaults.standard.set(news, forKey: "News")
                Messaging.messaging().unsubscribe(fromTopic: selectedRestaurant.messagingTopic) { error in
                  print("unsubscribe From \(selectedRestaurant.messagingTopic) topic")
                }
            }
        }
    }
    }
    
}

