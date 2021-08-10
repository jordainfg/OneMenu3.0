//
//  LanguageView.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 11/09/2020.
//

import SwiftUI

struct LanguageView: View {
    @EnvironmentObject var store : AdminDataStore
    @State var identifier = "nl"
    
    var languages = ["English", "Dutch"]
    @State private var selectedLanguage = "English"
   
    func doSomethingWith(value: String) {
        
        if value == "English"{
            store.language = "en"
            UserDefaults.standard.set("en", forKey: "userSelectedLanguage")
        } else if value == "Dutch"{
            store.language = "nl"
            UserDefaults.standard.set("nl", forKey: "userSelectedLanguage")
        }
            
      }
    var body: some View {
        List {
            Section(header : Text("")){
                
                
                
                Picker(selection: $selectedLanguage, label: Text("Selected").font(.footnote).fontWeight(.semibold)) {
                           ForEach(languages, id:\.self) { value in
                              Text(value).font(.footnote)
                           }
                        }
                      
                
            }
           
            
            
        }.listStyle(InsetGroupedListStyle())
       
        .navigationBarTitle("Language")
        
        
//        VStack {
//            Button("Dutch", action: {
//                self.identifier = "nl"
//            })
//            Button("English", action: {
//                self.identifier = "en"
//            })
//            Text("privacyParagraph")
//        }
//        .environment(\.locale, .init(identifier: identifier))
    }
}

struct LanguageView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageView()
    }
}
