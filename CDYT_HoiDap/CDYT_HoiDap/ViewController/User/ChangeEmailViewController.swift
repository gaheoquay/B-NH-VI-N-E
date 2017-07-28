//
//  ChangeEmailViewController.swift
//  CDYT_HoiDap
//
//  Created by Tuan Vu on 7/25/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ChangeEmailViewController: BaseViewController {

    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let realm = try Realm()
            if let user = realm.objects(UserEntity.self).first {
                txtEmail.text = user.email
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    @IBAction func actionChangeEmail(_ sender: Any) {
        if !Until.isValidEmail(email: txtEmail.text!) {
            UIAlertController().showAlertWith(vc: self, title: "", message: "Định dạng email không đúng.", cancelBtnTitle: "Đồng ý")
            return
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let param = [
                "AccountId": Until.getCurrentId(),
                "Email": txtEmail.text ?? ""
            ] as [String : Any]
            Until.showLoading()
            Alamofire.request(UPDATE_EMAIL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON(completionHandler: { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        UIAlertController().showAlertWith(vc: self, title: "", message: "Thông tin xác nhận đã được gửi về email mới của bạn. Vui lòng đăng nhập email để xác nhận!", cancelBtnTitle: "Đồng ý")
                        _ = self.navigationController?.popViewController(animated: true)
                    } else if status == 409 {
                        UIAlertController().showAlertWith(vc: self, title: "", message: "Email này đã có người dùng.", cancelBtnTitle: "Đồng ý")
                    }
                }
                Until.hideLoading()
            })
        } catch let error as NSError {
            print(error)
        }
    }

    @IBAction func actionBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
