//
//  ExamScheduleViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ExamScheduleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tbListExamSchedule: UITableView!
    
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
        return cell
    }
    
    func setupTable(){
        tbListExamSchedule.delegate = self
        tbListExamSchedule.dataSource = self
        tbListExamSchedule.estimatedRowHeight = 9999
        tbListExamSchedule.rowHeight = UITableViewAutomaticDimension
        tbListExamSchedule.register(UINib.init(nibName: "ExamScheduleCell", bundle: nil), forCellReuseIdentifier: "ExamScheduleCell")
    }

    
}
