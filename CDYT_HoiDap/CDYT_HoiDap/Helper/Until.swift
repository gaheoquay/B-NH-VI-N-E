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
}

extension String {

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
    func showAlertWith(title: String, message: String, cancelBtnTitle: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let actionOk = UIAlertAction.init(title: cancelBtnTitle, style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
}

func isValidEmail(email:String) -> Bool {
    // println("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}
