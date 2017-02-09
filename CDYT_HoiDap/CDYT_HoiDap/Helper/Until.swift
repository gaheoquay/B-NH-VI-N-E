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

  class func gotoLogin(_self : UIViewController, cannotBack:Bool ){
    let storyBoard = UIStoryboard.init(name: "User", bundle: nil)
    let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    viewController.cannotBack = cannotBack
    _self.navigationController?.pushViewController(viewController, animated: true)
  }
    class func isValidEmail(email:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    class func getAuthKey() -> NSDictionary{
        let keyString = String(format: "%.0f", NSDate().timeIntervalSince1970)
        let tokenString = DataEncryption.getMD5(from: "\(keyString)\(KEY_AUTH_DEFAULT)")
        
        let auth = [
            "Key" : keyString,
            "Token" : tokenString
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
}
