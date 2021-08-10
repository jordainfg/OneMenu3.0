//
//  AppDelegate.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 17/11/2020.
//

import UIKit
// import FBSDKCoreKit
import Firebase
import Purchases
import FirebaseMessaging
import Stripe

class AppDelegate: UIResponder, UIApplicationDelegate {

    let gcmMessageIDKey = "gcm.message_id"

    let notifications = LocalNotificationService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseService.shared.configure()
        FirebaseService.shared.checkAuthenticationState()
        LocalNotificationService.shared.start()
        
        StripeAPI.defaultPublishableKey = "pk_test_51JFJGQAnNBKwLebeKUux8ZameDrg2FmfsSBW86G0MaWKTaCuNs5K8U6JxTBMHbCAHBbvebdGd5UcSDtG40JeNcoq00rtIfTaT6"
        
//        // FACEBOOKLOGIN
//        ApplicationDelegate.shared.application(
//            application,
//            didFinishLaunchingWithOptions: launchOptions
//        )
//        // END FACEBOOK LOGIN
//
        
         // * Begin NOTIFICATION SERVICE
         Messaging.messaging().delegate = self
         if #available(iOS 10.0, *) {
             // For iOS 10 display notification (sent via APNS)
             // UNUserNotificationCenter.current().delegate = self

             let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
             UNUserNotificationCenter.current().requestAuthorization(
                 options: authOptions,
                 completionHandler: {_, _ in })
         } else {
             let settings: UIUserNotificationSettings =
                 UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
             application.registerUserNotificationSettings(settings)
         }

         application.registerForRemoteNotifications()
         
        // End NOTIFICATION SERVICE
        notifications.notificationCenter.delegate = notifications
        
        Messaging.messaging().subscribe(toTopic: "Business") { error in
          print("Subscribed to Business topic")
        }
        return true
    }
//
//    // FACEBOOKLOGIN
//    func application(_ app: UIApplication,open url: URL,options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//
//        ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
//
//    }
//    // END FACEBOOK LOGIN


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
 

}


extension AppDelegate{
    // MARK: -  Notification Service
    /*
     1. Implement the below in did finish launching with options
     
                 Messaging.messaging().delegate = self
                 if #available(iOS 10.0, *) {
                     // For iOS 10 display notification (sent via APNS)
                     // UNUserNotificationCenter.current().delegate = self
                     
                     let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                     UNUserNotificationCenter.current().requestAuthorization(
                         options: authOptions,
                         completionHandler: {_, _ in })
                 } else {
                     let settings: UIUserNotificationSettings =
                         UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                     application.registerUserNotificationSettings(settings)
                 }
     
                 application.registerForRemoteNotifications()
    
    2.  UPLOAD TOUR APNS AUTHENTICATION KEY in Firebase console
    3.  DON'T FORGET TO ADD A APP ID
    4.  In XCode go to the project folder > then select targets > then Siging and capabilities > Add capabilty > add push notifications
    // DONT FORGET TO SUBSCRIBE TO A TOPIC
 
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
}
// MARK: -  Monitor token refresh

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
}

extension AppDelegate: PurchasesDelegate {
    func purchases(_ purchases: Purchases, didReceiveUpdated purchaserInfo: Purchases.PurchaserInfo) {
        // handle any changes to purchaserInfo
    }
}
