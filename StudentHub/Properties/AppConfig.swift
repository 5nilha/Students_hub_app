//
//  AppConfig.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 10/1/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import Foundation
import SCLAlertView
import Firebase
import UserNotifications

class AppConfig {
    
    static func logout(completion: @escaping (Error?) -> ()) {
        do {
            try Auth.auth().signOut()
//            self.remove_user_data_from_keychain()
        }
        catch {
            completion(error)
            return
        }
        completion(nil)
    }
    
    func ErrorAlert(title: String, message: String) {
        let appearance = SCLAlertView.SCLAppearance( showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("OK") {
            alertView.dismiss(animated: true, completion: nil)
        }
        
        alertView.showError(title, subTitle: message)
    }
    
    //MARK: --------------Notification -------------------------
    static func request_Notification_authorization() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Allowed Notification")
            } else {
                print("The notification was denied")
            }
        }
    }
    
    
    static func setNotification(title: String, message: String, identifier: String) {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { (settings) in
                if (settings.authorizationStatus == .authorized) {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    content.sound = UNNotificationSound.default
    //                content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
                else {
                    AppConfig.request_Notification_authorization()
                }
            }
        }
    
    
    
}
