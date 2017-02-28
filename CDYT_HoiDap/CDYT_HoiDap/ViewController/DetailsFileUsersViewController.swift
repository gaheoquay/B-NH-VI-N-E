//
//  DetailsFileUsersViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 28/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DetailsFileUsersViewController: UIViewController {
    
    @IBOutlet weak var lbBillCode: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbHistoryCode: UILabel!
    @IBOutlet weak var lbNumberWait: UILabel!
    @IBOutlet weak var lbAdress: UILabel!
    @IBOutlet weak var lbSickName: UILabel!
    @IBOutlet weak var lbProvisionalPrice: UILabel!
    @IBOutlet weak var lbExamDate: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    

}
