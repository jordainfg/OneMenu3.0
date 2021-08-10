//
//  One_Menu_BusinessApp.swift
//  Shared
//
//  Created by Jordain on 09/08/2021.
//

import SwiftUI

@main
struct One_Menu_BusinessApp: App {
    
    var subscriptionManager : SubscriptionManager = SubscriptionManager()
    
    // This line makes it possible for you to still use the App delegate in your app incase you need it. Some frameworks and SDK's still rely on app delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            HomePage().environmentObject(subscriptionManager)
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .background:
                print("App State : Background")
            case .inactive:
                print("App State : Inactive")
            case .active:
                
                print("App State : Active")
            @unknown default:
                print("App State : Unknown")
            }
        }

    }
}
