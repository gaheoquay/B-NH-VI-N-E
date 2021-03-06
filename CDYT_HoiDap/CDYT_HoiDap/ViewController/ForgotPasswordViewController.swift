//
//  ForgotPasswordViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 1/9/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: FORGOT_PASS)
    }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func actionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  @IBAction func actionSend(_ sender: Any) {
        validateData()
  }
    
   func validateData(){
        let emailString = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    
        if emailString == "" {
            txtEmail.becomeFirstResponder()
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Email không được để trống", cancelBtnTitle: "Đóng")
        }else if !Until.isValidEmail(email: emailString!){
            txtEmail.becomeFirstResponder()
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không tìm thấy tài khoản với email bạn nhập!", cancelBtnTitle: "Đóng")
        }else {
            requestForgotPassword()
        }
    }
    
    func requestForgotPassword(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let hotParam : [String : Any] = [
                "Email": txtEmail.text!
            ]
            Until.showLoading()
            Alamofire.request(FOR_GOT_PASSWORD, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Mật khẩu mới của bạn đã được gửi về email đăng ký. Vui lòng kiểm tra lại", cancelBtnTitle: "Đóng")
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không tìm thấy tài khoản với email bạn nhập!", cancelBtnTitle: "Đóng")
                    }
                    Until.hideLoading()
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
  //MARK: Outlet
  @IBOutlet weak var txtEmail: UITextField!
  
}
