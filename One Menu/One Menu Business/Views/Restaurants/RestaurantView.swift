//
//  RestaurantView.swift
//  One_Menu
//
//  Created by Jordain Gijsbertha on 04/08/2020.
//

import SwiftUI

struct RestaurantView: View {
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
    @EnvironmentObject var appState: AppState
    @ObservedObject var store: AdminDataStore
    @Environment(\.presentationMode) var presentationMode
    @State var isLoading : Bool = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var  viewState : viewState = .isLoading
  
    func getRestaurants(){
        viewState = .isLoading
        store.getRestaurants{ result in
            switch result {
            case .success:
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
                VStack(spacing:10){
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .renderingMode(.template)
                        .font(.largeTitle)
                        .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                    Text(LocalizedStringKey("tryagain"))
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                }
                .smoothTransition()
                .padding(.top)
                .onTapGesture{
                    getRestaurants()
                    
                }
            default:
                loading
            }
        }
    }
    
    
    var loading : some View{
 
                CustomProgressView()
  
    }
    
    var content: some View {
        NavigationView{
            VStack{
           
                    List{
                        ForEach(store.Restaurants, id: \.self ) { item in
                            NavigationLink(destination: selectedRestaurant(selectedRestaurant: item, store: store)) {
                                if store.Restaurants.count==1{
                                    RestaurantRow(restaurant: item)
                                } else{
                                    RestaurantRow(restaurant: item)
                                }
                            }
                            
                        }
                        
                        VStack{
                        if store.Restaurants.count == 0 {
                          
                            HStack{
                                Spacer()
                                Text("Get started by adding your restaurant.").padding().multilineTextAlignment(.center).foregroundColor(.secondary)
                                Spacer()
                            }
                            
                        }
                        
                        if store.Restaurants.count == 1 && !isPremiumUser {
                            HStack{
                                Spacer()
                                Text("If you would like to add more restaurant's, upgrade to one menu premium.").padding().multilineTextAlignment(.center).foregroundColor(.secondary)
                                Spacer()
                            }
                        }
                        if store.Restaurants.count == 3 && isPremiumUser {
                            HStack{
                                Spacer()
                                Text("You have reached the maximum amount of restaurants you can add.").padding().multilineTextAlignment(.center).foregroundColor(.secondary)
                                Spacer()
                            }
                        }
                            if store.Restaurants.count == 0 || isPremiumUser {
                                
                                NavigationLink(destination: CreateRestaurant(store: store)){
                                    HStack{
                                        Spacer()
                                        Image(systemName: "plus.rectangle.fill")
                                            .renderingMode(.template)
                                            .font(.largeTitle )
                                            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.382914573, blue: 0.3166760206, alpha: 1)))
                                        Spacer()
                                    }
                                   
                                }.padding(.bottom).padding(.top,10)
                            
                            }
                        }
                            
                    }
                    .listStyle(InsetGroupedListStyle())
                   
            }
            .navigationTitle("Restaurants")
            .navigationBarItems(leading: NavigationLink(
                                    destination: SettingsView(store: store),
                                    label: {
                                        Image(systemName: "gear")
                                            .renderingMode(.template)
                                            .font(.title3)
                                    }),trailing: Button(action: {
                                        viewState = .isLoading
            }, label: {
                Text("Refresh").foregroundColor(Color(#colorLiteral(red: 1, green: 0.382914573, blue: 0.3166760206, alpha: 1))).fontWeight(.semibold)
            }).disabled(store.Restaurants.count == 3))
        }
        
    }
 
    
}
var isiOS13 = false

struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
