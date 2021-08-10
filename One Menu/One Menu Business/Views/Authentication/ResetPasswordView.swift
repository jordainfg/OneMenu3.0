//
//  ResetPasswordView.swift
//  Paradise Scrap
//
//  Created by Jordain Gijsbertha on 19/11/2020.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    var disableForm : Bool {
        !email.isValidEmail()
    }
    @State private var email: String = ""
 
    @State private var showingSuccesAlert = false
    @State private var showingFailedAlert = false
    @State private var isLoading = false
    var body: some View {
        ZStack{
                    
                    if isLoading{
                        CustomProgressView().zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                    }
        NavigationView {
            Form {
                
                Section(header: Text("Please enter the email address you signed up with.".lowercased())) {
                    /*
                     SwiftUI’s TextField enables autocorrect by default, which is what you’ll want in most cases. However, if you want to disable it you can do so by using the disableAutocorrection() modifier, like this:
                     */
                    
                    TextField("Email", text: $email).disableAutocorrection(true)
                        .alert(isPresented: $showingFailedAlert) {
                            Alert(title: Text("Oops"),
                                message: Text("It looks like you currently reset your password. Please try again later or contact our support desk."),
                                dismissButton: Alert.Button.default(
                                    Text("Okay").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: {
                                       
                                        presentationMode.wrappedValue.dismiss()
                                        
                                    }
                                )
                            )
                            
                        }
                    
                }
                .alert(isPresented: $showingSuccesAlert) {
                    Alert(title: Text("Success"),
                        message: Text("We sent a password reset link. Check your inbox and follow the llink to set your new password."),
                        dismissButton: Alert.Button.default(
                            Text("Awesome").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: {
                               
                                presentationMode.wrappedValue.dismiss()
                                
                            }
                        )
                    )
                    
                }
                Section(header: Text("")) {
                    Button(action: {
                        isLoading = true
                        FirebaseService.shared.sendPasswordResetEmail(email: email) { result in
                            switch result {
                            case .success:
                               
                                showingSuccesAlert = true

                            case .failure:
                                
                                showingFailedAlert = true
                            }
                            
                        }
                        
                    }, label: {
                        Text("Reset").fontWeight(.semibold)
                    })
                }.disabled(disableForm)
            }.navigationBarTitle("Reset password") .navigationBarItems(trailing: Button(action: {presentationMode.wrappedValue.dismiss()}, label: {
                Image(systemName: "xmark")
                    .renderingMode(.original)
                    .font(.largeTitle)
            }))
        }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
