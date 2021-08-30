//
//  RestaurantView.swift
//  One_Menu
//
//  Created by Jordain Gijsbertha on 04/08/2020.
//

import SwiftUI

struct RestaurantListView: View {
    
    // SearchBar
    @State var isSearching = false
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    @EnvironmentObject var appState: AppState
    
    @ObservedObject var store : DataStore 
    @Environment(\.presentationMode) var presentationMode
    @State var isLoading : Bool = false
    
    
    @State var showLandingPageModal = false
    @State var showScannerView = false
    @State var showScannedRestaurant = false
    @State var scannedRestaurant : Restaurant?
    @State var selectedRestaurant : Restaurant?
    @State var  viewState : viewState = .isLoading
    
    @AppStorage("ScannedRestaurant") var ScannedRestaurant : String = ""
    
    
    func getRestaurants(){
        viewState = .isLoading
        
        if UIApplication.isFirstLaunch() == true {
            showLandingPageModal = true
            
        }
        store.getRestaurants{ result in
            switch result {
            case .success:
                
                print("Success retrieving all restaurants")
                
                viewState = .dataAvailable
                
            case .failure:
                viewState = .noDataAvailable
                print("Fail")
                
            }
        }
    }
    
    var body: some View {
        
        ZStack{
            switch viewState{
            
            case .isLoading:
                loading.onAppear{
                    getRestaurants()
                }
                .smoothTransition()
            case .dataAvailable:
                
                content.smoothTransition()
                
            case .noDataAvailable:
                Button(action: {
                    getRestaurants()
                }) {
                    VStack(spacing:10){
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .renderingMode(.template)
                            .font(.largeTitle)
                            .foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                        
                        Text(LocalizedStringKey("tryagain"))
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)
                            .foregroundColor(.secondary)
                    }
                }
                .smoothTransition()
                .padding(.top)
                .buttonStyle(SquishableButtonStyle(fadeOnPress: true))
            default:
                loading
            }
        }
    }
    
    
    var content: some View {
        NavigationView {
            VStack{
                List{
                    Section {
                        ForEach(store.Restaurants.filter { $0.name.lowercased().hasSubstring(searchText.lowercased()) || searchText.isEmpty }) { restaurant in
                            RestaurantRow(restaurant: restaurant)
                                .onTapGesture {
                                    selectedRestaurant = restaurant
                                }
                                .fullScreenCover(item: $selectedRestaurant){ restaurant in
                                    TabViewForRestaurant(selectedRestaurant: restaurant, store: store)
                                }
//                            NavigationLink(destination: TabViewForRestaurant(selectedRestaurant: item, store: store)) {
//                                if store.Restaurants.count==1{
//                                    RestaurantRow(item: item)
//                                } else{
//                                    RestaurantRow(item: item)
//                                }
//                            }
                            
                        }
                        
                    }.textCase(nil)
                    
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarSearch($searchText,cancelClicked: {searchText = "" ; isSearching = false }, searchDidBeginEditing:{isSearching = true}, didEndEditing:{ searchText = ""
                } )
                .sheet(isPresented: $showLandingPageModal){
                    LandingPage(showLandingPageModal: $showLandingPageModal)
                }
                NavigationLink(destination: TabViewForRestaurant(selectedRestaurant: scannedRestaurant, store: store), isActive: $showScannedRestaurant) {
                }
            }
            
            .navigationTitle("One Menu")
            .navigationBarItems(leading:  Button(action: {
                viewState = .isLoading
            }) {
                Text("Refresh").foregroundColor(Color.secondaryTwo).fontWeight(.semibold)
            }
            
            .fullScreenCover(isPresented: $showScannerView,onDismiss: {  if !ScannedRestaurant.isEmpty {
                let allRestaurants = store.Restaurants
                let scannedRestaurant = allRestaurants.first(where:{$0.restaurantID == ScannedRestaurant})
                
                self.scannedRestaurant = scannedRestaurant
                self.showScannedRestaurant = true
            }}){
                ScanRestaurantView(store: store)
            },trailing:    Button(action: {
                // your action here
                showScannerView = true
                
            }) {
                
                Image(systemName: "qrcode.viewfinder")
                    .renderingMode(.template)
                    .font(.largeTitle)
                    .foregroundColor(Color.secondaryOne)
            })
            
            
            
        }
        
        
    }
    
    var loading : some View{
        VStack{
            CustomProgressView(showText: true)
            
        }.frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }
    
    
}

extension View {
    func smoothTransition() -> some View{
        self.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.6)))
    }
}
