//
//  RestaurantHomeView.swift
//  RestaurantHomeView
//
//  Created by Jordain on 23/08/2021.
//

import SwiftUI
import Foundation
struct RestaurantHomeView: View {
    @State var restaurant : Restaurant
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var store : DataStore
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false, content: {
     //       StrechyFirebaseStorageImageHeader(firestoreLocationUrlString: restaurant.imageReference, store: store)
            VStack {
                HStack {
                    VStack(alignment:.leading,spacing: 5) {
                        
                        HStack {
                            Text(restaurant.name)
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                            LoveButton(isSelected: $restaurant.isEditing){}
                        }
                        
                        Text(restaurant.description)
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment:.leading,spacing: 10) {
                            Label("Location", systemImage: "map")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(restaurant.address).font(.subheadline).foregroundColor(.secondary)
                        }.padding(.top)
                        
                        
                        VStack(alignment:.leading,spacing: 10) {
                            Label("Hours", systemImage: "clock")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            ForEach(restaurant.hours, id: \.self) { hours in
                                
                                Text(hours).font(.subheadline).foregroundColor(.secondary)
                            }
                        }.padding(.top)
                        
                        VStack(alignment:.leading,spacing: 10) {
                            Label {
                                Text("Menu")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            } icon: {
                                Image("forks")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            HStack {
                                SquareButton(name: "Meals", image: "icConsumables"){}
                                SquareButton(name: "Beverages", image: "icons8-tea-50"){}
                            }
                        }.padding(.top)
                        
                        VStack(alignment:.leading,spacing: 10) {
                            Label("Links", systemImage: "link")
                                .font(.headline)
                                .foregroundColor(.primary)
                            HStack {
                                NavigationDrawerButton(isSelected: .constant(true), name: "Instagram", color: Color.black){
                                    
                                }
                                NavigationDrawerButton(isSelected: .constant(true), name: "Website", color: Color.black){
                                    
                                }
                            }
                        }.padding(.top)
                        
                    }
                    Spacer()
                }.padding()
            }
            .background(Color("whiteToDarkGrouped"))
            .cornerRadius(20)
            .offset(y: -40)
            })
            .overlay(
                CircularButton(systemName: "arrow.triangle.2.circlepath"){
                    presentationMode.wrappedValue.dismiss()
                }
                    .offset(x: 20, y: 10)
                
                , alignment: .topLeading)
            .onAppear{
                store.selectedRestaurant = restaurant
            }
    }
}

struct RestaurantHomeView_Previews: PreviewProvider {
    static var previews: some View {
        
        RestaurantHomeView(restaurant: Restaurant.default, store: DataStore())
            .preferredColorScheme(.light)
        
        
    }
}

