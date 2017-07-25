//
//  LoginViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailNickTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var errLb: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.loginGmailSuccess), name: NSNotification.Name(rawValue: LOGIN_GMAIL_SUCCESS), object: nil)

        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: LOGIN)
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
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let passString = passTxt.text
            let uuid = NSUUID().uuidString
            let token = UserDefaults.standard.object(forKey: NOTIFICATION_TOKEN) as? String ?? ""
            let device : [String : Any] = [
                "OS": 0,
                "DeviceId": uuid,
                "Token": token
            ]
            
            let loginParam : [String : Any] = [
                "NicknameOrEmail": emailNickTxt.text!,
                "Password": DataEncryption.getMD5(from: passString),
                "Device": device
            ]
            
            Until.showLoading()
            Alamofire.request(LOGIN_EMAIL_NICKNAME, method: .post, parameters: loginParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let reaml = try! Realm()
                            let entity = UserEntity.initWithDictionary(dictionary: jsonData)
                            
                            try! reaml.write {
                                reaml.add(entity, update: true)
                                Until.initSendBird()
                                Until.getSchedule()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LOGIN_SUCCESS), object: nil)
                                _ = self.navigationController?.popToRootViewController(animated: true)
                            }
                            
                            self.getListNotification()
                        }
                    }else if status == 400 {
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Email/Tên đăng nhập và mật khẩu không đúng, vui lòng thử lại.", cancelBtnTitle: "Đóng")
                    }else if status == 409{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Tài khoản này đã bị khoá. Hãy liên hệ với quản trị viên để biết thông tin chi tiết!", cancelBtnTitle: "Đóng")
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
            }
            
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    func getListNotification(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let requestUrl = GET_LIST_NOTIFICATION_BY_PAGING + "?page=\(1)&size=\(20)"
            Alamofire.request(requestUrl, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let data = jsonData["Data"] as! [NSDictionary]
                            listNotification.removeAll()
                            for item in data {
                                let entity = NotificationNewEntity.init(dictionary: item)
                                listNotification.append(entity)
                            }
                        }
                    }
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }
    @IBAction func facebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.loginBehavior = LoginBehavior.native
        loginManager.logIn([ .publicProfile, .email, .userFriends ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error as NSError):
                print(error.description)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
                print("Logged in!")
                let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name"], tokenString: accessToken.authenticationToken, version: nil, httpMethod: "GET")
                req?.start(completionHandler: { (_, result, error) -> Void in
                    
                    if ((error) != nil)
                    {
                        print("Error: \(String(describing: error))")
                    }
                    else
                    {
                        let facebookData:[String: Any] = result as! [String: Any]
                        print(facebookData)
                        self.loginWithFacebook(facebookData: facebookData)
                        
                    }
                })
            default: break
            }
        }
    }
    
    @IBAction func loginWithGmail(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
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
    
    
}
// MARK: Facebook login
extension LoginViewController {
    func loginWithFacebook(facebookData: [String: Any]) {
        guard let email = facebookData["email"] as? String, let socialId = facebookData["id"] as? String, let fullName = facebookData["name"] as? String else {
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Tài khoản của bạn phải có email.", cancelBtnTitle: "Đồng ý")
            return
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let uuid = NSUUID().uuidString
            let token = UserDefaults.standard.object(forKey: NOTIFICATION_TOKEN) as? String ?? ""
            let device : [String : Any] = [
                "OS": 0,
                "DeviceId": uuid,
                "Token": token
            ]
            
            let loginParam : [String : Any] = [
                "SocialType": 1,
                "SocialId": socialId,
                "FullName": fullName,
                "Email": email,
                "Device": device
            ]
            Alamofire.request(LOGIN_WITH_SOCIAL, method: .post, parameters: loginParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let reaml = try! Realm()
                            let entity = UserEntity.initWithDictionary(dictionary: jsonData)
                            
                            try! reaml.write {
                                reaml.add(entity, update: true)
                                Until.initSendBird()
                                Until.getSchedule()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LOGIN_SUCCESS), object: nil)
                                _ = self.navigationController?.popToRootViewController(animated: true)
                            }
                            self.getListNotification()
                        }
                    }else if status == 400 {
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Email/Tên đăng nhập và mật khẩu không đúng, vui lòng thử lại.", cancelBtnTitle: "Đóng")
                    }else if status == 409{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Tài khoản này đã bị khoá. Hãy liên hệ với quản trị viên để biết thông tin chi tiết!", cancelBtnTitle: "Đóng")
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
            }

        } catch let error as NSError {
            print(error)
        }
    }
}
extension LoginViewController: GIDSignInUIDelegate {
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    func loginGmailSuccess(){
        _ = self.navigationController?.popToRootViewController(animated: true)
        self.getListNotification()
    }
}
