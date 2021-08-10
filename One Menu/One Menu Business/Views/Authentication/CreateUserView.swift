//
//  CreateUserView.swift
//  Paradise Scrap
//
//  Created by Jordain Gijsbertha on 19/11/2020.
//

import SwiftUI

struct CreateUserView: View {
    @Environment(\.presentationMode) var presentationMode
    var disableForm : Bool {
        if email.isValidEmail() && password.count > 5{
            return false
        } else {
            return true
        }
      
    }
    @State private var email: String = ""
    @State private var password: String = ""
    
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
                
                Section(header: Text("Become part of One Menu.".lowercased())) {
                    /*
                     SwiftUI’s TextField enables autocorrect by default, which is what you’ll want in most cases. However, if you want to disable it you can do so by using the disableAutocorrection() modifier, like this:
                     */
                    
                    TextField("Email", text: $email).disableAutocorrection(true)
                        .alert(isPresented: $showingFailedAlert) {
                            Alert(title: Text("Oops"),
                                message: Text("It looks like you currently can't sign up. Please try again later or contact our support desk."),
                                dismissButton: Alert.Button.default(
                                    Text("Okay").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: { presentationMode.wrappedValue.dismiss()
                                       
                                    }
                                )
                            )
                            
                        }
                    /*SwiftUI’s SecureField works almost identically to a regular TextField except the characters are masked out for privacy. The underlying value you bind it to is still a plain string, of course, so you can check it as needed.
                     */
                    SecureField("Password", text: $password).disableAutocorrection(true)
                        .alert(isPresented: $showingSuccesAlert) {
                            Alert(title: Text("Success"),
                                message: Text("Please check your email for verification link before attempting to sign in."),
                                dismissButton: Alert.Button.default(
                                    Text("Awesome").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: {
                                       
                                        presentationMode.wrappedValue.dismiss()
                                        
                                    }
                                    
                                )
                            )
                            
                        }
                    
                }
                Section(header: Text("")) {
                    Button(action: {
                        isLoading = true
                        FirebaseService.shared.createUser(withEmail: email, password: password) { result in
                            switch result {
                            case .success:
                                
                                showingSuccesAlert = true

                            case .failure:
                                
                                showingFailedAlert = true
                            }
                            
                        }
                        
                    }, label: {
                        Text("Create acount").fontWeight(.semibold)
                    })
                }.disabled(disableForm)
            }.navigationBarTitle("Sign Up") .navigationBarItems(trailing: Button(action: {presentationMode.wrappedValue.dismiss()}, label: {
                Image(systemName: "xmark")
                    .renderingMode(.original)
                    .font(.largeTitle)
            }))
        }
        }
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
