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
//      NotificationCenter.default.addObserver(self, selector: #selector(self.gotoDetail(notification:)), name: NSNotification.Name.init(GO_TO_DETAIL_WHEN_TAP_NOTIFICATION), object: nil)
//      NotificationCenter.default.addObserver(self, selector: #selector(self.showNotification(notification:)), name: NSNotification.Name.init(SHOW_NOTIFICAION), object: nil)
//      NotificationCenter.default.addObserver(self, selector: #selector(self.gotoChat(notification:)), name: NSNotification.Name.init(GO_TO_CHAT), object: nil)
//      NotificationCenter.default.addObserver(self, selector: #selector(setUpBadge), name: Notification.Name.init(UPDATE_BADGE), object: nil)
//      NotificationCenter.default.addObserver(self, selector: #selector(gotoSchedule), name: Notification.Name.init(GO_TO_SCHEDULE), object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
