//
//  SearchFileViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 27/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol SearchFileViewControllerDelegate {
    func gotoBooking()
}

class SearchFileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var lbCv: UILabel!
    @IBOutlet weak var imgCv: UIImageView!
    @IBOutlet weak var tbHeight: NSLayoutConstraint!
    @IBOutlet weak var tbListFile: UITableView!
    @IBOutlet weak var btnCreateCv: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    
    var listFileUser = [FileUserEntity]()
    var delegate: SearchFileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestListUser()
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
        return listFileUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! FileCell
        cell.setListUser(entity: listFileUser[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.gotoBooking()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GET_LIST_FILE_USER), object: self.listFileUser[indexPath.row])
    }
    
    func requestListUser(){
//        listFileUser = FileUserEntity().initListUser()
    }
    
    
    //MARK: Setup UI
    func setUpUIView(){
         viewSearch.layer.cornerRadius = 3
        if listFileUser.count > 0 {
            tbListFile.delegate = self
            tbListFile.dataSource = self
            tbListFile.register(UINib.init(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
            tbListFile.estimatedRowHeight = 9999
            tbListFile.rowHeight = UITableViewAutomaticDimension
            tbHeight.constant = UIScreen.main.bounds.size.height
            lbCv.isHidden = true
            imgCv.isHidden = true
            btnCreateCv.isHidden = true
        }else {
            tbListFile.estimatedRowHeight = 0
            tbListFile.rowHeight = UITableViewAutomaticDimension
            tbHeight.constant = 0
            lbCv.isHidden = false
            imgCv.isHidden = false
            btnCreateCv.isHidden = false
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
