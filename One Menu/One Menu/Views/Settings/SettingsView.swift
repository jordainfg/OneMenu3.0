//
//  SettingsView.swift
//  BaseSwiftUIAPP
//
//  Created by Jordain Gijsbertha on 03/08/2020.
//

import SwiftUI
import MessageUI
import StoreKit

struct SettingsView: View {
 
    var appearanceStore : AppearanceStore = AppearanceStore()
    @ObservedObject var store : DataStore
    
    @AppStorage("userSelectedLanguage") var language: String = "en"
    var languages = ["English", "Dutch"]
  
    @State private var selectedLanguageForiOS13 = UserDefaults.standard.string(forKey: "userSelectedLanguage") == "en" ? 1 : 0
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State private var showingAlert = false
    
    func languageChange(_ tag: Int){
        if tag == 1{
            language = "en"
            
        } else if tag == 0{
            language = "nl"
            
        }
    }
    var body: some View {
        
        List {
            
            Section(header: Text("APP")) {
                ChangeColorThemeSegment()

                    Picker(selection: $selectedLanguageForiOS13, label: SettingsOption(settingName: "Language", settingIconSystemName: "a", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.1019607843, green: 0.7803921569, blue: 0.3450980392, alpha: 1))) {
                        Text("Dutch").font(.footnote).tag(0)
                        Text("English").font(.footnote).tag(1)
                            }.onChange(of: selectedLanguageForiOS13) { value in
                                if value == 1{
                                    language = "en"
                                } else if value == 0{
                                    language = "nl"
                                    
                                }
                            }
               
            }
            
            Section(header: Text("Feedback")) {
                
                SettingsOptionButton(settingName: "LeaveReview", settingIconSystemName: "heart.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 1, green: 0.2103750706, blue: 0.3031310439, alpha: 1)){
                    if #available(iOS 14, *) {
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    } else {
                        SKStoreReviewController.requestReview()
                    }
                }
                
//
                
                SettingsOptionButton(settingName: "Report", settingIconSystemName: "envelope.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)){
                    if MFMailComposeViewController.canSendMail() {
                        
                        self.isShowingMailView = true
                        
                    } else {
                        self.showingAlert = true
                    }
                    
                }.sheet(isPresented: $isShowingMailView) {
                    MailView(isShowing: self.$isShowingMailView, result: self.$result,subject : "Contact from One Menu App", body : "<p>Please describe your problem using the app, feature request, or request implementation of your restaurant menu.</p>")
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Copy email to clipboard"), message: Text("business.featurex@gmail.com"), primaryButton: .destructive(Text("Copy")) {
                        UIPasteboard.general.string = "business.featurex@gmail.com"
                    }, secondaryButton: .cancel())
                    
                }
            }
            
            Section(header: Text("Social")) {

                SettingsOptionButton(settingName: "Instagram", settingIconSystemName: "", settingIconName: "icInstragramFill", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)){
                    guard let instagram = URL(string: "https://instagram.com/onemenu.nl?igshid=1kx9f1n2jh9c2") else { return }
                    UIApplication.shared.open(instagram)
                }
                
//                SettingsOption(settingName: "What's app", settingIconSystemName: "", settingIconName: "icWhatsApp", iconBackgroundColor: #colorLiteral(red: 0.2784313725, green: 0.7607843137, blue: 0.3294117647, alpha: 1)).onTapGesture{
//                    guard let instagram = URL(string: "https://wa.me/+59996929717/?text=Problem%20receiving%20my%20brocard") else { return }
//                    UIApplication.shared.open(instagram)
//                }
            }
            
            Section(header: Text("General")) {
                
                NavigationLink(
                    destination: AboutTheApp()) {
                    SettingsOption(settingName: "AboutApp", settingIconSystemName: "house.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 1, green: 0.3725490196, blue: 0.3098039216, alpha: 1))
                }
                
                
                NavigationLink(
                    destination: PrivacyPolicy()) {
                    SettingsOption(settingName: "Privacybeleid", settingIconSystemName: "lock.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.01568627451, green: 0.4901960784, blue: 0.9843137255, alpha: 1))
                }
                
                NavigationLink(
                    destination: PrivacyPolicy(isTermsofUse: true)) {
                    SettingsOption(settingName: "Termsofuse", settingIconSystemName: "doc.text.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.1411764706, green: 0.3294117647, blue: 0.9215686275, alpha: 1))
                }
  
                
            }
            
        }
        
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Settings", displayMode : .inline)
     
        
     
       
    }
}

//extension Binding {
//    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
//        return Binding(
//            get: { self.wrappedValue },
//            set: { selection in
//                self.wrappedValue = selection
//                handler(selection)
//        })
//    }
//}
extension UIApplication {
    var currentScene: UIWindowScene? {
        connectedScenes.first as? UIWindowScene
    }
}
