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
                
                StrechyResusableImageHeader(image: Image(uiImage: #imageLiteral(resourceName: "curacao237")))
                    
                
                
                VStack {
                    HStack {
                        VStack(alignment:.leading,spacing: 5) {
                            HStack {
                                Text(restaurant.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                                LoveButton(isSelected: $restaurant.isEditing){
                                    
                                }
                                
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
                
                .background(Color.white)
                .cornerRadius(20)
                .offset(y: -40)
                
                
                
            })
            
            .onAppear{
                store.selectedRestaurant = restaurant
            }
        
            
        
        
        
        
        
        
    }
}

//struct RestaurantHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView{
//            RestaurantHomeView(restaurant: Restaurant.default)
//        } .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
struct StrechyResusableImageHeader : View{
    
    let screen = UIScreen.main.bounds
    
    @State var image : Image = Image("")
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    // 2
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
    var body : some View{
        
        
        ZStack(alignment:.center){
            
            GeometryReader { geometry in
                
                
                VStack {
                    
                    image
                        .resizable()
                        .background(Color.red)
                        .scaledToFill()
                        .overlay(TintOverlay().opacity(0.3))
                        .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                        .clipped()
                        .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                    
                    
                }
                //.background(Color.red)
                
                
                
                
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .frame(height:screen.height/4 , alignment: .center)
            .shadow(color: Color.primary.opacity(0.2), radius: 20, x: 0, y: 10)
            
            
        }
        
        
        
        
        
    }
    
}
