//
//  One_MenuApp.swift
//  One Menu
//
//  Created by Jordain on 09/08/2021.
//

import SwiftUI
import FirebaseDynamicLinks
@main
struct One_MenuApp: App {
    
    // This line makes it possible for you to still use the App delegate in your app incase you need it. Some frameworks and SDK's still rely on app delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) var scenePhase
    
    @AppStorage("showHyperLinkedRestaurant") var showHyperLinkedRestaurant : Bool = false
    
    @AppStorage("selectedColorScheme") private var selectedColorScheme : colorScheme = .system
    
    let appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(appState)
                .environment(\.colorScheme, selectedColorScheme == .system ? UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light : selectedColorScheme == .dark ? .dark : .light )
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: handleUserActivity)
                .onOpenURL { incomingURL in
                    print("Incoming URL parameter is: \(incomingURL)")
                    
                    // MARK: - Handle INCOMING url
                    let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL){ (dynamicLink,error) in
                        guard error == nil else {
                            fatalError("Error handling the incoming dynamic link.")
                            
                        }
                        if let dynamicLink = dynamicLink{
                            self.handleDynamicLink(dynamicLink)
                        }
                    }
                    if linkHandled {
                        print("DYNAMIC Link Handled")
                    } else {
                        print("Not dynamic link")
                    }
                    
                }
            
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
    
    func handleUserActivity(_ userActivity: NSUserActivity) {
        print(userActivity.webpageURL ?? "")
        
        // MARK: - Handle firebase DYNAMIC Link when scene connects
        if let incomingURL = userActivity.webpageURL{
            DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL){ (dynamicLink,error) in
                guard error == nil else {
                    print("ERROR NOT A DYNAMIC LINK")
                    return
                }
                if let dynamicLink = dynamicLink{
                    self.handleDynamicLink(dynamicLink)
                }
            }
        }
        
        // MARK: - Handle INCOMING url when scene connects
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let components = NSURLComponents(url: incomingURL,
                                               resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {return}
        
        if let restaurantID  = queryItems.first(where: {$0.name == "restaurantID"}) {
            UserDefaults.standard.setValue(restaurantID.value, forKey: "ScannedRestaurant")
            showHyperLinkedRestaurant = true
            
        }
        
    }
    
    func handleDynamicLink(_ dynamicLink : DynamicLink){
        guard let url = dynamicLink.url,let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            print("DynamicLink does not have url")
            return
        }
        
        if let restaurantID  = queryItems.first(where: {$0.name == "restaurantID"}) {
            UserDefaults.standard.setValue(restaurantID.value, forKey: "ScannedRestaurant")
            showHyperLinkedRestaurant = true
        }
        
    }
    
}
extension NSNotification {
    static let restIDReceived = NSNotification.Name.init("restIDReceived")
}
