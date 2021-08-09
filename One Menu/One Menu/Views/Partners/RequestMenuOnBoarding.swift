//
//  RequestMenuOnBoarding.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 10/10/2020.
//

import SwiftUI

struct RequestMenuOnBoarding: View {
    @State private var showingSuccesAlert = false
    @State private var showingFailedAlert = false
    @Environment(\.presentationMode) var presentationMode
    // Section 1
    @State var name: String = ""
    @State var restaurantName: String = ""
    @State var address: String = ""
    @State var email: String = ""
    @State var phoneNumber: String = ""
    // section2
    @State var quantity: Int = 1
    
    
    @ObservedObject var store : DataStore
    var disableForm : Bool {
        !email.isValidEmail()
    }
    
    func createRequest(){
        
                let newRequestDict:[String:Any] = ["partnerName" : name,
                                                   "restaurantName" : restaurantName,
                                                   "restaurantAddress": address,
                                                   "email": email,
                                                   "phoneNumber" : phoneNumber
                                                   ]
        if let partnerRequest = PartnerRequest(dictionary: newRequestDict){


            store.createPartnerRequest(request : partnerRequest){result in

                switch result {
                case .success:

                    showingSuccesAlert = true

                case .failure(_):
                    
                  
                    showingFailedAlert = true

                }
            }
        }
    }
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("RestaurantInformation"), footer:Text(disableForm ? "Pleasefill" : "").foregroundColor(.red)) {
                    TextField("Yourname", text: $name)
                    TextField("Restaurantname", text: $restaurantName)
                    TextField("Restaurantaddress", text: $address)
                    TextField("Phonenumber", text: $phoneNumber).keyboardType(.phonePad)
                    TextField("Email", text: $email)
                        .alert(isPresented: $showingFailedAlert) {
                            Alert(title: Text("Success"),
                                message: Text(LocalizedStringKey("requestFailAlertTitle")),
                                dismissButton: Alert.Button.default(
                                    Text("Okay").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: { presentationMode.wrappedValue.dismiss() }
                                )
                            )
                            
                        }
                    
                }
                Section(header: Text("")) {
                    Button(action: {
                        
                        
                        createRequest()
                        
                        
                        
                        
                    }, label: {
                        Text("SendRequest").fontWeight(.semibold)
                })
                }.disabled(disableForm)
                
            }.navigationBarTitle("Partnerrequest", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.largeTitle)
                    .foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
            }))
            .alert(isPresented: $showingSuccesAlert) {
                Alert(title: Text("Success"),
                    message: Text(LocalizedStringKey("requestSuccessAlertTitle")),
                    dismissButton: Alert.Button.default(
                        Text("Awesome").foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))), action: { presentationMode.wrappedValue.dismiss() }
                    )
                )
                
            }
        }
    }
}

struct RequestMenuOnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        RequestMenuOnBoarding(store: DataStore())
    }
}
