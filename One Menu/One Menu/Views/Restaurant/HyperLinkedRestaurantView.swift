//
//  HyperLinkedRestaurantView.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 03/02/2021.
//

import SwiftUI

struct HyperLinkedRestaurantView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var store : DataStore
    @State var hyperLinkedRestaurant : Restaurant?
    @AppStorage("ScannedRestaurant") var ScannedRestaurant : String = ""
    var body: some View {
        NavigationView{
            VStack{
                if hyperLinkedRestaurant != nil {
                    selectedRestaurant(store: store,selectedRestaurant: hyperLinkedRestaurant)
                        
                } else {
                    CustomProgressView().onAppear{
                        getHyperLinkedRestaurant()
                    }
                }
            }.navigationBarItems(trailing: closeButtonNavBarItem(){presentationMode.wrappedValue.dismiss()})
            .navigationBarTitle("\(hyperLinkedRestaurant?.name ?? "Restaurant")",displayMode: .inline)
        }
    }
    
    func getHyperLinkedRestaurant(){
        store.getRestaurant(id: ScannedRestaurant){ result in
            switch result {
            case let .success(restaurant):
                hyperLinkedRestaurant = restaurant
            case .failure:
                presentationMode.wrappedValue.dismiss()
            }
            
        }
    }
}


