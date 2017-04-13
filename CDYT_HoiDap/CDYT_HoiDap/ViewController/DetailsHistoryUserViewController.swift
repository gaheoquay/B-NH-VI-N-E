//
//  DetailsHistoryUserViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 07/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DetailsHistoryUserViewController: UIViewController {
    
    
    @IBOutlet weak var lbPatienHistory: UILabel!
    @IBOutlet weak var btnDianostic: UIButton!
    @IBOutlet weak var contentDianostic: UILabel!
    @IBOutlet weak var btnMount: UIButton!
    @IBOutlet weak var contentMount: UILabel!
    @IBOutlet weak var btnDeseaseProgress: UIButton!
    @IBOutlet weak var contentDeaseProgress: UILabel!
    @IBOutlet weak var btnDiseaseDiagnostic: UIButton!
    @IBOutlet weak var contentDiseaseDiagnostic: UILabel!
    @IBOutlet weak var btnDianosisDiffereent: UIButton!
    @IBOutlet weak var contentDianosisDiffreent: UILabel!
    @IBOutlet weak var btnAdvice: UIButton!
    @IBOutlet weak var contentAdvice: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var marginBottomDianostic: NSLayoutConstraint!
    @IBOutlet weak var marginBottomMount: NSLayoutConstraint!
    @IBOutlet weak var marginBottomDeseaseProgress: NSLayoutConstraint!
    @IBOutlet weak var marginBottomDiseaseDiagnostic: NSLayoutConstraint!
    @IBOutlet weak var marginBottomDianosisDiffereent: NSLayoutConstraint!
    @IBOutlet weak var marginBottomAdvice: NSLayoutConstraint!
    @IBOutlet weak var tbPrescription: UITableView!
    @IBOutlet weak var viewPrescription: UIView!
    @IBOutlet weak var heightPrescription: NSLayoutConstraint!
    @IBOutlet weak var withContent: NSLayoutConstraint!
    @IBOutlet weak var viewStt: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewQuantity: UIView!
    
    
    var listBooking = BookingEntity()
    var userResult = ResultUserEntity()
    var date = ""
    var isCheckSelect = false
    var isCheckSeletc1 = false
    var isCheckSeletc2 = false
    var isCheckSeletc3 = false
    var isCheckSeletc4 = false
    var isCheckSeletc5 = false
    var heigntTable: CGFloat = 0 // chieu cao table

    //test
    var array = ["the amount or number of a material or immaterial thing not usually estimated by spatial measurement", "immaterial thing not usually estimated by spatial measurement","asdasdsad","Good command of reading English (at least to fully understand this post ☺).• At least ","Passionate, high responsibility, high professional attitude."]
    
    //end test


    override func viewDidLoad() {
        super.viewDidLoad()
        requestFinishCheckup()
        setUpView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: SetupView
    
    func setUpView(){
        lbTitle.text = date
        marginBottomDianostic.constant = 8
        marginBottomMount.constant = 8
        marginBottomAdvice.constant = 8
        marginBottomDiseaseDiagnostic.constant = 8
        marginBottomDianosisDiffereent.constant = 8
        marginBottomDeseaseProgress.constant = 8
        contentDianostic.isHidden = true
        contentMount.isHidden = true
        contentDeaseProgress.isHidden = true
        contentDiseaseDiagnostic.isHidden = true
        contentDianosisDiffreent.isHidden = true
        contentAdvice.isHidden = true
        lbPatienHistory.text = String(listBooking.checkInResult.patientHistory)
        tbPrescription.register(UINib.init(nibName: "PrescriptionCell", bundle: nil), forCellReuseIdentifier: "PrescriptionCell")
        tbPrescription.delegate = self
        tbPrescription.dataSource = self
        tbPrescription.estimatedRowHeight = 999
        tbPrescription.rowHeight = UITableViewAutomaticDimension
        
        viewStt.layer.borderColor = UIColor.brown.cgColor
        viewStt.layer.borderWidth = 0.5
        viewName.layer.borderColor = UIColor.brown.cgColor
        viewName.layer.borderWidth = 0.5
        viewContent.layer.borderColor = UIColor.brown.cgColor
        viewContent.layer.borderWidth = 0.5
        viewQuantity.layer.borderColor = UIColor.brown.cgColor
        viewQuantity.layer.borderWidth = 0.5
        
        for item in array {
            let a = item.heightWithConstrainedWidth(width: (UIScreen.main.bounds.size.width / 2) - (UIScreen.main.bounds.size.width / 6 ), font: .systemFont(ofSize: 14)) + 16 // chieu cao cua cell
            heigntTable = heigntTable + a
        }
        heightPrescription.constant = heigntTable + 47
    }
    
    //MARK: reuqest API
    func requestFinishCheckup(){
        let Param : [String : Any] = [
            "PatientHistoryId" : listBooking.checkInResult.patientHistory,
            "BookingId" : listBooking.id
        ]
        print(Param)
        Alamofire.request(FINISH_CHECKUP, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        self.userResult = ResultUserEntity.init(dictionary: jsonData as! [String : Any])
                    }
                    self.contentDiseaseDiagnostic.text = self.userResult.diseaseDiagnostic_ID
                    self.contentDianostic.text = self.userResult.firt_diagnostic
                    self.contentMount.text = self.userResult.prognosis
                    self.contentDeaseProgress.text = self.userResult.diseaseProgress
                    self.contentDianosisDiffreent.text = self.userResult.other_DiseaseDiagnostic_ID
                    self.contentAdvice.text = self.userResult.doctorAdvice_ID
                }
                else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
    }
    
    
    //MARK: Button
    
    @IBAction func btnDianosticFirst(_ sender: Any) {
        if isCheckSelect == false {
        contentDianostic.isHidden = false
        isCheckSelect = true
        marginBottomDianostic.constant = 16 + contentDianostic.frame.size.height
        }else {
        isCheckSelect = false
        marginBottomDianostic.constant = 8
        contentDianostic.isHidden = true
        }
    }
    
    @IBAction func btnMount(_ sender: Any) {
        if isCheckSeletc1 == false {
            contentMount.isHidden = false
            isCheckSeletc1 = true
            marginBottomMount.constant = 16 + contentMount.frame.size.height
        }else {
            contentMount.isHidden = true
            isCheckSeletc1 = false
            marginBottomMount.constant = 8
        }

    }
    
    @IBAction func btnDeseaseProgress(_ sender: Any) {
        if isCheckSeletc2 == false {
            contentDeaseProgress.isHidden = false
            isCheckSeletc2 = true
            marginBottomDeseaseProgress.constant = 16 + contentDeaseProgress.frame.size.height
        }else {
            contentDeaseProgress.isHidden = true
            isCheckSeletc2 = false
            marginBottomDeseaseProgress.constant = 8
        }

    }
    
    @IBAction func btnDiseaseDiagnostic(_ sender: Any) {
        if isCheckSeletc3 == false {
            contentDiseaseDiagnostic.isHidden = false
            isCheckSeletc3 = true
            marginBottomDiseaseDiagnostic.constant = 16 + contentDiseaseDiagnostic.frame.size.height
        }else {
            contentDiseaseDiagnostic.isHidden = true
            isCheckSeletc3 = false
            marginBottomDiseaseDiagnostic.constant = 8
        }

    }
    
    @IBAction func btnDianosisDiffereent(_ sender: Any) {
        if isCheckSeletc4 == false {
            contentDianosisDiffreent.isHidden = false
            isCheckSeletc4 = true
            marginBottomDianosisDiffereent.constant = 16 + contentDianosisDiffreent.frame.size.height
        }else {
            contentDianosisDiffreent.isHidden = true
            isCheckSeletc4 = false
            marginBottomDianosisDiffereent.constant = 8
        }

    }
    
    @IBAction func btnAdvice(_ sender: Any) {
        if isCheckSeletc5 == false {
            contentAdvice.isHidden = false
            isCheckSeletc5 = true
            marginBottomAdvice.constant = 16 + contentAdvice.frame.size.height
        }else {
            contentAdvice.isHidden = true
            isCheckSeletc5 = false
            marginBottomAdvice.constant = 8
        }

    }
    
    @IBAction func btnBacks(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension DetailsHistoryUserViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionCell") as! PrescriptionCell
        cell.lbContent.text = array[indexPath.row]
        cell.setData()
        return cell
    }
    
    
}





















