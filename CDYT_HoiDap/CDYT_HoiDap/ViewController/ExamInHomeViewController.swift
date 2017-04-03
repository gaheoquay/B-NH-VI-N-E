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
    @IBOutlet weak var heigtTableService: NSLayoutConstraint!
    @IBOutlet weak var viewAddNewService: UIView!
    @IBOutlet weak var viewBottom: UIView!
    
    var listService = [ServicesEntity]()
    var listPacKage = [PackagesEntity]()
    var service = PackServiceEntity()
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
        
        addNewListService()
        
        if listPacKage.count == 0 && listService.count == 0 || (service.listPack.count == 0 && service.listSer.count == 0) {
            heigtTableService.constant = UIScreen.main.bounds.size.height
            viewBottom.isHidden = true
        }else {
            heigtTableService.constant = UIScreen.main.bounds.size.height - 184
            viewBottom.isHidden = false
        }
        
        tbListServiceAddNew.delegate = self
        tbListServiceAddNew.dataSource = self
        tbListServiceAddNew.register(UINib.init(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
        tbListServiceAddNew.estimatedRowHeight = 999
        tbListServiceAddNew.rowHeight = UITableViewAutomaticDimension
        viewAddNewService.layer.borderWidth = 0.5
        viewAddNewService.layer.cornerRadius = 3
        viewAddNewService.layer.borderColor = UIColor.gray.cgColor
        viewBottom.layer.borderColor = UIColor.gray.cgColor
        viewBottom.layer.borderWidth = 0.5
        setSumPrice()
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if listPacKage[indexPath.row].pack.isCheckSelect == false {
                return 0
            }else {
                return UITableViewAutomaticDimension
            }
        }else {
            if listService[indexPath.row].isCheckSelect == false {
                return 0
            }else {
                return UITableViewAutomaticDimension
            }
        }
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
            if listPacKage[indexPath.row].pack.isCheckSelect == false {
            cell.isHidden = true
            }else {
            cell.isHidden = false
            }
            cell.setDataPackage(entity: listPacKage[indexPath.row])
            cell.indexPath = indexPath
        }else {
            
            if listService[indexPath.row].isCheckSelect == false {
            cell.isHidden = true
            }else {
            cell.isHidden = false
            }
            cell.setDataService(entity: listService[indexPath.row])
            cell.indexPath = indexPath
        }
        return cell
    }
    
    @IBAction func btnAddNewService(_ sender: Any) {
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "SelectServiceViewController") as! SelectServiceViewController
        viewcontroller.delegate = self
        viewcontroller.service = self.service
        self.navigationController?.pushViewController(viewcontroller, animated: true)
        
    }
    
    func getListService(services: PackServiceEntity) {
        self.service = services
        setSumPrice()
        setupUI()
    }
    
    func addNewListService(){
        let listAddNewSerVice = service.listSer.filter { (serviceEntity) -> Bool in
            serviceEntity.isCheckSelect == true
        }
        let listAddPackage = service.listPack.filter { (packagesEntity) -> Bool in
            packagesEntity.pack.isCheckSelect == true
        }
        
        listService.removeAll()
        for item in listAddNewSerVice {
            self.listService.append(item)
        }
        listPacKage.removeAll()
        for pac in listAddPackage {
            self.listPacKage.append(pac)
        }

    }
    
    func setSumPrice(){
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
        let myAttrString = NSMutableAttributedString(string: " \(listPacKage.count + listService.count) dịch vụ được chọn\n Tổng tiền tạm tính : ", attributes: fontRegular)
        myAttrString.append(NSMutableAttributedString(string: "\(String().replaceNSnumber(doublePrice: SumPrice + priceSer))", attributes: fontRegularWithColor))
        lbTotalPrice.attributedText = myAttrString
        tbListServiceAddNew.reloadData()
    }
    
    @IBAction func btnSuccess(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GET_LIST_SERIVCE_IN_HOME), object: self.listService)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GET_LIST_PACKAGE_IN_HOME), object: self.listPacKage)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GET_SERVICES), object: self.service)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func deleteFileUser(indexPath: IndexPath) {
        if indexPath.section == 0 {
            listPacKage[indexPath.row].pack.isCheckSelect = false
            service.listPack[indexPath.row].pack.isCheckSelect = false
        }else {
            listService[indexPath.row].isCheckSelect = false
            service.listSer[indexPath.row].isCheckSelect = false
        }
        setupUI()
    }
    
    func gotoDetailHistory(index: IndexPath) {
        
    }
    
    func gotoDetailFileUser(indexPath: IndexPath) {
    }
    
    @IBAction func btnDeleteAllService(_ sender: Any) {
        listPacKage.removeAll()
        listService.removeAll()
        requestListService()
        setSumPrice()
    }
    
    
    func requestListService(){
        let param : [String : Any] = [
            "Auth": Until.getAuthKey()
        ]
        Until.showLoading()
        Alamofire.request(GET_LIST_PACKAGE_SERVICE, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        let entity = PackServiceEntity.init(dictionary: jsonData)
                        self.service = entity
                    }
                }else{
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }
        
    }
    
    
}
