//
//  MoreView.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 02/02/2021.
//

import SwiftUI

struct More: View {
    @ObservedObject var store : DataStore
    var body: some View {
        NavigationView {
            List{
                
                Section(header: SectionText2(text: "Colaborate").padding(.vertical,10)){
                NavigationLink(destination: OnBoarding(store: store)){
                    
                    moreListRow(name: "One Menu Business", systemName: "" , iconName : "iCAppIcon")
                }
                }
                
                Section(header: SectionText2(text: "Options").padding(.vertical,10)){
                NavigationLink(destination: SettingsView(store: store)){
                    moreListRow(name: "Settings", systemName: "gear")
                }
                }
                    
                
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("More")
            
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        More(store: DataStore())
    }
}

