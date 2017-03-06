//
//  DetailResultUserViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 02/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DetailResultUserViewController: UIViewController {

    @IBOutlet weak var lbCodeHospital: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    var listBooking = BookingEntity()
    var listReult = ResultUserEntity()
    var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        lbCodeHospital.text = String(listBooking.checkInResult.patientHistory)
        requestFinishCheckup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupTable(){
        lbDate.text = date
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
                        self.listReult = ResultUserEntity.init(dictionary: jsonData as! [String : Any])
                    }
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
    @IBAction func btnInitialDiagnosis(_ sender: Any) {
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "DetailSickViewController") as! DetailSickViewController
        viewcontroller.titleUser = "Chuẩn đoán ban đầu"
        viewcontroller.content = listReult.firt_diagnostic
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    @IBAction func btnAmount(_ sender: Any) {
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "DetailSickViewController") as! DetailSickViewController
        viewcontroller.titleUser = "Tiên lượng"
        viewcontroller.content = listReult.prognosis
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    @IBAction func btnEvolutionSick(_ sender: Any) {
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "DetailSickViewController") as! DetailSickViewController
        viewcontroller.titleUser = "Diễn biến bệnh"
        viewcontroller.content = listReult.diseaseProgress
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    @IBAction func btnDiagnosisSick(_ sender: Any) {
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "DetailSickViewController") as! DetailSickViewController
        viewcontroller.titleUser = "Chuẩn đoán bệnh"
        viewcontroller.content = listReult.diseaseDiagnostic_ID
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    @IBAction func btnAdvice(_ sender: Any) {
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "DetailSickViewController") as! DetailSickViewController
        viewcontroller.titleUser = "Lời dặn"
        viewcontroller.content = listReult.doctorAdvice_ID
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    @IBAction func btnDianosisDiffreent(_ sender: Any) {
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "DetailSickViewController") as! DetailSickViewController
        viewcontroller.titleUser = "Chuẩn đoán khác"
        viewcontroller.content = listReult.other_DiseaseDiagnostic_ID
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
   

}
