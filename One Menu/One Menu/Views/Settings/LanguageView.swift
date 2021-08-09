//
//  LanguageView.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 11/09/2020.
//

import SwiftUI

struct LanguageView: View {
    @ObservedObject var store : DataStore
    @State var identifier = "nl"
    
    var languages = ["English", "Dutch"]
    @State private var selectedLanguage = "English"
    @AppStorage("userSelectedLanguage") var language: String = "nl"
    func doSomethingWith(value: String) {
        
        if value == "English"{
          language = "en"
            
        } else if value == "Dutch"{
            language = "nl"
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
        LanguageView(store: DataStore())
    }
}
