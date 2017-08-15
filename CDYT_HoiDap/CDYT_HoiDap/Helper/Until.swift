//
//  Until.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 ISORA. All rights reserved.
//

import Foundation
import UIKit




extension UIColor {
  
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension String {
    func convertStringToDictionary() -> [String:Any]? {
        if let data = self.data(using: String.Encoding.utf8) {
            return try! JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
        }
        return nil
    }
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
    
    func convertTimeStampWithDateFormat(timeStamp: Double, dateFormat: String) -> String{
        let date = Date(timeIntervalSince1970: timeStamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT +7")
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: date)
    }
    
    func convertDatetoString(date: Date, dateFormat: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT +7")
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: date)
    }
    
    
    func getPostDateDescription(timeToCalculate : Double) -> String{
        let timestampNow = NSDate().timeIntervalSince1970
        let seconds = timestampNow - timeToCalculate
        
        let hoursCount = seconds / 3600
        let minutesCount = (seconds.truncatingRemainder(dividingBy: 3600)) / 60
        //        let secondsCount = (seconds % 3600) % 60
        
        if (hoursCount > 24){
            let dateCount = Int(floor(hoursCount / 24))
            if dateCount < 10 {
                return "\(dateCount) ngày"
            }else{
                let dateFormat = convertTimeStampWithDateFormat(timeStamp: timeToCalculate, dateFormat: "dd/MM/YYYY")
                return dateFormat
            }
            
        }else if( hoursCount > 1){
            return "\(Int(floor(hoursCount))) giờ"
        }else if (minutesCount > 1){
            return "\(Int(floor(minutesCount))) phút"
        }else{
            return "vừa xong"
        }
        
    }
    
    func replaceNSnumber(doublePrice: Double) -> String{
        let numberFormatter = NumberFormatter()
        let myNumber = NSNumber(value: Double(doublePrice))
        numberFormatter.groupingSize = 3
        numberFormatter.groupingSeparator = "."
        numberFormatter.usesGroupingSeparator = true
        return numberFormatter.string(from: myNumber)!
    }
    
}
extension Date {
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    
    func dateAt(hours: Int, minutes: Int, days: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.weekday = days
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
    
    func weekDayAt(days: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        
        date_components.weekday = days
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
    
}

extension UIAlertController {
    func showAlertWith(vc: UIViewController, title: String, message: String, cancelBtnTitle: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let actionOk = UIAlertAction.init(title: cancelBtnTitle, style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(actionOk)
        vc.present(alert, animated: true, completion: nil)
    }
    
    
}

class Until{
    class func getCurrentId() -> String {
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        
        if users.count > 0 {
            return users.first!.id
        }else{
            return ""
        }
    }
    class func initSendBird(){
        let realm = try! Realm()
        let userEntity = realm.objects(UserEntity.self).first
        
        if userEntity != nil {
            SBDMain.connect(withUserId: userEntity!.id, completionHandler: { (user, error) in
                if error != nil {
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
                        SBDMain.disconnect(completionHandler: {
                        })
                        
                        return
                    }
                })
            })
        }
    }
    
    class func getBagValue(){
        let param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": Until.getCurrentId()
        ]
        var count = 0
        SBDGroupChannel.getTotalUnreadMessageCount { (number, error) in
            unreadMessageCount = Int(number)
            count += 1
            if count == 2{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: UPDATE_BADGE), object: nil)
            }
        }
        
        Alamofire.request(GET_UNREAD_NOTIFICATION, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        notificationCount = jsonData["Count"] as! Int
                        
                    }
                }
            }
          
            count += 1
          
            if count == 2{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: UPDATE_BADGE), object: nil)
            }
          
        }
    }
  
    class func gotoLogin(_self : UIViewController, cannotBack:Bool ){
        let storyBoard = UIStoryboard.init(name: "User", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        _self.navigationController?.pushViewController(viewController, animated: true)
    }
  
    class func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._]{4,50}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    class func isValidPhone(phone: String) -> Bool {
        
        let PHONE_REGEX = "^0[0-9'@s]{9,10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phone)
        return result
        
    }
    class func haveNewVersion(forceUpdate: Bool) {
        let alert = UIAlertController(title: "Thông báo",
                                      message:"Ứng dụng đã có phiên bản mới. Trải nghiệm ngay!",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cập nhật", style: .default, handler: { (_) in
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/id1263531287") else { return }
            UIApplication.shared.openURL(url)
        }))
        if !forceUpdate {
            alert.addAction(UIAlertAction(title: "Bỏ qua", style: .cancel, handler: nil))
        }
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }
    class func getSchedule(){
        let param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": Until.getCurrentId()
        ]
        Alamofire.request(GET_SCHEDULE, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! [NSDictionary]
                        for item in jsonData{
                            let entity = AllUserEntity.init(dictionary: item)
                            let localNotification = UILocalNotification()
                            let dateFormat = DateFormatter()
                            dateFormat.dateFormat = "dd/MM/yyyy"
                            let datePick = dateFormat.string(from: NSDate(timeIntervalSince1970: entity.booking.bookingDate) as Date)
                            let dateString = "06:00 " + datePick
                            dateFormat.dateFormat = "HH:mm dd/MM/yyyy"
                            localNotification.fireDate = dateFormat.date(from: dateString)
                            localNotification.alertBody = "Xác định đi khám cho lịch đã đặt"
                            localNotification.alertAction = ""
                            localNotification.timeZone = NSTimeZone.default
                            //              localNotification.applicationIconBadgeNumber = 1
                            UIApplication.shared.scheduledLocalNotifications?.append(localNotification)
                        }
                    }
                }
            }
        }
    }
    class func getAuthKey() -> NSDictionary{
        var keyString = ""
        var loginToken = ""
        let realm = try! Realm()
        if let userEntity = realm.objects(UserEntity.self).first {
            keyString = userEntity.id
            loginToken = userEntity.loginToken
        }else{
            keyString = String(format: "%.0f", NSDate().timeIntervalSince1970)
        }
        let tokenString = DataEncryption.getMD5(from: "\(keyString)\(KEY_AUTH_DEFAULT)")
        
        let auth = [
            "Key" : keyString,
            "Token" : tokenString ?? "",
            "LoginToken": loginToken
        ]
        
        return auth as NSDictionary
    }
    
    class func showLoading(){
        
        let activityData = ActivityData.init(size: CGSize(width: 40, height:40), message: "", messageFont: UIFont.systemFont(ofSize: 12), type: NVActivityIndicatorType.ballTrianglePath, color: UIColor.white, padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 0)
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
    }
    
    class func hideLoading(){
      
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
      
    }
    
    class func sendAndSetTracer(value: String){
      
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: value)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    class func sendEventTracker(category: String, action : String , label : String){
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label, value: nil).build() as [NSObject : AnyObject])
    }
    
    class func generateBarcode(from string: String) -> UIImage? {
      
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
 
    }
    
}
