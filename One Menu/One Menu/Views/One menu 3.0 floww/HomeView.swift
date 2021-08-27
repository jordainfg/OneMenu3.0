////
////  HomeView.swift
////  HomeView
////
////  Created by Jordain on 23/08/2021.
////
//
//import SwiftUI
//
//struct HomeView: View {
//    @State var selectedRestaurant : Restaurant?
//    @ObservedObject var store : DataStore
//    var body: some View {
//        
//        NavigationView {
//            List{
//                
//                ForEach(Restaurant.allRestaurants) { restaurant in
//                    
//    //                HStack {
//    //                    Text(restaurant.name)
//    //                    Spacer()
//    //                }
//    //                .background(Color.white)
//    //                .onTapGesture {
//    //                    selectedRestaurant = restaurant
//    //                }
//    //                .fullScreenCover(item: $selectedRestaurant){ restaurant in
//    //                    TabViewForRestaurant(selectedRestaurant: restaurant)
//    //                }
//                    NavigationLink(destination:TabViewForRestaurant(selectedRestaurant: restaurant) , label: { HStack {
//                        Text(restaurant.name)
//                        Spacer()
//                    }})
//                }
//            }.navigationTitle("Restaurants")
//                .navigationBarTitleDisplayMode(.inline)
//        }
//        
//    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
