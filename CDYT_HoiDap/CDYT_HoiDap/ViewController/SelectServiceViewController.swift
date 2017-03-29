//
//  SelectServiceViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 27/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

protocol SelectServiceViewControllerDelegate {
    func getListService(listPackage : [PackagesEntity], listSer: [ServicesEntity] )
}

class SelectServiceViewController: UIViewController,ServiceCellDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tbListService: UITableView!
    
    var isPackage = true

    var service = PackServiceEntity()
    var listSearch = [PackagesEntity]()
    var listSearchService = [ServicesEntity]()
    var delegate : SelectServiceViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestListService()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
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
        if txtSearch.text != "" {
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
        cell.indexPatch = indexPath
        if txtSearch.text == "" {
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
    }
    
    @IBAction func btnService(_ sender: Any) {
        isPackage = false
        tbListService.reloadData()
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
//        if isPackage {
//            let serVice = service.listSer.filter { (servicesEntity) -> Bool in
//                servicesEntity.id == service.listPack[indexPatch.row].pack.id
//            }
//            if serVice.count > 0 {
//                if serVice[0].id == service.listPack[indexPatch.row].pack.id && service.listPack[indexPatch.row].pack.isCheckSelect == true {
//                    print("Đã có dịch vụ")
//                }
//            }
//        }else {
//            let pacKage = service.listPack.filter({ (packagesEntity) -> Bool in
//                packagesEntity.pack.id == service.listSer[indexPatch.row].id
//            })
//            if pacKage.count > 0 {
//                if pacKage[0].pack.id == service.listSer[indexPatch.row].id && service.listSer[indexPatch.row].isCheckSelect == true {
//                    print("Đã chọn gói")
//                }
//            }
//        }
//        
    }
    
    func reloadDataCell(indexPatch: IndexPath) {
        tbListService.reloadRows(at: [indexPatch], with: .automatic)
    }

    
    
    @IBAction func btnClose(_ sender: Any) {
        delegate?.getListService(listPackage: service.listPack, listSer: service.listSer)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension SelectServiceViewController {
    func removeUTF8(frString: String) -> String {
        return frString.folding(options: .diacriticInsensitive, locale: .current)
    }
}

