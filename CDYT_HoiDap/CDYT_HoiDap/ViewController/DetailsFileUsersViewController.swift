//
//  DetailsFileUsersViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 28/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

protocol DetailsFileUsersViewControllerDelegate {
    func reloadDataExam()
}


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
    @IBOutlet weak var viewParameter: UIView!
    @IBOutlet weak var viewHeaderParameter: UIView!
    @IBOutlet weak var viewBill: UIView!
    @IBOutlet weak var heightViewHeader: NSLayoutConstraint!
    @IBOutlet weak var heightViewParam: NSLayoutConstraint!
    @IBOutlet weak var heightViewBill: NSLayoutConstraint!
    @IBOutlet weak var lbHour: UILabel!
    @IBOutlet weak var viewHour: UIView!
    
    var listService = [ServiceEntity]()
    var checkInResult = CheckInResultEntity()
    var booKingRecord = BookingEntity() // BookingRecord
    var checkInvoice : CheckInvoiceEntity!
    var name = ""
    var dateExam: Double = 0
    var delegate: DetailsFileUsersViewControllerDelegate?

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
        delegate?.reloadDataExam()
    }
    
    
    func setupView(){
        
        let serVice = listService.filter { (serViceEntiy) -> Bool in
             String(serViceEntiy.serviceId) == booKingRecord.serviceId
        }
        
        
        let fontBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
        let fontWithColor = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName: UIColor.init(netHex: 0x878787)]
        
        
        let price = String().replaceNSnumber(doublePrice: serVice[0].priceService)
        
        
        let myAttrString = NSMutableAttributedString(string: "\(price) đ", attributes: fontBold)
        myAttrString.append(NSAttributedString(string: " (giá tạm tính)", attributes: fontWithColor))
        lbProvisionalPrice.attributedText = myAttrString
        
        
        lbExamDate.text = String().convertTimeStampWithDateFormat(timeStamp: dateExam, dateFormat: "dd/MM/YYYY")
        lbName.text = name
        lbSickName.text = serVice[0].name
        lbAdress.text = serVice[0].roomName


        if booKingRecord.status == 0 {
            viewBarCode.isHidden = true
            viewParameter.isHidden = true
            viewBill.isHidden = true
            heightViewBill.constant = 0
            heightViewParam.constant = 0
            heightViewHeader.constant = 0
        }else {
            viewBarCode.isHidden = false
            viewParameter.isHidden = false
            viewBill.isHidden = false
            lbHistoryCode.text = String(checkInResult.patientHistory)
            lbNumberWait.text = String(checkInResult.sequence)
            let image = Until.generateBarcode(from: "\(checkInResult.patientHistory)")
            imgBarCode.image = image
        }
        
        
    }
    
        //MARK: Notificaiton
   
    @IBAction func btnShowBill(_ sender: Any) {
        requesCheckinVoice()
    }
    
    func requesCheckinVoice(){
        let Param : [String : Any] = [
            "PatientHistoryId" : checkInResult.patientHistory
        ]
        Alamofire.request(CHECKIN_VOICE, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        self.checkInvoice = CheckInvoiceEntity.init(dictionary: jsonData as! [String : Any])
                        if self.checkInvoice.amount != 0 {
                            let amount = String().replaceNSnumber(doublePrice: self.checkInvoice.amount)
                            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Mã hoá đơn của bạn : \(self.checkInvoice.invoiceNo) \n Số tiền đóng thực tế : \(amount)", cancelBtnTitle: "Đóng")
                            self.requestUpatePaymen()
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
    
    func requestUpatePaymen(){
        
                
        let payment = [
            "PatientHistory" : checkInvoice.patientHistory,
            "InvoiceNo" : checkInvoice.invoiceNo,
            "Amount" : checkInvoice.amount
        ] as [String : Any]
        
        let Param : [String : Any] = [
            "Auth" : Until.getAuthKey(),
            "PatientHistoryId" : checkInResult.patientHistory,
            "BookingId" : booKingRecord.id,
            "PaymentResult": payment
        ]
        print(Param)
        Alamofire.request(UPDATE_BOOKING_AFTER_PAYMEN, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    print("ok")
                }
                else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
    }
        
}
