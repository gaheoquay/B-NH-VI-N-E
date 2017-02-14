//
//  PolicyAndRuleViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 2/7/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class PolicyAndRuleViewController: UIViewController {

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
        Until.showLoading()
        Alamofire.request(POLICY_RULE, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
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
        
    }
    
    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
