//
//  ExamInHomeViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 25/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ExamInHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tbListServiceAddNew: UITableView!
    @IBOutlet weak var lbTotalPrice: UILabel!
    @IBOutlet weak var heigtTableService: NSLayoutConstraint!
    @IBOutlet weak var viewAddNewService: UIView!
    @IBOutlet weak var viewBottom: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        tbListServiceAddNew.delegate = self
        tbListServiceAddNew.dataSource = self
        tbListServiceAddNew.register(UINib.init(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
        tbListServiceAddNew.estimatedRowHeight = 999
        tbListServiceAddNew.rowHeight = UITableViewAutomaticDimension
        heigtTableService.constant = UIScreen.main.bounds.size.height - 184
        viewAddNewService.layer.borderWidth = 0.5
        viewAddNewService.layer.cornerRadius = 3
        viewAddNewService.layer.borderColor = UIColor.gray.cgColor
        viewBottom.layer.borderColor = UIColor.gray.cgColor
        viewBottom.layer.borderWidth = 0.5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! FileCell
        cell.setDataService()
        return cell
    }
    
    @IBAction func btnAddNewService(_ sender: Any) {
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "DetailAnalysisFormViewController") as! DetailAnalysisFormViewController
        self.navigationController?.pushViewController(viewcontroller, animated: true)
        
    }
   
    @IBAction func btnSuccess(_ sender: Any) {
    }
    
    @IBAction func btnDeleteAllService(_ sender: Any) {
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}
