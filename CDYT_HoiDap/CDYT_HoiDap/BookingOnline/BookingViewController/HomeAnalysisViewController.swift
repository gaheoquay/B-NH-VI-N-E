//
//  HomeAnalysisViewController.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 7/26/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class HomeAnalysisViewController: UIViewController {

    @IBOutlet weak var tbAnlysis: UITableView!
    var array = ["A","B","C"]
    var isCheck = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tbAnlysis.register(UINib.init(nibName: "CellTableInfomation", bundle: nil), forCellReuseIdentifier: "CellTableInfomation")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeAnalysisViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTableInfomation") as! CellTableInfomation
        cell.setData(arrayProfile: array)
        cell.setHeightViewProfile = {
            self.isCheck = !self.isCheck
            if self.isCheck {
                cell.marginLineBottom.constant = 135
            }else {
                cell.marginLineBottom.constant = 7
            }
        }
        return cell
    }
    
}
