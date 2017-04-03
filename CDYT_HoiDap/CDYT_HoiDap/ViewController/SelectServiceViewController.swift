//
//  SelectServiceViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 27/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

protocol SelectServiceViewControllerDelegate {
    func getListService(services: PackServiceEntity)
}

class SelectServiceViewController: UIViewController,ServiceCellDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tbListService: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var imgTabPack: UIImageView!
    @IBOutlet weak var imgTabService: UIImageView!
    
    var isPackage = true
    var isSearch = false

    var service = PackServiceEntity()
    var listSearch = [PackagesEntity]()
    var listSearchService = [ServicesEntity]()
    var delegate : SelectServiceViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if service.listPack.count > 0 && service.listSer.count > 0 {
        
        }else {
        requestListService()
        }
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        imgTabService.isHidden = true
        viewSearch.layer.cornerRadius = 5
        viewSearch.clipsToBounds = true
        tbListService.delegate = self
        tbListService.dataSource = self
        tbListService.rowHeight = UITableViewAutomaticDimension
        tbListService.estimatedRowHeight = 999
        tbListService.register(UINib.init(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let txtSerchString = txtSearch.text?.trimmingCharacters(in: .whitespaces)
        if txtSerchString != "" {
            if section == 0 {
                return listSearch.count
            }else {
                return listSearchService.count
            }
        }else {
            if isPackage {
                return service.listPack.count
            }else {
                return service.listSer.count
            }

        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell") as! ServiceCell
        cell.delegate = self
        let txtSerchString = txtSearch.text?.trimmingCharacters(in: .whitespaces)
        cell.indexPatch = indexPath

        if txtSerchString == "" {
            self.isSearch = false
            if isPackage {
                cell.isPackage = true
                cell.pacKage = service.listPack[indexPath.row]
                cell.setData()
            }else {
                cell.isPackage = false
                cell.serVice = service.listSer[indexPath.row]
                cell.setData()
            }
        }else {
            self.isSearch = true
            cell.isPackage = false
            if indexPath.section == 0 {
                cell.pacKage = listSearch[indexPath.row]
                cell.isPackage = true
                cell.setData()
            }else {
                cell.serVice = listSearchService[indexPath.row]
                cell.isPackage = false
                cell.setData()
            }
        }
        
        return cell
    }
    
    @IBAction func btnPackage(_ sender: Any) {
        isPackage = true
        tbListService.reloadData()
        imgTabPack.image = UIImage.init(named: "tab1.png")
        imgTabService.isHidden = true
        imgTabPack.isHidden = false
    }
    
    @IBAction func btnService(_ sender: Any) {
        isPackage = false
        tbListService.reloadData()
        imgTabService.image = UIImage.init(named: "tab1.png")
        imgTabService.isHidden = false
        imgTabPack.isHidden = true
    }

    @IBAction func btnSearch(_ sender: Any) {
        let packSearch = service.listPack.filter { (packagesEntity) -> Bool in
            return (self.removeUTF8(frString: packagesEntity.pack.name.lowercased())).contains(self.removeUTF8(frString: txtSearch.text!.lowercased()))
        }
        let serviceSearch = service.listSer.filter { (serviceEntity) -> Bool in
            return (self.removeUTF8(frString: serviceEntity.name.lowercased())).contains(self.removeUTF8(frString: txtSearch.text!.lowercased()))
        }
        self.listSearchService = serviceSearch
        self.listSearch = packSearch
        self.tbListService.reloadData()
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
                    self.tbListService.reloadData()
                }else{
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }

    }
    
    func checkSelect(indexPatch: IndexPath) {
        
        if isSearch {
            if indexPatch.section == 0 {
                if listSearch[indexPatch.row].pack.isCheckSelect == false {
                    isCheckPac(indexPatch: indexPatch, listPacks: listSearch)
                }
            }else {
                if listSearchService[indexPatch.row].isCheckSelect == false {
                    isCheckService(indexPatch: indexPatch, listSers: listSearchService)
                }
            }
        
        }else {
            if isPackage {
                if service.listPack[indexPatch.row].pack.isCheckSelect == false {
                    isCheckPac(indexPatch: indexPatch, listPacks: service.listPack)
                }
            }else {
                if service.listSer[indexPatch.row].isCheckSelect == false{
                    isCheckService(indexPatch: indexPatch, listSers: service.listSer )
                }
            }
        }
        
    }
    
    func isCheckPac(indexPatch: IndexPath, listPacks : [PackagesEntity]){
            let listSer = service.listSer.filter({ (servicesEntity) -> Bool in
                servicesEntity.isCheckSelect == true
            })
            for item in listSer {
                for pac in listPacks[indexPatch.row].service {
                    if item.name == pac.name {
                        let alert = UIAlertController.init(title: "Thông báo", message: "Bạn đã chọn dịch vụ lẻ có trong gói này . Bạn có muốn bỏ dịch vụ lẻ đi không ?", preferredStyle: UIAlertControllerStyle.alert)
                        let actionOk = UIAlertAction.init(title: "Đồng ý", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                            item.isCheckSelect = false
                            self.tbListService.reloadData()
                        })
                        let actionCancel = UIAlertAction.init(title: "Huỷ", style: .default, handler: { (UIAlertAction) in
                            listPacks[indexPatch.row].pack.isCheckSelect = false
                            self.tbListService.reloadData()
                        })
                        alert.addAction(actionOk)
                        alert.addAction(actionCancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
    }
    
    func isCheckService(indexPatch: IndexPath, listSers: [ServicesEntity]){
            let listPac = service.listPack.filter({ (packagesEntity) -> Bool in
                packagesEntity.pack.isCheckSelect == true
            })
            for listSv in listPac {
                for item in listSv.service {
                    if item.name == listSers[indexPatch.row].name {
                        let alert = UIAlertController.init(title: "Thông báo", message: "Bạn đã chọn gói có dịch vụ lẻ này , Bạn có muôn bỏ gói dịch vụ đi không ?", preferredStyle: UIAlertControllerStyle.alert)
                        let actionOk = UIAlertAction.init(title: "Đồng ý", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                            listSv.pack.isCheckSelect = false
                            self.tbListService.reloadData()
                        })
                        let actionCancel = UIAlertAction.init(title: "Huỷ", style: .default, handler: { (UIAlertAction) in
                            listSers[indexPatch.row].isCheckSelect = false
                            self.tbListService.reloadData()
                        })
                        alert.addAction(actionOk)
                        alert.addAction(actionCancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
    }
    
    func reloadDataCell(indexPatch: IndexPath) {
        tbListService.reloadRows(at: [indexPatch], with: .automatic)
    }

    
    
    @IBAction func btnClose(_ sender: Any) {
        delegate?.getListService(services: service)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension SelectServiceViewController {
    func removeUTF8(frString: String) -> String {
        return frString.folding(options: .diacriticInsensitive, locale: .current)
    }
}

