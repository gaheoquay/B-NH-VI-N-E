//
//  BookingCalenderController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 23/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol BookingCalenderControllerDelegate {
    func gotoService(status: Int)
    func gotoFile()
    func gotoExamSchudel()
    func gotoExamSchudelCheckin()
    func gotoExamSchudelAtHome()
}

class BookingCalenderController: UIViewController ,WYPopoverControllerDelegate,ServiceViewControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate{
    
    
    @IBOutlet weak var viewBookingHome: UIView!
    @IBOutlet weak var btnAlanysis: UIButton!
    @IBOutlet weak var btnSendBooking: UIButton!
    @IBOutlet weak var btnService: UIButton!
    @IBOutlet weak var btnBrifUser: UIButton!
    @IBOutlet weak var btnBookingDate: UIButton!
    @IBOutlet weak var heightViewBookingHome: NSLayoutConstraint!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtAdress: UITextField!
    @IBOutlet weak var txtNode: UITextField!
    @IBOutlet weak var btnChoiceDistric: UIButton!
    
    var popupViewController:WYPopoverController!
    var serviceEntity = ServiceEntity()
    var booKingEntity = BookingEntity()
    var dateBook: Double = Date().timeIntervalSince1970
    let currentDate = Date()
    var delegate: BookingCalenderControllerDelegate?
    var status = 0 // 0: Benh vien , 1: TAI NHA , 2 : XN tai nha
    var indexPatch = 0
    
    //test
    var listService = [ServicesEntity]()       // Kham tai nha and xet nghiem
    var listPack = [PackagesEntity]()
    var sumPack : Double = 0
    var sumService : Double = 0
    var checkPrice: Double = 200000
    var listDictric = [DistricHomeEntity]()
    let pickerViewDistric = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))

    //endtest
    
    var userBooking = BookingUserEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadBooking), name: Notification.Name.init(RELOAD_BOOKING), object: nil)
        setupUi()
        requestListDistrict()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btnService.setTitle("Danh sách dịch vụ", for: UIControlState.normal)
        self.serviceEntity = ServiceEntity()
        self.btnBrifUser.setTitle("Chọn hồ sơ người khám", for: UIControlState.normal)
        self.userBooking = BookingUserEntity()
    }
    
    func setupUi(){
        btnService.layer.borderWidth = 0
        btnBrifUser.layer.borderWidth = 0
        btnSendBooking.layer.cornerRadius = 5
        btnSendBooking.clipsToBounds = true
        btnBookingDate.setTitle("\(String().convertDatetoString(date: currentDate, dateFormat: "EEEE, dd/MM/YYYY "))", for: .normal)
        registerNotification()
        if status == 0 {
            viewBookingHome.isHidden = true
            heightViewBookingHome.constant = 0
            btnAlanysis.setTitle("Khám tại viện E", for: .normal)
        }else if status == 1{
            self.btnService.setTitle("Danh sách dịch vụ", for: UIControlState.normal)
            self.serviceEntity = ServiceEntity()
            viewBookingHome.isHidden = false
            heightViewBookingHome.constant = 370
            btnAlanysis.setTitle("Khám tại nhà", for: .normal)
        }else {
            self.btnService.setTitle("Danh sách dịch vụ", for: UIControlState.normal)
            self.serviceEntity = ServiceEntity()
            viewBookingHome.isHidden = false
            heightViewBookingHome.constant = 370
            btnAlanysis.setTitle("Xét nghiệm tại nhà", for: .normal)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func reloadBooking(){
        self.btnService.setTitle("Danh sách dịch vụ", for: UIControlState.normal)
        self.serviceEntity = ServiceEntity()
        self.btnBrifUser.setTitle("Chọn hồ sơ người khám", for: UIControlState.normal)
        self.userBooking = BookingUserEntity()
    }
    @IBAction func tapService(_ sender: Any) {
        delegate?.gotoService(status: status)
    }
    @IBAction func btnSelectFileUser(_ sender: Any) {
        delegate?.gotoFile()
    }
    
    @IBAction func btnSelectDateBooking(_ sender: Any) {
        self.view.endEditing(true)
        let date : UIDatePickerMode?
        if status == 0{
            date = UIDatePickerMode.date
        }
        else{
            date = UIDatePickerMode.dateAndTime
        }
        
        DatePickerDialog().show(title: "Chọn ngày khám", doneButtonTitle: "Xong", cancelButtonTitle: "Hủy", datePickerMode: date!) {
            (date) -> Void in
            if date != nil {
                if self.status == 0 {
                    self.btnBookingDate.setTitle("\(String().convertDatetoString(date: date as! Date, dateFormat: "EEEE, dd/MM/YYYY "))", for: .normal)
                }else {
                    self.btnBookingDate.setTitle("\(String().convertDatetoString(date: date as! Date, dateFormat: "EEEE, dd/MM/YYYY hh:mm" ))", for: .normal)
                }
                self.dateBook = (date?.timeIntervalSince1970)!
            }
        }
    }
    
    @IBAction func btnAlanysis(_ sender: Any) {
        if popupViewController == nil {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let popoverVC = mainStoryboard.instantiateViewController(withIdentifier: "ServiceViewController") as! ServiceViewController
            popoverVC.preferredContentSize = CGSize.init(width: UIScreen.main.bounds.size.width - 32, height: 220 )
            popoverVC.isModalInPopover = false
            popoverVC.delegate = self
            self.popupViewController = WYPopoverController(contentViewController: popoverVC)
            self.popupViewController.delegate = self
            self.popupViewController.wantsDefaultContentAppearance = false;
            self.popupViewController.presentPopover(from: CGRect.init(x: 0, y: 0, width: 0, height: 0), in: self.view, permittedArrowDirections: WYPopoverArrowDirection.none, animated: true, options: WYPopoverAnimationOptions.fadeWithScale, completion: nil)
        }
        
    }
    
    func popoverControllerDidDismissPopover(_ popoverController: WYPopoverController!) {
        if popupViewController != nil {
            popupViewController.delegate = nil
            popupViewController = nil
        }
    }
    
    func setIndexService(status: Int) {
        popupViewController.dismissPopover(animated: true)
        popupViewController.delegate = nil
        popupViewController = nil
        self.status = status
        setupUi()
    }
    
    @IBAction func btnChoiceDistric(_ sender: Any) {
        creatAlert(title: "Chọn quận huyện", picker: pickerViewDistric)
    }
    
    func creatAlert(title: String, picker: UIPickerView){
        let alertView = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alertView.view.addSubview(picker)
        
        picker.delegate = self
        picker.dataSource = self
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.btnChoiceDistric.setTitle("\(self.listDictric[self.indexPatch].name)", for: .normal)
        })
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listDictric.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listDictric[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.indexPatch = row
    }
    
    @IBAction func btnSendBooking(_ sender: Any) {
        if status == 0 {
            let fourty_today = currentDate.dateAt(hours: 16, minutes: 0, days : 0)
            let currentDateString = String().convertDatetoString(date: self.currentDate, dateFormat: "dd/MM/YYYY")
            let dateBookingString = String().convertTimeStampWithDateFormat(timeStamp: self.dateBook, dateFormat: "dd/MM/YYYY")
            if currentDateString == dateBookingString  {
                if currentDate > fourty_today {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không thể đặt lịch vào ngày này! Bệnh viện ngưng đặt lịch khám sau 16h hàng ngày và chủ nhật.", cancelBtnTitle: "Đóng")
                }else {
                    isvalidCheck()
                }
            }else {
                let date = Date(timeIntervalSince1970: dateBook)
                let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                let myComponents = myCalendar.components(.weekday, from: date)
                let bookingDay = myComponents.weekday
                if bookingDay == 1 {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không thể đặt lịch vào ngày này! Bệnh viện ngưng đặt lịch khám sau 16h hàng ngày và chủ nhật.", cancelBtnTitle: "Đóng")
                }else {
                    isvalidCheck()
                }
            }
        }else {
            isvalidCheck()
        }
    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(setDataListService(notification:)), name: NSNotification.Name(rawValue: GET_LIST_SERVICE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDataFileUser(notification:)), name: NSNotification.Name(rawValue: GET_LIST_FILE_USER), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDataListSer(notification:)), name: NSNotification.Name(rawValue: GET_LIST_SERIVCE_IN_HOME), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDataListPac(notification:)), name: NSNotification.Name(rawValue: GET_LIST_PACKAGE_IN_HOME), object: nil)
    }
    //MARK: Notificaiton
    func setDataListService(notification : Notification){
        if notification.object != nil {
            let listServ = notification.object as! ServiceEntity
            serviceEntity = listServ
            btnService.setTitle(listServ.name, for: .normal)
        }
    }
    func setDataFileUser(notification: Notification){
        if notification.object != nil {
            let fileUser = notification.object as! BookingUserEntity
            userBooking = fileUser
            btnBrifUser.setTitle(fileUser.profile.patientName, for: .normal)
        }
    }
    
    func setDataListSer(notification: Notification){
        if notification.object != nil {
            let listSer = notification.object as! [ServicesEntity]
            self.listService = listSer
            if listService.count > 0 {
                for item in listService {
                    sumService = sumService + item.priceService
                }
            }
            if listPack.count > 0 {
                btnService.setTitle(" \(listService.count + listPack.count) dịch vụ được chọn", for: .normal)
            }else {
                btnService.setTitle(" \(listService.count) dịch vụ được chọn", for: .normal)
            }
        }
    }
    
    func setDataListPac(notification: Notification){
        if notification.object != nil {
            let listPacks = notification.object as! [PackagesEntity]
            self.listPack = listPacks
            if listPack.count > 0 {
                for item in listPacks {
                    sumPack = sumPack + item.pack.pricePackage
                }
            }
            if listService.count > 0 {
                btnService.setTitle(" \(listService.count + listPack.count) dịch vụ được chọn", for: .normal)
            }else {
                btnService.setTitle(" \(listPack.count) dịch vụ được chọn", for: .normal)
            }

        }

    }
    
    
    //MARK: SetupDate
    
    
    //MARK: request Api
    func requestBoking(){
        let param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId" : Until.getCurrentId(),
            "ProfileId" : userBooking.profile.id,
            "ServiceId" : serviceEntity.serviceId,
            "BookingDate" : String(format:"%.0f",dateBook * 1000)
        ]
        print(param)
        Alamofire.request(ADD_BOOKING, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        self.booKingEntity = BookingEntity.init(dictionary: jsonData)
                    }
                    let currentDateString = String().convertDatetoString(date: self.currentDate, dateFormat: "dd/MM/YYYY")
                    let dateBookingString = String().convertTimeStampWithDateFormat(timeStamp: self.dateBook, dateFormat: "dd/MM/YYYY")
                    if currentDateString == dateBookingString {
                        self.requestCheckin()
                    }else{
                        
                        let localNotification = UILocalNotification()
                        let dateFormat = DateFormatter()
                        dateFormat.dateFormat = "dd/MM/yyyy"
                        let datePick = dateFormat.string(from: NSDate(timeIntervalSince1970: self.dateBook) as Date)
                        let dateString = "06:00 " + datePick
                        dateFormat.dateFormat = "HH:mm dd/MM/yyyy"
                        localNotification.fireDate = dateFormat.date(from: dateString)
                        localNotification.alertBody = "Xác định đi khám cho lịch đã đặt"
                        localNotification.alertAction = ""
                        localNotification.timeZone = NSTimeZone.default
                        UIApplication.shared.scheduledLocalNotifications?.append(localNotification)
                        self.delegate?.gotoExamSchudel()
                    }
                    self.btnService.setTitle("Danh sách dịch vụ", for: UIControlState.normal)
                    self.serviceEntity = ServiceEntity()
                    self.btnBrifUser.setTitle("Chọn hồ sơ người khám", for: UIControlState.normal)
                    self.userBooking = BookingUserEntity()
                    
                    
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
        
    }
    
    func requestExamInHome(){
        var listPackId = [[String: Any]]()
        for item in listPack {
            let id = ["Id": item.pack.id]
            listPackId.append(id)
        }
        
        var listServiceId = [[String: Any]]()
        for item in listService {
            let id = ["Id": item.id]
            listServiceId.append(id)
        }
        
        var param : [String: Any] = [:]
        
        param["Auth"] = Until.getAuthKey()
        param["RequestedUserId"] =  Until.getCurrentId()
        param["ProfileId"] = userBooking.profile.id
        param["BookingDate"] = String(format:"%.0f",dateBook * 1000)
        param["PhoneNumber"] = txtPhoneNumber.text!
        param["DistristId"] = listDictric[indexPatch].id
        param["Address"] = txtAdress.text!
        param["Note"] = txtNode.text!
        param["ListPackages"] = listPackId
        param["ListServices"] = listServiceId
        
        Alamofire.request(BOOKING_IN_HOME, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    self.delegate?.gotoExamSchudelAtHome()
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
        
        
    }
    
    
    
    func requestCheckin(){
        var param : [String : Any] = [:]
        
        param["Auth"] = Until.getAuthKey()
        param["BookingId"] = booKingEntity.id
        param["TimeCheckIn"] = String(format: "%.0f", dateBook*1000)
        param["CountryId"] = userBooking.profile.countryId
        param["ProvinceId"] = userBooking.profile.provinceId
        param["DictrictId"] =  userBooking.profile.dictrictId
        param["ZoneId"] = userBooking.profile.zoneId
        param["ServiceId"] = serviceEntity.serviceId
        param["Age"] = userBooking.profile.age
        param["PatientName"] = userBooking.profile.patientName
        param["GenderId"] = userBooking.profile.gender == 1 ? "M":"F"
        param["Birthday"] = String(format: "%.0f",userBooking.profile.dOB*1000)
        param["PhoneNumber"] = userBooking.profile.phoneNumber
        param["Address"] = userBooking.profile.address
        param["Cmt"] = userBooking.profile.passportId
        param["GuardianName"] = userBooking.profile.bailsmanName
        param["CmtGuardian"] = userBooking.profile.bailsmanPassportId
        param["JobId"] = userBooking.profile.jobId
        param["DepartmentId"] = String(format: "%0.f", serviceEntity.roomId)
        param["PhoneGuardian"] = userBooking.profile.bailsmanPhoneNumber
        print(param)
        Until.showLoading()
        Alamofire.request(CHECK_IN, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                print(status)
                if status == 200{
                    self.delegate?.gotoExamSchudelCheckin()
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
    }
    
    func requestListDistrict(){
        
        let param : [String: Any] = [
            "Auth": Until.getAuthKey()
        ]
        
        Alamofire.request(GET_LIST_DISTRIC, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! [NSDictionary]
                        
                        for item in jsonData {
                            let entity = DistricHomeEntity.init(dictionary: item)
                            self.listDictric.append(entity)
                        }
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
    }
    
    func isvalidCheck(){
        if userBooking.profile.patientName  == "" {
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa chọn hồ sơ", cancelBtnTitle: "Đóng")
        }else if dateBook == 0 {
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa chọn ngày tháng", cancelBtnTitle: "Đóng")
        }else {
            if status == 0 {
                if serviceEntity.name == ""  {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa chọn dịch vụ", cancelBtnTitle: "Đóng")
                }else{
                    requestBoking()
                }
            }else {
                if txtPhoneNumber.text == "" {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa nhập số điện thoại", cancelBtnTitle: "Đóng")
                }else if listService.count == 0 && listPack.count == 0 {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa chọn dịch vụ", cancelBtnTitle: "Đóng")
                }else if txtAdress.text == "" {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa nhập địa chỉ", cancelBtnTitle: "Đóng")
                }else {
                    if sumService + sumPack < checkPrice {
                        let alert = UIAlertController.init(title: "Thông báo", message: "Chúng tôi sẽ phụ thu thêm\n 100.000đ do các dịch vụ cuả\n bạn có giá dưới 200.000đ", preferredStyle: UIAlertControllerStyle.alert)
                        let actionCancel = UIAlertAction.init(title: "Bỏ qua", style: .cancel, handler: { (UIAlertAction) in
                            
                        })
                        let actionOk = UIAlertAction.init(title: "Đồng ý", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
                            self.requestExamInHome()
                        })
                        alert.addAction(actionOk)
                        alert.addAction(actionCancel)
                        self.present(alert, animated: true, completion: nil)
                    }else {
                        self.requestExamInHome()
                    }
                }
            }
        }
    }
}
