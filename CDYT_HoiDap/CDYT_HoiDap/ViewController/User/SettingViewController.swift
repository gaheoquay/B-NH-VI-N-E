//
//  SettingViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var versionLbl: UILabel!
    @IBOutlet weak var updateVersionBtn: UIButton!
    @IBOutlet weak var rateAppBtn: UIButton!
    @IBOutlet weak var feedbackBugBtn: UIButton!
    @IBOutlet weak var testVersionLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateVersionBtn.layer.cornerRadius = 5
        updateVersionBtn.layer.layoutIfNeeded()
        rateAppBtn.layer.cornerRadius = 5
        rateAppBtn.layer.layoutIfNeeded()
        feedbackBugBtn.layer.cornerRadius = 5
        feedbackBugBtn.layer.layoutIfNeeded()
        
        setVersionLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: SETTING)

    }
    func setVersionLabel() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLbl.text = "\(version)"
        }
        testVersionLb.text = "Phiên bản thử nghiệm"
    }
    
    @IBAction func chinhSachTapBtn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PolicyAndRuleViewController") as! PolicyAndRuleViewController
        vc.isPolicy = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dieuKhoanTapBtn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PolicyAndRuleViewController") as! PolicyAndRuleViewController
        vc.isPolicy = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func chiaSeTapBtn(_ sender: Any) {
        let linkApp = "Ứng dụng hỏi đáp y tế: "
        let vc = UIActivityViewController(activityItems: [linkApp], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func updateVersionTapBtn(_ sender: Any) {
        UIApplication.shared.openURL(URL.init(string: "https://itunes.apple.com/vn/app/cong-ong-y-te/id1128162959?mt=8")!)
    }
    
    @IBAction func rateAppTapBtn(_ sender: Any) {
        UIApplication.shared.openURL(URL.init(string: "https://itunes.apple.com/vn/app/cong-ong-y-te/id1128162959?mt=8")!)
    }
    
    @IBAction func feedbackTapAction(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let emailTitle = "Góp ý ứng dụng Hỏi đáp Y Tế"
            let toRecipents = ["isorasoftvn@gmail.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.setSubject(emailTitle)
            mc.setToRecipients(toRecipents)
            mc.mailComposeDelegate = self
            self.present(mc, animated: true, completion: nil)
        }else{
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng cài đặt tài khoản email của bạn", cancelBtnTitle: "Đóng")
        }
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
        case MFMailComposeResult.saved:
            print("Mail saved")
        case MFMailComposeResult.sent:
            print("Mail sent")
        case MFMailComposeResult.failed:
//            print("Mail sent failure: \(error?.localizedDescription)")
            UIAlertController().showAlertWith(vc: self, title: "Lỗi", message: (error?.localizedDescription)!, cancelBtnTitle: "Đóng")

        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
