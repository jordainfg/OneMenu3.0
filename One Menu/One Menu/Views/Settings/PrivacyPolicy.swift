//
//  PrivacyPolicy.swift
//  One_Menu
//
//  Created by Jordain Gijsbertha on 17/08/2020.
//

import SwiftUI

struct PrivacyPolicy: View {
    var isTermsofUse: Bool = false
    var body: some View {
        List {
            Section(header : Text("One Menu")){
                if  isTermsofUse {
                    Text(NSLocalizedString("termsOfUseParagraph", comment: ""))
                        .font(.caption)
                        .fontWeight(.bold)
                } else {
                    Text(NSLocalizedString("privacyParagraph", comment: ""))
                        .font(.caption)
                        .fontWeight(.bold)
                }
                   
                    
                
            }
            
            
            
        }.listStyle(InsetGroupedListStyle())
       
        .navigationBarTitle(isTermsofUse ? "Termsofuse": "Privacy")
    }
}

struct PrivacyPolicy_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicy()
    }
}
