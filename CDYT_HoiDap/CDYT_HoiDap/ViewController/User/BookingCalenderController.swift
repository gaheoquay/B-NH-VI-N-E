//
//  BookingCalenderController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 23/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol BookingCalenderControllerDelegate {
    func gotoService()
    func gotoFile()
}

class BookingCalenderController: UIViewController {

   
    @IBOutlet weak var btnSendBooking: UIButton!
    @IBOutlet weak var btnService: UIButton!
    @IBOutlet weak var btnBrifUser: UIButton!
    
    var delegate: BookingCalenderControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnService.layer.borderWidth = 0
        btnBrifUser.layer.borderWidth = 0
        btnSendBooking.layer.cornerRadius = 5
        btnSendBooking.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapService(_ sender: Any) {
        delegate?.gotoService()
    }
    @IBAction func btnSelectFileUser(_ sender: Any) {
        delegate?.gotoFile()
    }
    
    @IBAction func btnSendBooking(_ sender: Any) {
    }
    

}
