//
//  MoreView.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 03/02/2021.
//

import SwiftUI

struct MoreView: View {
    @ObservedObject var store : AdminDataStore
    var body: some View {
        
            List{
                
//                Section(header: SectionText2(text: "Colaborate").padding(.vertical,10)){
////                NavigationLink(destination: OnBoarding(store: store)){
////
////                    moreListRow(name: "One Menu Business", systemName: "" , iconName : "iCAppIcon")
////                }
//                }
                
                Section(header: SectionText2(text: "App").padding(.vertical,10)){
                NavigationLink(destination: SettingsView(store: store)){
                    moreListRow(name: "Settings", systemName: "gear")
                }
                }
                    
                
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("More")
            
        }
    
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView(store: AdminDataStore())
    }
}
