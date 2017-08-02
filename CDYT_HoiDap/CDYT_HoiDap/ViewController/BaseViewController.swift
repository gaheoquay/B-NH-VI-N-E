//
//  BaseViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/22/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.appOnResume(_:)),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func appOnResume(_ notification: NSNotification) {
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
}
