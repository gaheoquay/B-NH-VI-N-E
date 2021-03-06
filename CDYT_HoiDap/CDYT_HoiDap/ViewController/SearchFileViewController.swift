//
//  SearchFileViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 27/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol SearchFileViewControllerDelegate {
    func gotoHistory(indexPath: IndexPath)
}

class SearchFileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CreateCvViewControllerDelegate {
 

    @IBOutlet weak var lbCv: UILabel!
    @IBOutlet weak var imgCv: UIImageView!
    @IBOutlet weak var tbHeight: NSLayoutConstraint!
    @IBOutlet weak var tbListFile: UITableView!
    @IBOutlet weak var btnCreateCv: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    
    var delegate : SearchFileViewControllerDelegate?
    var listFileUser = [BookingUserEntity]()
    var listSearchs = [BookingUserEntity]()
    var isCheckResult = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.becomeFirstResponder()
        requestUSer()
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
        let searchString = txtSearch.text?.trimmingCharacters(in: .whitespaces)

        if searchString != "" {
            return listSearchs.count
        }else {
            return listFileUser.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchString = txtSearch.text?.trimmingCharacters(in: .whitespaces)
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! FileCell
        if searchString != "" {
            cell.listBooking = listSearchs[indexPath.row]
        }else {
            cell.listBooking = listFileUser[indexPath.row]
        }
        cell.setListUser()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCheckResult == false {
            if txtSearch.text == "" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: GET_LIST_FILE_USER), object: self.listFileUser[indexPath.row])
            }else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: GET_LIST_FILE_USER), object: self.listSearchs[indexPath.row])
            }
        }else {
            delegate?.gotoHistory(indexPath: indexPath)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !tbListFile.isDecelerating {
            view.endEditing(true)
        }
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        
        let listSearch = listFileUser.filter { (bookingUserEntity) -> Bool in
            return self.removeUTF8(frString: bookingUserEntity.profile.patientName.lowercased()).contains(self.removeUTF8(frString: txtSearch.text!.lowercased()))
        }
        self.listSearchs = listSearch
        self.tbListFile.reloadData()
    }
    
    
    func requestUSer(){
        Until.showLoading()
        let Param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId" : Until.getCurrentId()
        ]
        print(Param)
        Alamofire.request(GET_BOOKING_BY_USERID, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! [NSDictionary]
                        for item in jsonData {
                            let entity = BookingUserEntity.init(dictionary: item)
                            self.listFileUser.append(entity)
                        }
                    }
                    self.setUpUIView()
                    self.tbListFile.reloadData()
                   
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
        
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
        viewcontroller.delegate = self
        self.navigationController?.pushViewController(viewcontroller, animated: true)
        
    }
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }


// MARK: CreateCvViewControllerDelegate
  func reloadData() {
    listFileUser.removeAll()
    requestUSer()
  }
}

extension SearchFileViewController {
    func removeUTF8(frString: String) -> String {
        return frString.folding(options: .diacriticInsensitive, locale: .current)
    }
}
