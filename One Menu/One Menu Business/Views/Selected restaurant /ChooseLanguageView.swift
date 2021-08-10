//
//  MenuCreatorView.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 26/01/2021.
//

import SwiftUI

struct ChooseLanguageView: View {
    
    @State var languageType : languageType  = .Dutch
    
    // Support
    @State var isShowingMailView = false
   
    
    @State private var showingAlert = false
    
    @State var isMeal = false
    @State var collectionName : collectionName = .Meals
    
    @ObservedObject var store: AdminDataStore
    var body: some View {
        List{
            
            Section(header: Text("")){
                NavigationLink(
                    destination: ConsumableMenuOverview(collectionName: collectionName, languageType: .English , store: store),
                    label: {
                        Text("English")
                    })
            }
            
            Section(footer: Text("")){
                NavigationLink(
                    destination: ConsumableMenuOverview(collectionName: collectionName, languageType: .Dutch , store: store),
                    label: {
                        Text("Dutch")
                    })
            }
            
            Section(header: Text("Support"),footer: Text("If you are experiencing any difficulties using one menu, please don't hesitate to contact us. ")){
                
                SettingsOptionButton(settingName: "Contact us", settingIconSystemName: "envelope.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)){
                   guard let instagram = URL(string: "https://wa.me/message/LQGXHL7RCFN6D1") else { return }
                    UIApplication.shared.open(instagram)
                }
                
                
            }
        }
        .navigationBarTitle("Language")
        .listStyle(InsetGroupedListStyle())
    }
}
