//
//  PolicyAndRuleViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 2/7/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class PolicyAndRuleViewController: BaseViewController {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var webView: UIWebView!
    var isPolicy = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        getPolicyAndRuleFromServer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isPolicy {
            titleLb.text = "Chính sách riêng tư"
            Until.sendAndSetTracer(value: POLICIES)
        }else{
            titleLb.text = "Điều khoản sử dụng"
            Until.sendAndSetTracer(value: TERM)
        }
    }

    func getPolicyAndRuleFromServer(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            Until.showLoading()
            Alamofire.request(POLICY_RULE, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            if self.isPolicy {
                                let policy = jsonData["Policy"] as! String
                                self.webView.loadHTMLString(policy, baseURL: nil)
                                
                            }else{
                                let condition = jsonData["Condition"] as! String
                                self.webView.loadHTMLString(condition, baseURL: nil)
                            }
                        }
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
    
    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
