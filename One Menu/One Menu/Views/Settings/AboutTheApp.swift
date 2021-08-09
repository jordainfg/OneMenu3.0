//
//  About the App.swift
//  One_Menu
//
//  Created by Jordain Gijsbertha on 17/08/2020.
//

import SwiftUI

struct AboutTheApp: View {
    var body: some View {
        List {
            Section(header : Text("One Menu")){
                HStack {
                    Text("Version")
                        .font(.caption)
                        .fontWeight(.bold)
                    Spacer()
                    Text("2.0.3").font(.caption)
                }
            }
            
            Section(header: Text("References")){
                Text("Icons provided by https://icons8.com, Illustration provided by https://www.freepik.com")
                    .font(.footnote).padding(.vertical)
            }
            
        }.listStyle(InsetGroupedListStyle())
        
        .navigationBarTitle("AboutApp")
    }
}

struct About_the_App_Previews: PreviewProvider {
    static var previews: some View {
        AboutTheApp()
    }
}
