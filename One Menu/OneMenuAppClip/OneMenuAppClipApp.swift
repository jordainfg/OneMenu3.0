//
//  OneMenuAppClipApp.swift
//  OneMenuAppClip
//https://betterprogramming.pub/how-to-build-an-app-clip-on-ios-14-a5045fd68eb4
//  Created by Jordain on 09/08/2021.
//

import SwiftUI
import Firebase

@main
struct OneMenuAppClipApp: App {
    
    
    // This line makes it possible for you to still use the App delegate in your app incase you need it. Some frameworks and SDK's still rely on app delegate
   @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) var scenePhase
    
    @AppStorage("restaurantID") var restaurantID: String = ""
    
  let appClipState = AppClipsState()
    
    var body: some Scene {
        WindowGroup {
            RootForScannedRestaurant( isRoot : true).environmentObject(appClipState).onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: handleUserActivity)
               
        }.onChange(of: scenePhase) { (newScenePhase) in
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
    
    func handleUserActivity(_ userActivity: NSUserActivity) {
        print(userActivity.webpageURL ?? "")
        // Get URL components from the incoming user activity
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {return}
        
        // Direct to the linked content in your app clip.
        if let restaurantID  = queryItems.first(where: {$0.name == "restaurantID"}) {
           
            self.restaurantID = restaurantID.value ?? ""
            NotificationCenter.default.post(name: NSNotification.restIDReceived,object: nil, userInfo: nil)
        }
        
    }

}
