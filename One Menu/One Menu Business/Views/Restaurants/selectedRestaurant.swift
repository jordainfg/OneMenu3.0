//
//  selectedRestaurant.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 22/01/2021.
//

import SwiftUI

struct selectedRestaurant: View {
    @State var name : String = ""
    var selectedRestaurant : Restaurant?
    @State private var selection: String? = nil
    @State var showingActionSheet : Bool = false
    @ObservedObject var store: AdminDataStore
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
    @State  var isVisable = false
    @State private var showingSubscriptionView = false
    var body: some View {
            List {
                
                Section(header: SectionText(text:"Menu visabilty"),footer:Text( !isPremiumUser ? "Your customers will only be able to view and interact with your menu if you are a One Menu Premium subscriber." : "When you're no longer a One Menu subscriber, your menu will also no longer be available for your customers.")){
                    let firstBinding = Binding(
                        get: { self.isVisable },
                        set: {
                            self.isVisable = $0
                            
                            if $0 == true {
                                store.showRestaurant(isEditing: false)
                            } else {
                                store.showRestaurant(isEditing: true)
                            }
                        }
                    )
                 
                        VStack {
                            if isPremiumUser{
                            Toggle(isOn: firstBinding) {
                                Text("Show in One Menu").font(.footnote)
                            }
                                Link("View in One Menu", destination: URL(string: "https://one-menu-40f52.web.app/restaurants?restaurantID=\(selectedRestaurant?.restaurantID ?? "")")!)
                                .font(Font.headline.weight(.bold))
                                
                            } else {
                                Button(action: {
                                    showingSubscriptionView = true
                                }) {
                                    Text("Subscribe")
                                }   .sheet(isPresented: $showingSubscriptionView, onDismiss: {if isPremiumUser{
                                            store.showRestaurant(isEditing: false)
                                            isVisable = true
                                    
                                }}){
                                    SubscriptionView()
                                }
                            }
                        }
                }
                
                Section(header: SectionText(text: "Menu's").padding(.top)){
               
                    NavigationLink(destination: ChooseLanguageView(collectionName: .Meals, store: store).navigationBarTitle("Manage",displayMode: .inline)) {
                    SettingsOption(settingName: "Meals", settingIconSystemName: "", settingIconName: "icConsumables", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)), isBold: true)
                    
                }
                    NavigationLink(destination: ChooseLanguageView(collectionName: .Beverages, store: store).navigationBarTitle("Manage",displayMode: .inline)) {
                        SettingsOption(settingName: "Beverages", settingIconSystemName: "", settingIconName: "icons8-tea-50", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)), isBold: true)
                        
                    }
                }
                
                Section(header: SectionText(text: "Premium")){
                    if let selectedRestaurant = selectedRestaurant{
                        NavigationLink(destination: QrCodeView(restaurantID :"https://one-menu-40f52.web.app/restaurants?restaurantID=\(selectedRestaurant.restaurantID)", store: store).navigationBarTitle("Qr codes",displayMode: .inline)) {
                            SettingsOption(settingName: "Qr codes", settingIconSystemName: "qrcode.viewfinder", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)), isBold: true)
                            
                        }
                    }
                    if selectedRestaurant != nil{
                        NavigationLink(destination: NotificationsView(store: store).navigationBarTitle("Notifications",displayMode: .inline)) {
                        SettingsOption(settingName: "Notifications", settingIconSystemName: "bell.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0),foregroundColor: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)), isBold: true)
                        
                    }
                    }
                }

                Section(header: SectionText(text: "About")){
                    
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
                        }
                        
                    }
                }
                
                Section(header: SectionText(text: "Manage")){
                   
                    Button(action: {
                       showingActionSheet = true
                    }) {
                        Text("Delete").fontWeight(.semibold).foregroundColor(.red)
                    }.actionSheet(isPresented: $showingActionSheet) {
                        ActionSheet(title: Text("Confirmation"), message: Text("\(selectedRestaurant?.name ?? "Your restaurant") will be deleted. Are you sure you want to delete this restaurant? All created meals and beverages will also be deleted."), buttons: [
                            
                            .destructive(Text("Delete").foregroundColor(.red)) {deleteRestaurant()},
                            .default(Text("Cancel")) {}
                        ])
                    }
                    
                }
                
                Section(header: SectionText     (text: "Support"),footer:Text("\(selectedRestaurant?.restaurantID ?? "")")){
                SettingsOptionButton(settingName: "Contact us", settingIconSystemName: "phone.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 1, green: 0.4332074523, blue: 0.3725937009, alpha: 1)){
                    if selectedRestaurant != nil {
                   guard let instagram = URL(string: "https://wa.me/message/LQGXHL7RCFN6D1") else { return }
                    UIApplication.shared.open(instagram)
                    }
                }
                }
                
            }
            .navigationBarTitle("Your restaurant",displayMode: .inline)
            .listStyle(InsetGroupedListStyle())
            .onAppear{
                if let selectedRestaurant = selectedRestaurant{
                store.restaurantID = selectedRestaurant.restaurantID
                store.selectedRestaurant = selectedRestaurant
                    if selectedRestaurant.isEditing{
                     isVisable = true
                    } else { // editing is true
                        if !isPremiumUser{ // check if is premium
                            store.showRestaurant(isEditing: true) // not premium , make menu unailable
                        } else {
                        isVisable = true
                        }
                    }
                }
            }
        
    }
    
    func deleteRestaurant(){
        if let selectedRestaurant = selectedRestaurant {
            
            store.deleteRestaurant( restaurant: selectedRestaurant) { result in
                switch result {
                case .success:
                    presentationMode.wrappedValue.dismiss()
                case .failure:
                    presentationMode.wrappedValue.dismiss()
                }
                
            }
        }
    }
}


