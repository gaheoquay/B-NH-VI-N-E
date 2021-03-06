//
//  FileViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 24/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class FileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FileCellDelegate,CreateCvViewControllerDelegate {

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
        cell.indexPath = indexPath
        if listFileUser.count > 0{
        cell.isCheck(ischeckDelete: ischeckDelete)
        cell.listUser = listFileUser[indexPath.row]
        cell.setSearchListUser()
        cell.delegate = self
        }else {
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "CreateCvViewController") as! CreateCvViewController
        viewcontroller.delegate = self
        viewcontroller.infoUser = listFileUser[indexPath.row]
        if ischeckDelete {
        
        }else {
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Request API
    func requestUSer(){
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
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
        
    }
    
    
    //MARK: Setup UI
    
    func setUpUIView(){
        if listFileUser.count > 0 {
            tbListFile.delegate = self
            tbListFile.dataSource = self
            tbListFile.register(UINib.init(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
            tbListFile.estimatedRowHeight = 9999
            tbListFile.rowHeight = UITableViewAutomaticDimension
            tbHeight.constant = UIScreen.main.bounds.size.height - 126
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
        viewcontroller.delegate = self
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
    
    //MARK: Delegate
    func gotoDetailFileUser(indexPath: IndexPath) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "CreateCvViewController") as! CreateCvViewController
        viewcontroller.delegate = self
        viewcontroller.infoUser = listFileUser[indexPath.row]
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    func deleteFileUser(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có muốn xoá hồ sơ \(listFileUser[indexPath.row].patientName)?", preferredStyle: .alert)
        let alertActionOk = UIAlertAction(title: "Đồng Ý", style: .default) { (UIAlertAction) in
            self.requestDeleteProfile(index: indexPath.row)
        }
        let alertActionCancel = UIAlertAction(title: "Bỏ qua", style: .cancel) { (UIAlertAction) in
            
        }
        alert.addAction(alertActionOk)
        alert.addAction(alertActionCancel)
        self.present(alert, animated: true, completion: nil)

    }
    func reloadData() {
        listFileUser.removeAll()
        requestUSer()
    }
    func gotoDetailHistory(index: IndexPath) {
        
    }
    //MARK: request API
    func requestDeleteProfile(index:Int){
        let entity = listFileUser[index]
        let Param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId" : Until.getCurrentId(),
            "ListProfileId" : [entity.id]
        ]
        Until.showLoading()
        print(Param)
        Alamofire.request(DELELTE_PROFILE, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                        self.listFileUser.remove(at: index)
                        self.tbListFile.reloadData()
                        self.setUpUIView()
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue:RELOAD_BOOKING), object: nil)
                }
                else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
        

    }
    
    
    
    
}
