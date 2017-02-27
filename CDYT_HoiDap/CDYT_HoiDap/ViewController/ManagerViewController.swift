//
//  ManagerViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 23/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol ManagerViewControllerDelegate {
    func gotoCvUser()
    func gotoHistory()
    func gotoCalendar()
}

class ManagerViewController: UIViewController {
    
    var delegate : ManagerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnHistory(_ sender: Any) {
        delegate?.gotoHistory()
    }
    
    @IBAction func btnCVUser(_ sender: Any) {
        delegate?.gotoCvUser()
    }
    
    @IBAction func btnCalendar(_ sender: Any) {
        delegate?.gotoCalendar()
    }

    
}
