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
    var listBooking = BookingEntity()
    var checkInvoice : CheckInvoiceEntity!
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
        
        let fontBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
        let fontWithColor = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName: UIColor.init(netHex: 0x878787)]
        
        let myAttrString = NSMutableAttributedString(string: "\(listService[0].priceService)", attributes: fontBold)
        myAttrString.append(NSAttributedString(string: "(giá tạm tính)", attributes: fontWithColor))
        lbProvisionalPrice.attributedText = myAttrString

        
        lbName.text = name
        lbHistoryCode.text = String(listCheckin.patientHistory)
        lbNumberWait.text = String(listCheckin.sequence)
        lbAdress.text = listService[0].roomName
        lbSickName.text = listService[0].name
        lbExamDate.text = String().convertTimeStampWithDateFormat(timeStamp: dateExam, dateFormat: "dd/MM/YYYY")
        
        let image = Until.generateBarcode(from: "\(listCheckin.patientHistory)")
        imgBarCode.image = image
    }
    
        //MARK: Notificaiton
   
    @IBAction func btnShowBill(_ sender: Any) {
        requesCheckinVoice()
    }
    
    func requesCheckinVoice(){
        let Param : [String : Any] = [
            "PatientHistoryId" : listCheckin.patientHistory
        ]
        Alamofire.request(CHECKIN_VOICE, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        self.checkInvoice = CheckInvoiceEntity.init(dictionary: jsonData)
                        if self.checkInvoice.amount != 0 {
                            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Mã hoá đơn của bạn : \(self.checkInvoice.invoiceNo) \n Số tiền đóng thực tế : \(self.checkInvoice.amount)", cancelBtnTitle: "Đóng")
                        }else{
                            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Hiện tại chưa thanh toán! \n Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                        }
                        
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
    //MARK: delegate
    
    
   
    
}
