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
        if booKing.status == 2 {
            viewTop.isHidden = false
            heightViewTop.constant = 265 + CGFloat(60 * (listServices.count + listPack.count) - 2)
            viewBill.isHidden = true
            lbTotalPrice.isHidden = true
            lbSurCharge.isHidden = true
            marginBottomTbAnalysis.constant = 0
        }else if booKing.status == 3 || booKing.status == 4 || booKing.status == 5{
            viewTop.isHidden = false
            heightViewTop.constant = 265 + CGFloat(60 * (listServices.count + listPack.count) - 2)
            viewBill.isHidden = false
            lbTotalPrice.isHidden = false
            lbSurCharge.isHidden = false
            marginBottomTbAnalysis.constant = 96
        }else {
            viewTop.isHidden = true
            heightViewTop.constant = 0
        }
        
        tbListService.register(UINib.init(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        tbListAnalysisCode.register(UINib.init(nibName: "MedicalCell", bundle: nil), forCellReuseIdentifier: "MedicalCell")
        tbListService.delegate = self
        tbListService.dataSource = self
        tbListAnalysisCode.delegate = self
        tbListAnalysisCode.dataSource = self
        heightTbService.constant = CGFloat(60 * (listServices.count + listPack.count) - 2)
        lbDate.text = String().convertTimeStampWithDateFormat(timeStamp: booKing.bookingDate / 1000, dateFormat: "dd/MM/YYYY")
        lbHour.text = String().convertTimeStampWithDateFormat(timeStamp: booKing.bookingDate / 1000, dateFormat: "hh:mm a")
        lbPantentHistory.text = String(listDetailBooKing.patientHistory.hisPatientHistoryID)
        let image = Until.generateBarcode(from: "\(listDetailBooKing.patientHistory.hisPatientHistoryID)")
        imgBarcode.image = image
        for item in listDetailBooKing.listMedicalGroups {
            let a = item.listMedicalTests.count * 55  // chieu cao cua 1 cell
            heigtForRow = heigtForRow + a
        }
        heightTbAnalysis.constant = CGFloat(heigtForRow)
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
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tbListService {
            if section == 0 {
                return listPack.count
            }else {
                return listServices.count
            }
        }else{
            return listDetailBooKing.listMedicalGroups.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tbListService {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell") as! ServiceCell
            if indexPath.section == 0 {
                if listPack.count > 0 {
                    cell.setDataPac(entity: listPack[indexPath.row])
                }
            }else {
                if listServices.count > 0 {
                    cell.setDataSer(entity: listServices[indexPath.row])
                }
            }
            return cell
        }else {
            let cellMedical = tableView.dequeueReusableCell(withIdentifier: "MedicalCell") as! MedicalCell
            cellMedical.indexPatchs = indexPath
            cellMedical.listMedical = self.listDetailBooKing.listMedicalGroups
            return cellMedical
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tbListService {
            return 60
        }else {
            return CGFloat(listDetailBooKing.listMedicalGroups[indexPath.row].listMedicalTests.count * 60)
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
