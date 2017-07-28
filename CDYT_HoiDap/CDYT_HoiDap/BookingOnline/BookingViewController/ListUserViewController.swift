//
//  ListUserViewController.swift
//  CDYT_HoiDap
//
//  Created by Quang Anh on 7/28/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ListUserViewController: UIViewController {

    @IBOutlet weak var tbListUser: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbListUser.estimatedRowHeight = 999
        tbListUser.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ListUserViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCreate = tableView.dequeueReusableCell(withIdentifier: "CreateCvCell") as! CreateCvCell
        let cellListUser = tableView.dequeueReusableCell(withIdentifier: "ListUserCell") as! ListUserCell
        let cellSelect = tableView.dequeueReusableCell(withIdentifier: "SelectCellUser") as! SelectCellUser
        switch (indexPath.row) {
        case 0:
            return cellCreate
        case 1:
            return cellListUser
        default:
            return cellSelect
        }
    }
}
