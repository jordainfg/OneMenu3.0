//
//  NotificationsView.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 25/01/2021.
//

import SwiftUI

struct NotificationsView: View {
    @State var showRequestView : Bool = false
    @State var showSubscribeView : Bool = false
    @ObservedObject var store: AdminDataStore
    @State var showFailedAlert = false
   // @AppStorage("isStarterUser") var isStarterUser: Bool = false
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
    var body: some View {
        List{
            
            Section{
            VStack {
                Image(uiImage: #imageLiteral(resourceName: "notificationsViewExample"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth:.infinity)
                   
            }.listRowInsets(EdgeInsets())
            .onAppear{
                store.getNewsRequest(forRestaurantID: store.restaurantID) { result in
                    
                }
            }
            }
            Section{
                descriptionText(text: "Every monday we send a notification to your customers with any news you would like to share with them.").padding(.vertical)
            }
            Section{
                if !isPremiumUser{
                    Text("In order to send notifications to your customers you must have a one menu premium subscription.").font(.caption).foregroundColor(.secondary).padding(10)
                }
                if !isPremiumUser{
                    Button(action: {
                        // your action here
                        showSubscribeView = true
                    }) {
                        
                        HStack {
                            Spacer()
                            Text("Subscribe to One Menu Premium").font(.body).fontWeight(.bold).padding(10)
                            Spacer()
                        }
                    }.sheet(isPresented: $showSubscribeView, content: {
                        SubscriptionView()
                    })
                }
                if isPremiumUser{
                    Button(action: {
                        // your action here
                        showRequestView = true
                    }) {
                        
                        HStack {
                            Spacer()
                            Text("Send request").font(.body).fontWeight(.bold)
                            Spacer()
                        }
                    }.sheet(isPresented: $showRequestView, content: {
                        RequestView(store: store)
                    })
                }
                
            }
            
            Section(header: Text("This weeks notification requests"),footer: Text("All requests are reviewed by us before they are sent out to your customers. You can delete a request at any time by swiping left on the request.")){
                ForEach(store.newsRequests,  id: \.self) { news in
                    HStack {
                        if news.isPending{
                            Image(systemName: "clock.fill")
                                .renderingMode(.template)
                                .font(.title)
                                .foregroundColor(.yellow)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .renderingMode(.template)
                                .font(.title)
                                .foregroundColor(.green)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(news.notificationTitle).font(.subheadline)
                                .fontWeight(.semibold)
                            Text(news.notificationSubTitle).font(.subheadline)
                                .fontWeight(.regular).foregroundColor(.secondary)
                        }
                        
                        .padding()
                    }
                    
                }.onDelete(perform: deleteRequestFromFirestore)
            }.alert(isPresented: $showFailedAlert) {
                Alert(title: Text("Whoops"), message:
                        Text("We couldn't delete this request, please try again later or contact us."), dismissButton:
                            .default(Text("OK")))
            }
        }.listStyle(InsetGroupedListStyle())
    }
    private func deleteRequestFromFirestore(at offsets: IndexSet) {
        
        let requestTodelete = offsets.map { store.newsRequests[$0] }
        
            store.deleteNewsRequest(requestNotificationID: requestTodelete[0].notificationID){ result in
                switch result {
                case .success:
                    store.newsRequests.remove(atOffsets: offsets)
                    
                case .failure:
                    showFailedAlert = true
                }
            }
            
        
    }
}
