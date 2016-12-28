//
//  UserViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var questionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        avaImg.layer.cornerRadius = 10
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func notificationTapAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func messageTapAction(_ sender: Any) {
    }
    
    @IBAction func accountTapAction(_ sender: Any) {
    }
    
    @IBAction func settingTapAction(_ sender: Any) {
    }

}
