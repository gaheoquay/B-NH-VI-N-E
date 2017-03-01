//
//  DetailsFileUsersViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 28/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DetailsFileUsersViewController: UIViewController {
    
    
    @IBOutlet weak var lbHistoryCode: UILabel!
    @IBOutlet weak var lbNumberWait: UILabel!
    @IBOutlet weak var lbAdress: UILabel!
    @IBOutlet weak var lbSickName: UILabel!
    @IBOutlet weak var lbProvisionalPrice: UILabel!
    @IBOutlet weak var lbExamDate: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var viewBarCode: UIView!
    @IBOutlet weak var imgBarCode: UIImageView!
    
    var listCheckin = CheckInResultEntity()
    var listBooking = BookingEntity()
    var name = ""
    var dateExam: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
        
    func setupView(){
        
        for item in listService {
            if listBooking.serviceId == String(item.serviceId) {
                lbSickName.text = item.name
                lbProvisionalPrice.text = String(item.priceService)
                lbAdress.text = item.roomName
            }
        }
        
        lbName.text = name
        lbHistoryCode.text = String(listCheckin.patientHistory)
        lbNumberWait.text = String(listCheckin.sequence)
        lbExamDate.text = String().convertTimeStampWithDateFormat(timeStamp: dateExam, dateFormat: "dd/MM/YYYY")
        
        let image = Until.generateBarcode(from: "\(listCheckin.patientHistory)")
        imgBarCode.image = image
    }
    
        //MARK: Notificaiton
   
    @IBAction func btnShowBill(_ sender: Any) {
        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Hiện bạn chưa thanh toán! \n Xin vui lòng thử lại sau", cancelBtnTitle: "Đóng")
    }
    
   
    
}
