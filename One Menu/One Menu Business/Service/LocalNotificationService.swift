//
//  LocalNotificationService.swift
//  Paradise Scrap
//  https://medium.com/quick-code/local-notifications-with-swift-4-b32e7ad93c2
// https://www.appsdeveloperblog.com/add-days-months-years-to-current-date-in-swift/#:~:text=Add%20Days%20to%20Current%20Date,the%20DateComponents()%20Swift%20structs.&text=print(futureDate!),%3D%201%20let%20futureDate%20%3D%20Calendar.
//  Created by Jordain Gijsbertha on 05/06/2020.
//  Copyright © 2020 Jordain Gijsbertha. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
enum notificationState {
    case isON
    case isOff
}
class LocalNotificationService : NSObject, UNUserNotificationCenterDelegate {

    func start(){
       self.notificationCenter.removeAllDeliveredNotifications()
        
    }
    static let shared = LocalNotificationService()

      let notificationCenter = UNUserNotificationCenter.current()
    
    var pendingNotifications: [UNNotificationRequest] = []
    
    var state : notificationState = .isON
    
    // MARK: - Local Notifications
    
//    func scheduleNotification(notificationTitle: String, notificationSubTitle: String, booking : Booking , day : Int , minutes : Int) {
//        
//        let content = UNMutableNotificationContent() // Содержимое уведомления
//        let userActions = "User Actions"
//        
//        content.title = notificationTitle
//        content.body = notificationSubTitle
//        content.sound = UNNotificationSound.default
//        content.badge = 1
//        content.categoryIdentifier = userActions
//        
//        let bookingDate = booking.date.toDate(dateformat: .date)
//        
//        var dateComponent = DateComponents()
//        dateComponent.day = day
//        dateComponent.minute = minutes
//        
//        let reminderDate = Calendar.current.date(byAdding: dateComponent, to: bookingDate)
//        
//        let calendar = Calendar.current
//    
//        if let reminderDate = reminderDate {
//        let triggerDate = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: reminderDate)
//        
//        print("the trigger date and time is : \(triggerDate)")
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
////        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let identifier = booking.bookingID
//        print("Trigger ID \(identifier)")
//        
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        
//        if state == .isON {
//            pendingNotifications.append(request)
//            notificationCenter.add(request) { (error) in
//                     if let error = error {
//                         print("Error \(error.localizedDescription)")
//                     }
//                 }
//        } else{
//            pendingNotifications.append(request)
//        }
//        }
//
//    }
//    
//    func setBadgeCountToNil(){
//        UIApplication.shared.applicationIconBadgeNumber = 0
//    }
//    
//    func deleteNotification(notificationID : String){
//      
//            notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationID])
//                   pendingNotifications = pendingNotifications.filter { $0.identifier != notificationID}
//    
//
//    }
//                      
//                  
//    func getPendingNotifications(completionHandler: @escaping (Result<[UNNotificationRequest], CoreError>) -> Void) {
//        pendingNotifications.removeAll()
//        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
//            for request in requests {
//                print("Pending Notification: \(request)")
//                self.pendingNotifications.append(request)
//                
//            }
//            print("Pending Notifications: \(self.pendingNotifications.count)")
//            completionHandler(.success(self.pendingNotifications))
//        })
//    }
//    
//    func turnOffNotification(){
//        //remove all pending from the array
//        pendingNotifications.removeAll()
//         self.state = .isOff
//        //save all notifications in the array
//        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
//                 for request in requests {
//                     print("pendingnotification \(request)")
//                     self.pendingNotifications.append(request)
//                     
//                 }
//            self.notificationCenter.removeAllPendingNotificationRequests() // turn off notifications
//            self.notificationCenter.removeAllDeliveredNotifications() // turn off notifications
//             })
//      
//    }
//    
//    func turnOnNotifications(){
//        self.state = .isON
//        //add all saved notifications & turn on notifications
//        for notification in pendingNotifications{
//            notificationCenter.add(notification, withCompletionHandler: nil)
//        }
//  
//    }
}

