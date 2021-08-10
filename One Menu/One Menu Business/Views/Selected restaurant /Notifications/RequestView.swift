//
//  RequestView.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 25/01/2021.
//

import SwiftUI

struct RequestView: View {
@State private var showingSuccesAlert = false
@State private var showingFailedAlert = false
@Environment(\.presentationMode) var presentationMode
// Section 1
@State var notificationTitle: String = ""
@State var notificationSubTitle: String = ""
@State var forRestaurant: String = ""
@State var isPending: String = ""
@State var phoneNumber: String = ""
// section2
@State var quantity: Int = 1
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
    @State private var showingSubscriptionView = false
@ObservedObject var store : AdminDataStore
var disableForm : Bool {
    notificationTitle.isEmpty
}

func createRequest(){
    if let restaurant = store.selectedRestaurant {
            let newNewsRequestDict:[String:Any] = [
                                                "notificationID" : "",
                                                "notificationTitle" : notificationTitle,
                                               "notificationSubTitle" : notificationSubTitle,
                                               "forRestaurant": restaurant.name ,
                                               "forRestaurantID": restaurant.restaurantID ,
                                               "isPending" : true
                                               ]
    if let newsRequest = NewsRequest(dictionary: newNewsRequestDict){

        
        
        store.createNewsRequestRequest(request : newsRequest){result in

            switch result {
            case .success:
                store.newsRequests.append(newsRequest)
                showingSuccesAlert = true
                presentationMode.wrappedValue.dismiss()

            case .failure(_):


                showingFailedAlert = true
                presentationMode.wrappedValue.dismiss()

            }
        }
    }
    }
}
var body: some View {
    NavigationView {
        Form {
            Section(header: Text("Notification builder"), footer:Text(disableForm ? "Please fill" : "").foregroundColor(.red)) {
                TextField("Title", text: $notificationTitle)
                TextField("Sub Title", text: $notificationSubTitle)
              
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
                    
                    if isPremiumUser{
                    createRequest()
                    } else {
                        showingSubscriptionView = true
                    }
                    
                    
                    
                }, label: {
                    Text("Send").fontWeight(.semibold)
            })
                .sheet(isPresented: $showingSubscriptionView){
                                                            SubscriptionView()
                                                        }
            }.disabled(disableForm)
            
        }.navigationBarTitle("Create", displayMode: .inline)
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

struct RequestView_Previews: PreviewProvider {
    static var previews: some View {
        RequestView( store: AdminDataStore())
    }
}
