//
//  DetaiAnalysisViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DetaiAnalysisViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var lbPantentHistory: UILabel!
    @IBOutlet weak var imgBarcode: UIImageView!
    @IBOutlet weak var tbListAnalysisCode: UITableView!
    @IBOutlet weak var lbTotalPrice: UILabel!
    @IBOutlet weak var lbSurCharge: UILabel!
    @IBOutlet weak var lbAdress: UILabel!
    @IBOutlet weak var tbListService: UITableView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbHour: UILabel!
    @IBOutlet weak var heightTbService: NSLayoutConstraint!
    @IBOutlet weak var heightTbAnalysis: NSLayoutConstraint!
    @IBOutlet weak var heightViewTop: NSLayoutConstraint!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var marginBottomTbAnalysis: NSLayoutConstraint!
    @IBOutlet weak var viewBill: UIView!
    
    var booKing = BookingEntity()
    var listDetailBooKing = AllUserEntity()
    var adress = ""
    var heigtForRow = 0
    var listServices = [ServicesEntity]()       // Kham tai nha and xet nghiem
    var listPack = [PackEntity]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestBookingDetail()
    }
    
    func setupUI(){
        var b: CGFloat = 0
        if booKing.status == 2 {
            for item in listDetailBooKing.listMedicalGroups {
                let a = item.listMedicalTests.count * 40  // chieu cao cua 1 cell
                heigtForRow = heigtForRow + a
            }
            b = CGFloat(heigtForRow)
            let c = listDetailBooKing.listMedicalGroups.count * 30 // chieu cao section
            let d = b + CGFloat(c)
            heightTbAnalysis.constant = d
            viewTop.isHidden = false
            heightViewTop.constant = 169 + heightTbAnalysis.constant
            viewBill.isHidden = true
            lbTotalPrice.isHidden = true
            lbSurCharge.isHidden = true
            marginBottomTbAnalysis.constant = 0
        }else if booKing.status == 3 || booKing.status == 4 || booKing.status == 5{
            for item in listDetailBooKing.listMedicalGroups {
                let a = item.listMedicalTests.count * 40  // chieu cao cua 1 cell
                heigtForRow = heigtForRow + a
            }
            b = CGFloat(heigtForRow)
            let c = listDetailBooKing.listMedicalGroups.count * 30 // chieu cao section
            let d = b + CGFloat(c)
            heightTbAnalysis.constant = d
            viewTop.isHidden = false
            heightViewTop.constant = 169 + 96 + heightTbAnalysis.constant
            viewBill.isHidden = false
            lbTotalPrice.isHidden = false
            lbSurCharge.isHidden = false
            marginBottomTbAnalysis.constant = 96
        }else {
            viewTop.isHidden = true
            heightViewTop.constant = 0
        }
        
        tbListService.register(UINib.init(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        tbListAnalysisCode.register(UINib.init(nibName: "CodeFormAnalysisCell", bundle: nil), forCellReuseIdentifier: "CodeFormAnalysisCell")
        tbListService.register(UINib.init(nibName: "TotalPriceCell", bundle: nil), forCellReuseIdentifier: "TotalPriceCell")
        tbListService.delegate = self
        tbListService.dataSource = self
        tbListAnalysisCode.delegate = self
        tbListAnalysisCode.dataSource = self
        if booKing.status == 3 || booKing.status == 4 || booKing.status == 5 {
            heightTbService.constant = CGFloat(60 * (listServices.count + listPack.count) - 2)
        }else {
            heightTbService.constant = CGFloat(60 * (listServices.count + listPack.count) - 2) + 90
        }
        lbDate.text = String().convertTimeStampWithDateFormat(timeStamp: booKing.bookingDate / 1000, dateFormat: "dd/MM/YYYY")
        lbHour.text = String().convertTimeStampWithDateFormat(timeStamp: booKing.bookingDate / 1000, dateFormat: "HH:mz ")
        lbPantentHistory.text = String(listDetailBooKing.patientHistory.hisPatientHistoryID)
        let image = Until.generateBarcode(from: "\(listDetailBooKing.patientHistory.hisPatientHistoryID)")
        imgBarcode.image = image
        
        lbAdress.text = adress
        
        let fontWithColor = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor.init(netHex: 0x7ED321)]
        let myAttrString = NSMutableAttributedString(string: "Tổng thu: ")
        myAttrString.append(NSAttributedString(string: "\(String().replaceNSnumber(doublePrice: listDetailBooKing.totalMoney))đ", attributes: fontWithColor))
        lbTotalPrice.attributedText = myAttrString
        
        let myAttrStringSur = NSMutableAttributedString(string: "Đã bao gồm phụ thu: ")
        myAttrStringSur.append(NSAttributedString(string: "\(String().replaceNSnumber(doublePrice: listDetailBooKing.booking.money))đ", attributes: fontWithColor))
        lbSurCharge.attributedText = myAttrStringSur
        view.layoutIfNeeded()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tbListService {
            return 3
        }else {
            return listDetailBooKing.listMedicalGroups.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tbListService {
            if section == 2 {
                return 30
            }else {
                return 0
            }
        }else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.tbListAnalysisCode {
            return listDetailBooKing.listMedicalGroups[section].medicalTestGroup.hisServiceMedicTestGroupID
        }else {
            if section == 2 {
                return "Tổng giá dịch vụ tạm tính"
            }else {
                return ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tbListService {
            if section == 0 {
                return listPack.count
            }else if section == 1 {
                return listServices.count
            }else {
                return 1
            }
        }else{
            return listDetailBooKing.listMedicalGroups[section].listMedicalTests.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tbListService {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell") as! ServiceCell
            if indexPath.section == 0 {
                if listPack.count > 0 {
                    cell.setDataPac(entity: listPack[indexPath.row])
                }
            }else if indexPath.section == 1 {
                if listServices.count > 0 {
                    cell.setDataSer(entity: listServices[indexPath.row])
                }
            }else {
                var pricePack: Double = 0
                var priceSer : Double = 0
                var surChange: Double  = 0
                for item in listPack {
                    let a = item.pricePackage
                    pricePack = pricePack + a
                }
                for item in listServices {
                    let a = item.priceService
                    priceSer = priceSer + a
                }
                
                if pricePack + priceSer < 200000.0 {
                    surChange = 100000.0
                }else {
                    surChange = 0
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "TotalPriceCell") as! TotalPriceCell
                cell.lbTotalPrice.text = "Tổng thu: \(String().replaceNSnumber(doublePrice: (pricePack + priceSer)))đ"
                cell.lbSurChange.text = "Phụ thu: \(String().replaceNSnumber(doublePrice: surChange))đ"
                return cell
            }
            return cell
        }else {
            let cellMedical = tableView.dequeueReusableCell(withIdentifier: "CodeFormAnalysisCell") as! CodeFormAnalysisCell
            cellMedical.setDataExam(entity: listDetailBooKing.listMedicalGroups[indexPath.section].listMedicalTests[indexPath.row])
            return cellMedical
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tbListService {
            if indexPath.section == 2 {
                return 60
            }else {
                return 60
            }
        }else {
            return UITableViewAutomaticDimension
        }
    }
    
    func requestBookingDetail(){
        let Param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "BookingRecordId" : booKing.id
        ]
        print(Param)
        Until.showLoading()
        Alamofire.request(GET_BOOKING_RECORD, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        self.listDetailBooKing = AllUserEntity.init(dictionary: jsonData)
                    }
                    self.tbListService.reloadData()
                    self.tbListAnalysisCode.reloadData()
                }else{
                }
            }
            else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            self.setupUI()
            Until.hideLoading()
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
