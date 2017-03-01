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

class SearchFileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CreateCvViewControllerDelegate {
 

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
        return listFileUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! FileCell
        cell.setListUser()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.gotoBooking()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GET_LIST_FILE_USER), object: self.listFileUser[indexPath.row])
    }
    
    func requestUSer(){
        Until.showLoading()
        let Param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId" : Until.getCurrentId()
        ]
        print(Param)
        Alamofire.request(GET_PROFILE_USER, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! [NSDictionary]
                        for item in jsonData {
                            let entity = FileUserEntity.init(dictionary: item)
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
