//
//  ServiceViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 24/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol ServiceViewControllerDelegate {
    func setIndexService(status : Int)
}

class ServiceViewController: UIViewController {
    
    var delegate: ServiceViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnHospital(_ sender: Any) {
        delegate?.setIndexService(status: 0)
    }
    
    @IBAction func btnHome(_ sender: Any) {
        delegate?.setIndexService(status: 1)
    }
    
    @IBAction func btnXnHome(_ sender: Any) {
        delegate?.setIndexService(status: 2)
    }
   
    
}
