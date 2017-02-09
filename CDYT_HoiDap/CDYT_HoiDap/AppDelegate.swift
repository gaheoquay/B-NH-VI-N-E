//
//  AppDelegate.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    registerNotification(application: application)
    SBDMain.initWithApplicationId(SENDBIRD_APPKEY)
    //    SBDMain.setLogLevel(SBDLogLevel.debug)
    initSendBird()
    
    // Configure tracker from GoogleService-Info.plist.
    var configureError: NSError?
    GGLContext.sharedInstance().configureWithError(&configureError)
    assert(configureError == nil, "Error configuring Google services: \(configureError)")
    
    // Optional: configure GAI options.
    guard let gai = GAI.sharedInstance() else {
        assert(false, "Google Analytics not configured correctly")
    }
    gai.trackUncaughtExceptions = true  // report uncaught exceptions
    gai.logger.logLevel = GAILogLevel.verbose  // remove before app release
    
    return true
  }
  func initSendBird(){
    let realm = try! Realm()
    let userEntity = realm.objects(UserEntity.self).first
    
    if userEntity != nil {
      SBDMain.connect(withUserId: userEntity!.id, completionHandler: { (user, error) in
        if error != nil {
          
          let vc = UIAlertController(title: "Lỗi", message: error?.domain, preferredStyle: UIAlertControllerStyle.alert)
          let closeAction = UIAlertAction(title: "Đóng", style: UIAlertActionStyle.cancel, handler: nil)
          vc.addAction(closeAction)
          DispatchQueue.main.async {
//            self.present(vc, animated: true, completion: nil)
          }
          
          return
        }
        
        if SBDMain.getPendingPushToken() != nil {
          SBDMain.registerDevicePushToken(SBDMain.getPendingPushToken()!, unique: true, completionHandler: { (status, error) in
            if error == nil {
              if status == SBDPushTokenRegistrationStatus.pending {
                print("Push registeration is pending.")
              }
              else {
                print("APNS Token is registered.")
              }
            }
            else {
              print("APNS registration failed.")
            }
          })
        }
        
        SBDMain.updateCurrentUserInfo(withNickname: userEntity!.nickname, profileUrl: userEntity!.avatarUrl, completionHandler: { (error) in
          if error != nil {
            let vc = UIAlertController(title: "Lỗi", message: error?.domain, preferredStyle: UIAlertControllerStyle.alert)
            let closeAction = UIAlertAction(title: "Đóng", style: UIAlertActionStyle.cancel, handler: nil)
            vc.addAction(closeAction)
//            DispatchQueue.main.async {
//              self.present(vc, animated: true, completion: nil)
//            }
            
            SBDMain.disconnect(completionHandler: {
              
            })
            
            return
          }
        })
      })
    }
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func registerNotification(application: UIApplication){
    if #available(iOS 10.0, *) {
      let center = UNUserNotificationCenter.current()
      center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
        // Enable or disable features based on authorization.
        if granted == true
        {
          print("Allow")
        }
        else
        {
          print("Don't Allow")
        }
      }
    } else {
      let version = UIDevice.current.systemVersion
      let ver:Double = (version as NSString).doubleValue
      if ver >= 8 && ver < 9 {
        if UIApplication.shared.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))){
          let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          UIApplication.shared.registerUserNotificationSettings(settings)
        }
      }
      else if ver >= 9 {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
      }
    }
    application.applicationIconBadgeNumber = 0
    application.registerForRemoteNotifications()
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    print(deviceTokenString)
    UserDefaults.standard.setValue(deviceTokenString, forKey: NOTIFICATION_TOKEN)
    SBDMain.registerDevicePushToken(deviceToken, unique: true) { (status, error) in
      if error == nil {
        if status == SBDPushTokenRegistrationStatus.pending {
          
        }
        else {
          
        }
      }
      else {
        
      }
    }
  }
  
}

