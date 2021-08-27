//
//  Home.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 02/02/2021.
//

import SwiftUI

struct Home: View {
    @StateObject var store = DataStore()
    @AppStorage("userSelectedLanguage") var language: String = "en"
    
    @AppStorage("showHyperLinkedRestaurant") var showHyperLinkedRestaurant : Bool = false
    var body: some View {
        RestaurantListView( store: store).environment(\.locale, Locale(identifier: language))
        .accentColor(Color.primaryOne)
        .fullScreenCover(isPresented: $showHyperLinkedRestaurant){
            
            HyperLinkedRestaurantView(store:store)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(store: DataStore()).environment(\.colorScheme, .light)
    }
}
