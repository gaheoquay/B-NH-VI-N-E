//
//  ChangPassViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 1/12/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ChangPassViewController: BaseViewController {

    @IBOutlet weak var curentPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var confNewPassTxt: UITextField!
    @IBOutlet weak var errLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errLbl.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: CHANGE_PASS)
    }

    func validateData() -> String{
        let curPassString = curentPass.text
        let newpassString = newPass.text
        let confNewPassString = confNewPassTxt.text
        
        if curPassString == "" || newpassString == "" || confNewPassString == "" {
            return "Vui lòng nhập đầy đủ thông tin"
        }else if newpassString != confNewPassString {
            return "Mật khẩu mới và xác nhận mật khẩu phải trùng nhau"
        }else{
            return ""
        }
    }
    
    @IBAction func updateBtnTapAction(_ sender: Any) {
        if validateData() == "" {
            errLbl.isHidden = true
            requestChangePassword()
        }else{
            errLbl.isHidden = false
            errLbl.text = validateData()
        }
    }
    
    func requestChangePassword() {
        Until.showLoading()
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        
        var userEntity = UserEntity()
        if users.count > 0 {
             userEntity = users.first!
        }
        
        let param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "Email": userEntity.email,
            "OldPassWord": DataEncryption.getMD5(from: curentPass.text),
            "NewPassWord": DataEncryption.getMD5(from: newPass.text)
        ]
        
        
        Alamofire.request(CHANGE_PASSWORD, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    let alert = UIAlertController(title: "Thông báo", message: "Cập nhật mật khẩu thành công.", preferredStyle: .alert)
                    let OkeAction: UIAlertAction = UIAlertAction(title: "Đóng", style: .cancel) { action -> Void in
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(OkeAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }else if status == 404 {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Mật khẩu cũ không đúng, vui lòng thử lại.", cancelBtnTitle: "Đóng")
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }
    }
    
    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
