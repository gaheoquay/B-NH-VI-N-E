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
    
  @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    var cannotBack = false
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: LOGIN)
    }
    
    func setupUI(){
      if cannotBack {
        btnBack.isHidden = true
      }else{
        btnBack.isHidden = false
      }
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
        
        let uuid = NSUUID().uuidString
      var token = ""
      if let value = UserDefaults.standard.object(forKey: NOTIFICATION_TOKEN) as? String {
        token = value
      }
        let device : [String : Any] = [
            "OS": 0,
            "DeviceId": uuid,
            "Token": token
        ]
        
        let loginParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "NicknameOrEmail": emailString!,
            "Password": DataEncryption.getMD5(from: passString),
            "Device": device
        ]
        
        
      
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
                          Until.initSendBird()
                          NotificationCenter.default.post(name: NSNotification.Name(rawValue: LOGIN_SUCCESS), object: nil)
                          _ = self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                        self.getListNotification()
                    }
                }else if status == 400 {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Email/Tên đăng nhập và mật khẩu không đúng, vui lòng thử lại.", cancelBtnTitle: "Đóng")
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }
    }
    
    
    func getListNotification(){
        
        let hotParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "Page": 1,
            "Size": 20,
            "RequestedUserId" : Until.getCurrentId()
        ]
        
        Alamofire.request(GET_LIST_NOTIFICATION, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! [NSDictionary]
                        listNotification.removeAll()
                        for item in jsonData {
                            let entity = ListNotificationEntity.initWithDict(dictionary: item)
                            listNotification.append(entity)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func forgotPassBtnAction(_ sender: Any) {        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func registerBtnAction(_ sender: Any) {
      let viewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
      self.navigationController?.pushViewController(viewController, animated: true)
    }
  @IBAction func actionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
