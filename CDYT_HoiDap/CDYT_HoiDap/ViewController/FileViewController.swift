//
//  FileViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 24/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class FileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FileCellDelegate {

    @IBOutlet weak var tbListFile: UITableView!
    @IBOutlet weak var tbHeight: NSLayoutConstraint!
    @IBOutlet weak var imgCv: UIImageView!
    @IBOutlet weak var lbCv: UILabel!
    @IBOutlet weak var btnCreateCv: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var listFileUser = [FileUserEntity]()
    var ischeckDelete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestUSer()
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
        if listFileUser.count > 0{
        cell.isCheck(ischeckDelete: ischeckDelete)
        cell.delegate = self
        }else {
            
        }
        return cell
    }
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Setup UI
    
    func setUpUIView(){
        if listFileUser.count > 0 {
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
    
    //MARK: Button
    
    @IBAction func btnCreateCV(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "CreateCvViewController") as! CreateCvViewController
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        if ischeckDelete == false {
            ischeckDelete = true
            btnDelete.setTitle("Xong", for: .normal)
            btnDelete.setTitleColor(UIColor.white, for: .normal)
            btnCreateCv.isHidden = true
        }else {
            ischeckDelete = false
            btnDelete.setTitle("Xoá", for: .normal)
            btnDelete.setTitleColor(UIColor.red, for: .normal)
            btnCreateCv.isHidden = false
        }
        tbListFile.reloadData()
    }
    
    func gotoDetailFileUser() {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "CreateCvViewController") as! CreateCvViewController
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    func deleteFileUser() {
        print("delete")
    }
    //MARK: Request API
    func requestUSer(){
        listFileUser = FileUserEntity().initListUser()
    }
    
    
}
