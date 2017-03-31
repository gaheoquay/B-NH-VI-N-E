//
//  ExamInHomeViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 25/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ExamInHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SelectServiceViewControllerDelegate,FileCellDelegate {
    
    
    @IBOutlet weak var tbListServiceAddNew: UITableView!
    @IBOutlet weak var lbTotalPrice: UILabel!
//    @IBOutlet weak var heigtTableService: NSLayoutConstraint!
    @IBOutlet weak var viewAddNewService: UIView!
    @IBOutlet weak var viewBottom: UIView!
  @IBOutlet weak var layoutHeightViewBottom: NSLayoutConstraint!
    
    var listService = [ServicesEntity]()
    var listPacKage = [PackagesEntity]()
    override func viewDidLoad() {
        super.viewDidLoad()
      
      initTable()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  func initTable(){
    tbListServiceAddNew.delegate = self
    tbListServiceAddNew.dataSource = self
    tbListServiceAddNew.register(UINib.init(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
    tbListServiceAddNew.estimatedRowHeight = 999
    tbListServiceAddNew.rowHeight = UITableViewAutomaticDimension
  }
  func setUpViewBottom(){
    if listService.count == 0 && listPacKage.count == 0 {
      layoutHeightViewBottom.constant = 0
      viewBottom.isHidden = true
    }else{
      var SumPrice: Double = 0
      var priceSer : Double = 0
      
      let fontRegular = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
      let fontRegularWithColor = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor.green]
      for item in listPacKage {
        SumPrice = SumPrice + item.pack.pricePackage
      }
      for item in listService {
        priceSer = priceSer + item.priceService
      }
      let myAttrString = NSMutableAttributedString(string: " \(listPacKage.count) dịch vụ được chọn\n Tổng tiền tạm tính : ", attributes: fontRegular)
      myAttrString.append(NSMutableAttributedString(string: "\(String().replaceNSnumber(doublePrice: SumPrice + priceSer))", attributes: fontRegularWithColor))
      lbTotalPrice.attributedText = myAttrString
      tbListServiceAddNew.reloadData()
      layoutHeightViewBottom.constant = 60
      viewBottom.isHidden = false
    }
    self.view.layoutIfNeeded()
  }
    func setupUI(){
        viewAddNewService.layer.borderWidth = 0.5
        viewAddNewService.layer.cornerRadius = 3
        viewAddNewService.layer.borderColor = UIColor.gray.cgColor
        viewBottom.layer.borderColor = UIColor.gray.cgColor
        viewBottom.layer.borderWidth = 0.5
      setUpViewBottom()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listPacKage.count
        }else {
            return listService.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! FileCell
        cell.delegate = self
        if indexPath.section == 0 {
            cell.setDataPackage(entity: listPacKage[indexPath.row])
            cell.indexPath = indexPath
        }else {
            cell.setDataService(entity: listService[indexPath.row])
            cell.indexPath = indexPath
        }
        return cell
    }
    
    @IBAction func btnAddNewService(_ sender: Any) {
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "SelectServiceViewController") as! SelectServiceViewController
        viewcontroller.delegate = self
        self.navigationController?.pushViewController(viewcontroller, animated: true)
        
    }
    
    func getListService(listPackage: [PackagesEntity], listSer: [ServicesEntity]) {
        let listAddNewSerVice = listSer.filter { (serviceEntity) -> Bool in
            serviceEntity.isCheckSelect == true
        }
        self.listService = listAddNewSerVice
        
        let listAddPackage = listPackage.filter { (packagesEntity) -> Bool in
            packagesEntity.pack.isCheckSelect == true
        }
        self.listPacKage = listAddPackage
      setUpViewBottom()
  }
   
    @IBAction func btnSuccess(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GET_LIST_SERIVCE_IN_HOME), object: self.listService)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GET_LIST_PACKAGE_IN_HOME), object: self.listPacKage)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func deleteFileUser(indexPath: IndexPath) {
        if indexPath.section == 0 {
            listPacKage.remove(at: indexPath.row)
        }else {
            listService.remove(at: indexPath.row)
        }
        tbListServiceAddNew.reloadData()
      setUpViewBottom()
    }
    
    func gotoDetailHistory(index: IndexPath) {
        
    }
    
    func gotoDetailFileUser(indexPath: IndexPath) {
    }
    
    @IBAction func btnDeleteAllService(_ sender: Any) {
        listPacKage.removeAll()
        tbListServiceAddNew.reloadData()
      setUpViewBottom()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}
