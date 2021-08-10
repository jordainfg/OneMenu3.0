//
//  ProfileView.swift
//  Paradise Scrap
//
//  Created by Jordain Gijsbertha on 02/12/2020.
//

import SwiftUI

struct ProfileView: View {
    
    @State var showAlert = false
    
    var body: some View {
        List{
            Section(header: Text("About")) {
                if let user = FirebaseService.shared.authenticationState {
                VStack(alignment: .leading, spacing: 10){
                    Text("User").font(.caption).foregroundColor(.secondary).padding(.top)
                    Text("\(user.name)").font(.subheadline).fontWeight(.bold)
                    Text("Email").font(.caption).foregroundColor(.secondary).padding(.top)
                    Text("\(user.email)").font(.subheadline).fontWeight(.bold).padding(.bottom)
                    
                }
                }
            }
            Section(header: Text("")) {
                Button(action: {showAlert = true }, label: {
                    Text("Sign out").foregroundColor(.red).fontWeight(.semibold)
                }).alert(isPresented: $showAlert) { () -> Alert in
                    let primaryButton = Alert.Button.destructive(Text("Cancel")) {
                        
                    }
                    let secondaryButton = Alert.Button.default(Text("Yes")) {
                        FirebaseService.shared.clearAllSessionData()
                    }
                    return Alert(title: Text("Are your sure you want to log out?"), message: Text(""), primaryButton: primaryButton, secondaryButton: secondaryButton)
                }
            }
            
            
        }.listStyle(InsetGroupedListStyle()).navigationTitle("Profile")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
