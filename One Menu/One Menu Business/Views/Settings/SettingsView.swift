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
    //@Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var appearanceStore : AppearanceStore
//    @EnvironmentObject var store : DataStore
    var appearanceStore : AppearanceStore = AppearanceStore()
    @ObservedObject var store: AdminDataStore
    
    var languages = ["English", "Dutch"]
  
    @State private var selectedLanguageForiOS13 = UserDefaults.standard.string(forKey: "userSelectedLanguage") == "nl" ? 0 : 1
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State private var showingAlert = false
    
    @State private var showingSubscriptionView = false
    
    func languageChange(_ tag: Int){
        if tag == 1{
            store.language = "en"
            UserDefaults.standard.set("en", forKey: "userSelectedLanguage")
        } else if tag == 0{
            store.language = "nl"
            UserDefaults.standard.set("nl", forKey: "userSelectedLanguage")
        }
    }
    var body: some View {
      
        List {
            
            
            Section(header: SectionText(text: "Acount")) {
                NavigationLink(destination: ProfileView().environmentObject(appearanceStore)) {
                    
                    SettingsOptionButton(settingName: "Profile", settingIconSystemName: "person.crop.circle.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)){
                        
                    }
                   
                }
               
                    SettingsOptionButton(settingName: "Subscription", settingIconSystemName: "star.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.9735069871, green: 0.2642431557, blue: 0.381446898, alpha: 1)){
                        showingSubscriptionView = true
                    }.sheet(isPresented: $showingSubscriptionView){
                        SubscriptionView()
                    }
                
                
            }
            
            Section(header: Text("APP")) {
                
//                Picker(selection: $selectedLanguageForiOS13, label: SettingsOption(settingName: "Language", settingIconSystemName: "a", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.1019607843, green: 0.7803921569, blue: 0.3450980392, alpha: 1))) {
//                    Text("Dutch").font(.footnote).tag(0)
//                    Text("English").font(.footnote).tag(1)
//                        }.onChange(of: selectedLanguageForiOS13) { value in
//                            if value == 1{
//                                store.language = "en"
//                                UserDefaults.standard.set("en", forKey: "userSelectedLanguage")
//                            } else if value == 0{
//                                store.language = "nl"
//                                UserDefaults.standard.set("nl", forKey: "userSelectedLanguage")
//                            }
//                        }
                ChangeColorThemeSegment()
                
                
            }
            
            Section(header: SectionText(text: "Feedback")) {
                
                SettingsOptionButton(settingName: "Leave Review", settingIconSystemName: "heart.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 1, green: 0.2103750706, blue: 0.3031310439, alpha: 1)){
                    if #available(iOS 14, *) {
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    } else {
                        SKStoreReviewController.requestReview()
                    }
                }
                
//
                
                SettingsOptionButton(settingName: "Report a problem", settingIconSystemName: "envelope.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)){
                    if MFMailComposeViewController.canSendMail() {
                        
                        self.isShowingMailView = true
                        
                    } else {
                        self.showingAlert = true
                    }
                    
                }.sheet(isPresented: $isShowingMailView) {
                    MailView(isShowing: self.$isShowingMailView, result: self.$result,subject : "Contact from One Menu App", body : "<p>Please describe your problem using the app or feature request.</p>")
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Copy email to clipboard"), message: Text("business.featurex@gmail.com"), primaryButton: .destructive(Text("Copy")) {
                        UIPasteboard.general.string = "business.featurex@gmail.com"
                    }, secondaryButton: .cancel())
                    
                }
                
               
            }
            
            Section(header: SectionText(text: "Social")) {

                SettingsOptionButton(settingName: "Instagram", settingIconSystemName: "", settingIconName: "icInstragramFill", iconBackgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)){
                    guard let instagram = URL(string: "https://www.instagram.com/onemenu.nl/") else { return }
                    UIApplication.shared.open(instagram)
                }
                
//                SettingsOptionButton(settingName: "Facebook", settingIconSystemName: "", settingIconName: "icFacebook", iconBackgroundColor: #colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 1)){
//                    guard let instagram = URL(string: "https://m.facebook.com/ParadiseScrap.Brkg/") else { return }
//                    UIApplication.shared.open(instagram)
//                }
                
                SettingsOptionButton(settingName: "What's app", settingIconSystemName: "phone.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.1450980392, green: 0.8274509804, blue: 0.4, alpha: 1)){
                    guard let instagram = URL(string: "https://wa.me/message/LQGXHL7RCFN6D1") else { return }
                    UIApplication.shared.open(instagram)
                }
                
//                SettingsOptionButton(settingName: "Call us", settingIconSystemName: "phone.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)){
//                    let telephone = "tel://"
//                      let formattedString = telephone + "+31638482214"
//                      guard let url = URL(string: formattedString) else { return }
//                      UIApplication.shared.open(url)
//                }
            }
            
            Section(header: SectionText(text: "General")) {
                
                NavigationLink(
                    destination: AboutTheApp()) {
                    SettingsOption(settingName: "About App", settingIconSystemName: "house.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 1, green: 0.3725490196, blue: 0.3098039216, alpha: 1))
                }
                
                
                NavigationLink(
                    destination: PrivacyPolicy()) {
                    SettingsOption(settingName: "Privacy policy", settingIconSystemName: "lock.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.01568627451, green: 0.4901960784, blue: 0.9843137255, alpha: 1))
                }
                
                NavigationLink(
                    destination: PrivacyPolicy(isTermsofUse: true)) {
                    SettingsOption(settingName: "Terms of use", settingIconSystemName: "doc.text.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.1411764706, green: 0.3294117647, blue: 0.9215686275, alpha: 1))
                }
                
            }
            
        }
        
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Settings")
        .listStyle(InsetGroupedListStyle())
        
        .animation(.none)
        
       
    }
}
struct SectionText: View {
    var text : String
    var body: some View {
        Text(text).font(.caption).fontWeight(.semibold).padding(.bottom,10)
    }
}

extension UIApplication {
    var currentScene: UIWindowScene? {
        connectedScenes.first as? UIWindowScene
    }
}
