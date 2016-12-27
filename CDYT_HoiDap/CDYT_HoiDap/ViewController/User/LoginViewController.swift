//
//  LoginViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailNickTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var errLb: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI(){
        loginBtn.layer.cornerRadius = 5
        loginBtn.clipsToBounds = true
        
        registerBtn.layer.cornerRadius = 5
        registerBtn.clipsToBounds = true
    }
    
    func validateDataLogin() -> String{
        let emailNickString = emailNickTxt.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let passString = passTxt.text
        
        if emailNickString == "" {
            emailNickTxt.becomeFirstResponder()
            return "Vui lòng điền email hoặc tên đăng nhập"
        }else if passString == "" {
            passTxt.becomeFirstResponder()
            return "Vui lòng nhập mật khẩu của bạn"
        }else{
            return ""
        }
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        if validateDataLogin() == "" {
            errLb.isHidden = true
            requestLogin()
        }else{
            errLb.isHidden = false
            errLb.text = validateDataLogin()
        }
    }

    func requestLogin(){
        
        let emailString = emailNickTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let passString = passTxt.text
        
        let loginParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "NicknameOrEmail": emailString!,
            "Password": DataEncryption.getMD5(from: passString)
        ]
        
        print(JSON.init(loginParam))
        
        Until.showLoading()
        Alamofire.request(LOGIN_EMAIL_NICKNAME, method: .post, parameters: loginParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        let reaml = try! Realm()
                        let entity = UserEntity.initWithDictionary(dictionary: jsonData)
                        
                        try! reaml.write {
                            reaml.add(entity, update: true)
                        }
                    }
                }else if status == 400 {
                    UIAlertController().showAlertWith(title: "Thông báo", message: "Email/Tên đăng nhập và mật khẩu không đúng, vui lòng thử lại.", cancelBtnTitle: "Đóng")
                }else{
                    UIAlertController().showAlertWith(title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }
    }
    
    @IBAction func forgotPassBtnAction(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UpdateInfoViewController") as! UpdateInfoViewController
        self.navigationController?.pushViewController(viewController, animated: true)

    }

    @IBAction func registerBtnAction(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
