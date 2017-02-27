//
//  SearchFileViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 27/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class SearchFileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var lbCv: UILabel!
    @IBOutlet weak var imgCv: UIImageView!
    @IBOutlet weak var tbHeight: NSLayoutConstraint!
    @IBOutlet weak var tbListFile: UITableView!
    @IBOutlet weak var btnCreateCv: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    
    let arrayName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUIView()
        setupBtn()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! FileCell
        if arrayName.count > 0{
            cell.lbName.text = arrayName[indexPath.row]
            cell.lbPrice.text = arrayName[indexPath.row]
            cell.btnDelete.isHidden = true
        }else {
            
        }
        return cell
    }
    
    
    func setUpUIView(){
         viewSearch.layer.cornerRadius = 3
        if arrayName.count > 0 {
            tbListFile.delegate = self
            tbListFile.dataSource = self
            tbListFile.register(UINib.init(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
            tbListFile.estimatedRowHeight = 9999
            tbListFile.rowHeight = UITableViewAutomaticDimension
            tbHeight.constant = 452
            lbCv.isHidden = true
            imgCv.isHidden = true
        }else {
            tbListFile.estimatedRowHeight = 0
            tbListFile.rowHeight = UITableViewAutomaticDimension
            tbHeight.constant = 0
            lbCv.isHidden = false
            imgCv.isHidden = false
            
        }
        view.layoutIfNeeded()
    }
    
    func setupBtn(){
        btnCreateCv.layer.cornerRadius = 5
        btnCreateCv.clipsToBounds = true
    }

    @IBAction func btnCreateCv(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "CreateCvViewController") as! CreateCvViewController
        self.navigationController?.pushViewController(viewcontroller, animated: true)
        
    }
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
