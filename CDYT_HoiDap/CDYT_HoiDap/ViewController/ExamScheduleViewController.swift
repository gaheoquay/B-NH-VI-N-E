//
//  ExamScheduleViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ExamScheduleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ExamScheduleCellDelegate{

    @IBOutlet weak var tbListExamSchedule: UITableView!
    @IBOutlet weak var imageCalendar: UIImageView!
    @IBOutlet weak var lbCalendar: UILabel!
    @IBOutlet weak var heightTbListUser: NSLayoutConstraint!
    @IBOutlet weak var viewHiddent: UIView!
    
    var arrayName = ["Quang","Anh"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExamScheduleCell" ) as! ExamScheduleCell
        cell.lbName.text = arrayName[indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func gotoDetailUser(index: IndexPath) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "DetailsFileUsersViewController") as! DetailsFileUsersViewController
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    func setupTable(){
        if arrayName.count > 0 {
        tbListExamSchedule.delegate = self
        tbListExamSchedule.dataSource = self
        tbListExamSchedule.estimatedRowHeight = 9999
        tbListExamSchedule.rowHeight = UITableViewAutomaticDimension
        heightTbListUser.constant = 502
        tbListExamSchedule.register(UINib.init(nibName: "ExamScheduleCell", bundle: nil), forCellReuseIdentifier: "ExamScheduleCell")
        imageCalendar.isHidden = true
        lbCalendar.isHidden = true
        }else {
            
            tbListExamSchedule.estimatedRowHeight = 0
            tbListExamSchedule.rowHeight = UITableViewAutomaticDimension
            heightTbListUser.constant = 0
            imageCalendar.isHidden = false
            lbCalendar.isHidden = false
        }
    }
    
    
    
}
