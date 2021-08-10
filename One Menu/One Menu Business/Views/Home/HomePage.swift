//
//  HomePage.swift
//  Paradise Scrap
//
//  Created by Jordain Gijsbertha on 19/11/2020.
//

import SwiftUI


let items: [tabBarItem] = [
    tabBarItem(icon: "list.dash", title: "Home", color: Color(#colorLiteral(red: 1, green: 0.3830084205, blue: 0.3119142354, alpha: 1))),
    tabBarItem(icon: "ellipsis.circle", title: "Settings", color: Color(#colorLiteral(red: 1, green: 0.3830084205, blue: 0.3119142354, alpha: 1)))
//    ,
//    tabBarItem(icon: "magnifyingglass", title: "Search", color: .orange),
//    tabBarItem(icon: "person.fill", title: "Profile", color: .blue)
]


struct HomePage: View {
    //@AppStorage("isStarterUser") var isStarterUser: Bool = false
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
    @State private var currentTab = 1
    @AppStorage("isAdmin") var isAdmin: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @StateObject var store : AdminDataStore = AdminDataStore()
    

    
    @State private var selectedIndex: Int = 0
    
    var selectedItem: tabBarItem {
        items[selectedIndex]
    }
   
    var body: some View {
        if isLoggedIn {
            home.smoothTransition().onAppear{
                if UIApplication.isFirstLaunch() == true {
                  //  LocalNotificationService.shared.turnOnNotifications()
                }
            }
        } else {
            LoginView().smoothTransition()
        }
    }
    
    var home: some View {
        
        RestaurantView(store: store)
//            RestaurantView(store: store)
//
//                .tabItem {
//                    Image(systemName: "house.fill")
//                    Text("Home")
//                }.tag(1).onAppear{
//                    print("Notifications")
//                }
//
//            MoreView(store: store)
//                .tabItem {
//                    Image(systemName: "ellipsis.circle")
//                    Text("Settings")
//                }.tag(2)
            
            
      
        
    }
}

