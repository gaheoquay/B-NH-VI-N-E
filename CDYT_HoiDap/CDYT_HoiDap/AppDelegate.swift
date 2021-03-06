//
//  AppDelegate.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit
import UserNotifications
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerNotification(application: application)
        if (launchOptions != nil) { //launchOptions is not nil
            if (launchOptions?[UIApplicationLaunchOptionsKey.localNotification]) != nil {
                self.perform(#selector(self.callToSchedule), with: nil, afterDelay: 2)
            }else{
                let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as! NSDictionary
                if let sendBird = userInfo["sendbird"] as? NSDictionary {
                    let sender = sendBird["sender"] as! NSDictionary
                    self.perform(#selector(self.callGotoChat(notificationDic:)), with: sender, afterDelay: 2)
                }else{
                    if let apsInfo = userInfo["aps"] as? NSDictionary{
                        let data = apsInfo["data"] as! NSDictionary
                        self.perform(#selector(self.callToGoDetail(notificationDic:)), with: data, afterDelay: 2)
                    }
                }
            }
        }
        application.scheduledLocalNotifications?.removeAll()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        Until.getSchedule()
        SBDMain.initWithApplicationId(SENDBIRD_APPKEY)
        initSendBird()
        requestCate()
        requestListDoctor()
        Until.getBagValue()
//        if #available(iOS 10.0, *) {
//            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
//                Until.getBagValue()
//            }
//        } else {
//            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.reloadBadge), userInfo: nil, repeats: true)
//        }
        checkAppVersion()
        // Configure tracker from GoogleService-Info.plist.
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self

        // Optional: configure GAI options.
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return true
        }
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        return true
    }
    
    func callGotoChat(notificationDic:NSDictionary){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:GO_TO_CHAT), object: notificationDic)
    }
    func callToGoDetail(notificationDic:NSDictionary){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:GO_TO_DETAIL_WHEN_TAP_NOTIFICATION), object: notificationDic)
    }
    func callToSchedule(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:GO_TO_SCHEDULE), object: nil)
    }
    func reloadBadge(){
        Until.getBagValue()
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
                        SBDMain.disconnect(completionHandler: {
                            
                        })
                        return
                    }
                })
            })
        }
    }
    
    func checkAppVersion() {
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let authJson = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = authJson.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
            Alamofire.request(GET_APP_VERSION, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let json = result as! NSDictionary
                            guard let code = json["Code"] as? Int, code == 0 else { return }
                            if let data = json["Data"] as? NSDictionary {
                                let version = data["Version"] as? Double
                                let forceUpdate = data["ForceUpdate"] as? Bool
                                if Double(versionNumber) ?? 0 < version ?? 0 {
                                    Until.haveNewVersion(forceUpdate: forceUpdate ?? false)
                                }
                            }
                        }
                    }
                }
            })
        } catch let error as NSError {
            print(error)
        }
    }
    
    func requestCate() {
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            Alamofire.request(GET_CATE, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let json = result as! [NSDictionary]
                            listCate.removeAll()
                            for element in json {
                                let entity = DepartmentEntity.init(dictionary: element)
                                listCate.append(entity)
                            }
                        }
                    }
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func requestListDoctor(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            Alamofire.request(GET_LIST_DOCTOR, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! [NSDictionary]
                            
                            for item in jsonData {
                                let entity = ListDoctorEntity.init(dictionary: item)
                                listAllDoctor.append(entity)
                            }
                            
                        }
                    }
                }
            }
            
        } catch let error as NSError {
            print(error)
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
        FBSDKAppEvents.activateApp()
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
                    // Registration is pending.
                    print("Registration is pending")
                }
                else {
                    // Registration succeeded.
                    print("Registration succeeded")
                    
                }
            }
            else {
                // Registration failed.
                print("Registration failed")
                
            }
        }
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        let state = application.applicationState
        if state == UIApplicationState.active {
            
        }else{
            callToSchedule()
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        let state = application.applicationState
        if state == UIApplicationState.active {
            Until.getBagValue()
            if (userInfo["sendbird"] as? NSDictionary) != nil {
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:SHOW_NOTIFICAION), object: userInfo)
            }
        }else{
            if let sendBird = userInfo["sendbird"] as? NSDictionary {
                let sender = sendBird["sender"] as! NSDictionary
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:GO_TO_CHAT), object: sender)
            }else{
                if let apsInfo = userInfo["aps"] as? NSDictionary{
                    let data = apsInfo["data"] as! NSDictionary
                    callToGoDetail(notificationDic: data)
                }
            }
        }
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let facebookDidHandled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        
        return facebookDidHandled || googleDidHandle
    }

}

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        Until.showLoading()
        if (error == nil) {
            // Perform any operations on signed in user here.
            do {
                let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
                let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                let auth = code.replacingOccurrences(of: "\n", with: "")
                let header = [
                    "Auth": auth
                ]
                let uuid = NSUUID().uuidString
                let token = UserDefaults.standard.object(forKey: NOTIFICATION_TOKEN) as? String ?? ""
                let device : [String : Any] = [
                    "OS": 0,
                    "DeviceId": uuid,
                    "Token": token
                ]
                
                let loginParam : [String : Any] = [
                    "SocialType": 2,
                    "SocialId": user.userID,
                    "FullName": user.profile.name,
                    "Email": user.profile.email,
                    "Device": device
                ]
                Alamofire.request(LOGIN_WITH_SOCIAL, method: .post, parameters: loginParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                    if let status = response.response?.statusCode {
                        if status == 200{
                            if let result = response.result.value {
                                let jsonData = result as! NSDictionary
                                let reaml = try! Realm()
                                let entity = UserEntity.initWithDictionary(dictionary: jsonData)
                                
                                try! reaml.write {
                                    reaml.add(entity, update: true)
                                    Until.initSendBird()
                                    Until.getSchedule()
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LOGIN_SUCCESS), object: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LOGIN_GMAIL_SUCCESS), object: nil)
                                }
                            }
                        }
                    }
                    Until.hideLoading()
                }
                
            } catch let error as NSError {
                print(error)
            }

        } else {
            print("\(error.localizedDescription)")
            Until.hideLoading()
        }
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
}
