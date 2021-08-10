//
//  CreateRestaurantView.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 29/01/2021.
//

import SwiftUI


struct CreateRestaurant: View {
    
    @ObservedObject var store : AdminDataStore
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var requiredFieldsAreFilled = true
    
    @State private var showingSuccesAlert = false
    @State private var showingFailAlert = false
    @State var erroDiscription: String = ""
    
    @State var restaurantID: String = ""
    @State var name: String = ""
    @State var phone: String = ""
    @State var address: String = ""
    @State var color: String = ""
    @State var description: String = ""
    @State var emailAddress: String = ""
    @State var facebookURL: String = ""
    @State var instagramURL: String = ""
    @State var websiteURL: String = ""
    @State var logoURL: String = ""
    @State var hour: String = ""
    @State var hours: [String]  = []
    @State var image: String = ""
    @State var imageReference: String = ""
    @State var messagingTopic: String = ""
    @State var hasMultiLanguageSupport: Bool = false
    @State var isEditing: Bool = true
    @State var subscriptionPlan: String = ""
    
    
    @State var showTermsOfUse = false
    @State var showFullTermsOfUse = false
    @State var privacyPoints: [String]  = ["Nudity or sexual activity", "Hate speech or symbols", "Violence or dangerous organizations", "Sale or illegal or regulated goods", "Bullying or harassment", "Intellectual property violation", "Suicide, self-injury or eating disorders"]
    func deleteHours(at offsets: IndexSet) {
        hours.remove(atOffsets: offsets)
    }
    var body: some View {
     
            Form {
                
                Section(header: Text("About")) {

                    HStack{
                        Text("Restaurant name").font(.subheadline).foregroundColor(.secondary)
                        Spacer()
                        TextField("Little Fern", text: $name)
                    }
                    
                    HStack{
                        Text("Restaurant address").font(.subheadline).foregroundColor(.secondary)
                        Spacer()
                        TextField("Carrer de Pere IV", text: $address).foregroundColor(.secondary)
                    }
                    
                    
                    
                    HStack{
                        Text("Phone number").font(.subheadline).foregroundColor(.secondary)
                        Spacer()
                        TextField("+3638482214", text: $phone).keyboardType(.numberPad)
                    }
                    
                    HStack{
                        Text("Email address").font(.subheadline).foregroundColor(.secondary)
                        Spacer()
                        TextField("littleFern@fer.nl", text: $emailAddress)
                    }.alert(isPresented: $showingFailAlert) {
                        Alert(title: Text("Whoops"), message: Text("Looks like we could'nt create your restaurant. Please try again later or contact us."), dismissButton: .default(Text("Okay")))
                    }
                    
                    HStack{
                        Text("Description:").font(.subheadline).foregroundColor(.secondary)
                        Spacer()
                        TextField("Little Fern is a community-focused casual cafe located in the heart of the Poblenou district. ", text: $description)
                    }
                    
                    
                }
                
                //                Section(header: Text("Hours")) {
                //
                //                    HStack{
                //                        TextField("Thursday, 9am–6pm", text: $hour)
                //                        Spacer()
                //                        Button(action:{hours.append(hour)}){
                //                            Image(systemName: "plus.circle.fill")
                //                                .renderingMode(.template)
                //                                .font(.headline)
                //                                .foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                //                        }
                //                    }
                //
                //
                //                }
                //                ForEach(hours, id: \.self){ hour in
                //                    Text(hour).padding(.leading).foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                //                }.onDelete(perform: deleteHours)
                //
                //                Section(header: Text("Links")) {
                //                    HStack{
                //                                       Text("facebookURL:").font(.subheadline).foregroundColor(.secondary)
                //                                       Spacer()
                //                                       TextField("#https://www.facebook.com/profile", text: $facebookURL)
                //                                   }
                //                                   HStack{
                //                                       Text("instagramURL:").font(.subheadline).foregroundColor(.secondary)
                //                                       Spacer()
                //                                       TextField("https://www.instagram.com/", text: $instagramURL)
                //                                   }
                //                                   HStack{
                //                                       Text("websiteURL:").font(.subheadline).foregroundColor(.secondary)
                //                                       Spacer()
                //                                       TextField("https://", text: $websiteURL)
                //                                   }
                //
                //                }
                //
                
                Section(header: Text("Agreements")){
                    
                    SettingsOption(settingName: "Terms of use", settingIconSystemName: "hand.raised.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 0.00336188334, green: 0.477694273, blue: 1, alpha: 1)).onTapGesture{
                        withAnimation{
                            showTermsOfUse.toggle()
                        }
                        
                    }
                    if showTermsOfUse {
                        VStack {
                            
                            
                            HStack(spacing: 20){
                                
                                Text("By creating a restaurant you agree to One menu's terms of use. Which state that you will not add any of the following to the one menu app.").font(.footnote).foregroundColor(.secondary)
                                
                            }
                            
                            VStack{
                                ForEach(privacyPoints, id : \.self){ point in
                                    HStack {
                                        Text("• \(point)").foregroundColor(.secondary).font(.footnote)
                                        Spacer()
                                    }.padding(1)
                                }
                            }.padding(.horizontal,10)
                            
                            HStack(spacing: 20){
                                
                                Text("Failure to comply will result in termination of account and the right for us to sue. ").font(.footnote).foregroundColor(.secondary)
                                
                            }
                            Button(action: {
                                // your action here
                                showFullTermsOfUse.toggle()
                            }) {
                                Text("More").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).font(.caption).fontWeight(.semibold).padding()
                            }.sheet(isPresented: $showFullTermsOfUse){
                                NavigationView {
                                    PrivacyPolicy(isTermsofUse: true)
                                        .navigationBarItems(trailing: closeButtonNavBarItem{showFullTermsOfUse = false})
                                }
                            }.buttonStyle(PlainButtonStyle())
                        }
                        .padding()
                    }
                }
                
                Section(header: Text("Options"),footer: Text(requiredFieldsAreFilled ? "" : "One or more fields have not been filled." ).foregroundColor(Color.red)) {
                    Button(action: {
                        checkRequiredFields()
                        if requiredFieldsAreFilled{
                            let newRestaurantDict:[String:Any] = ["restaurantID" : "",
                                                                  "name" : name,
                                                                  "phone" : phone,
                                                                  "address": address,
                                                                  "color" : color,
                                                                  "description": description,
                                                                  "emailAddress" : emailAddress,
                                                                  "facebookURL": facebookURL,
                                                                  "instagramURL": instagramURL,
                                                                  "websiteURL": websiteURL,
                                                                  "logoURL": logoURL,
                                                                  "hours" : hours,
                                                                  "image": image,
                                                                  "imageReference" : imageReference,
                                                                  "messagingTopic": name,
                                                                  "subscriptionPlan": Int(subscriptionPlan) ?? 0,
                                                                  "isEditing": isEditing,
                                                                  "hasMultiLanguageSupport" : hasMultiLanguageSupport
                                                                  
                            ]
                            if let restaurant = Restaurant(dictionary: newRestaurantDict){
                                
                                
                                store.createRestaurant(restaurant:restaurant ){result in
                                    
                                    switch result {
                                    case .success:
                                        
                                        showingSuccesAlert = true
                                        
                                    case let .failure(error):
                                        erroDiscription = error.localizedDescription
                                        showingFailAlert = true
                                        presentationMode.wrappedValue.dismiss()
                                        print("Fail")
                                        
                                    }
                                }
                            }
                        } else{
                            
                        }
                    }
                    ) {
                        Text("Create")
                    }
                    
                    .alert(isPresented: $showingSuccesAlert) {
                        Alert(title: Text("Awesome"), message: Text("Your restaurant has been created."), dismissButton: Alert.Button.default(
                            Text("Dismiss"), action: { presentationMode.wrappedValue.dismiss() }
                        ))
                    }
                }
                
                Section(header: Text("Support"),footer: Text("Please contact us if you face any problems using One Menu.")){
                    
                    SettingsOptionButton(settingName: "Contact us", settingIconSystemName: "phone.fill", settingIconName: "", iconBackgroundColor: #colorLiteral(red: 1, green: 0.4336897135, blue: 0.3727793396, alpha: 1)){
                        
                        guard let instagram = URL(string: "https://wa.me/message/LQGXHL7RCFN6D1") else { return }
                        UIApplication.shared.open(instagram)
                        
                    }
                    
                }
                
                
            }
            .navigationBarTitle("New restaurant",displayMode: .inline)
       
        
    }
    func checkRequiredFields(){
        if name.isEmpty || phone.isEmpty || address.isEmpty || description.isEmpty || emailAddress.isEmpty{
            requiredFieldsAreFilled = false
        } else {
            requiredFieldsAreFilled = true
        }
    }
    struct RestaurantRow_Previews: PreviewProvider {
        static var previews: some View {
            CreateRestaurant(store: AdminDataStore())
        }
    }
}


