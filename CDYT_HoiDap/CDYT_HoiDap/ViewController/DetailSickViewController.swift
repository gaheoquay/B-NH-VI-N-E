//
//  DetailSickViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 02/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DetailSickViewController: UIViewController {

    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    var content = ""
    var titleUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbTitle.text = titleUser
        lbContent.text = content
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
