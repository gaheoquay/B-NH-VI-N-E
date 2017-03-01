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
    var listService = [ServiceEntity]()
    var listCheckin = CheckInResultEntity()
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
        lbName.text = name
        lbHistoryCode.text = String(listCheckin.patientHistory)
        lbNumberWait.text = String(listCheckin.sequence)
        lbAdress.text = listService[0].roomName
        lbSickName.text = listService[0].name
        lbProvisionalPrice.text = "\(listService[0].priceService)"
        lbExamDate.text = String().convertTimeStampWithDateFormat(timeStamp: dateExam, dateFormat: "dd/MM/YYYY")
        
        let image = Until.generateBarcode(from: "\(listCheckin.patientHistory)")
        imgBarCode.image = image
    }
    
        //MARK: Notificaiton
   
    @IBAction func btnShowBill(_ sender: Any) {
        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Hiện bạn chưa thanh toán! \n Xin vui lòng thử lại sau", cancelBtnTitle: "Đóng")
    }
    
}
