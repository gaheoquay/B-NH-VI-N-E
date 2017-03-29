//
//  DetaiAnalysisViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DetaiAnalysisViewController: UIViewController {
    
    @IBOutlet weak var lbPantentHistory: UILabel!
    @IBOutlet weak var imgBarcode: UIImageView!
    @IBOutlet weak var tbListAnalysisCode: UITableView!
    @IBOutlet weak var lbTotalPrice: UILabel!
    @IBOutlet weak var lbSurCharge: UILabel!
    @IBOutlet weak var lbAdress: UILabel!
    @IBOutlet weak var tbListService: UITableView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbHour: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
    }

    

}
