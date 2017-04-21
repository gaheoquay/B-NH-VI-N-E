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

class BookingCalenderController: UIViewController,WYPopoverControllerDelegate ,ServiceViewControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate{
    
    
    @IBOutlet weak var viewService: UIView!
    @IBOutlet weak var heightViewService: NSLayoutConstraint!
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
    var statusTime = 0

    
    //test
    var listService = [ServicesEntity]()       // Kham tai nha and xet nghiem
    var listPack = [PackagesEntity]()
    var sumPack : Double = 0
    var sumService : Double = 0
    var checkPrice: Double = 200000
    var listDictric = [DistricHomeEntity]()
    var isListDic = [DistricHomeEntity]()
    let pickerViewDistric = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))

    //endtest
    
    var userBooking = BookingUserEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadBooking), name: Notification.Name.init(RELOAD_BOOKING), object: nil)
        setupUi()
        registerNotification()
        requestListDistrict()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btnService.setTitle("Danh sách dịch vụ", for: UIControlState.normal)
        self.serviceEntity = ServiceEntity()
        self.btnBrifUser.setTitle("Chọn hồ sơ người khám", for: UIControlState.normal)
        self.txtPhoneNumber.text = "Số điện thoại"
        self.btnChoiceDistric.setTitle("Chọn Quận/Huyện ", for: .normal)
        self.txtAdress.text = ""
        self.txtAdress.placeholder = "Nhập địa chỉ sử dụng dịch vụ"
        self.txtNode.placeholder = "Thêm các yêu cầu riêng"
        self.txtNode.text = ""
        self.userBooking = BookingUserEntity()
        self.listService = [ServicesEntity]()
        self.listPack = [PackagesEntity]()
       
    }
    
    func setupUi(){
        btnService.layer.borderWidth = 0
        btnBrifUser.layer.borderWidth = 0
        btnSendBooking.layer.cornerRadius = 5
        btnSendBooking.clipsToBounds = true
        btnBookingDate.setTitle("\(String().convertDatetoString(date: currentDate, dateFormat: "EEEE, dd/MM/YYYY "))", for: .normal)
        if status == 0 {
            viewBookingHome.isHidden = true
            heightViewBookingHome.constant = 0
            btnAlanysis.setTitle("Khám tại viện E", for: .normal)
            viewService.isHidden = false
            heightViewService.constant = 65
        }else if status == 1{
            self.btnService.setTitle("Danh sách dịch vụ", for: UIControlState.normal)
            self.serviceEntity = ServiceEntity()
            viewBookingHome.isHidden = false
            heightViewBookingHome.constant = 370
            viewService.isHidden = true
            heightViewService.constant = 0
            btnAlanysis.setTitle("Khám tại nhà", for: .normal)
        }else {
            self.btnService.setTitle("Danh sách dịch vụ", for: UIControlState.normal)
            self.serviceEntity = ServiceEntity()
            viewBookingHome.isHidden = false
            viewService.isHidden = false
            heightViewBookingHome.constant = 370
            heightViewService.constant = 65
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
        self.txtPhoneNumber.text = ""
        self.txtPhoneNumber.placeholder = "Số điện thoại"
        self.btnChoiceDistric.setTitle("Chọn Quận/Huyện ", for: .normal)
        self.txtAdress.placeholder = "Nhập địa chỉ sử dụng dịch vụ"
        self.txtAdress.text = ""
        self.txtNode.placeholder = "Thêm các yêu cầu riêng"
        self.txtNode.text = ""
        self.userBooking = BookingUserEntity()
        self.listService = [ServicesEntity]()
        self.listPack = [PackagesEntity]()
        self.statusTime = 0
    }
    @IBAction func tapService(_ sender: Any) {
        delegate?.gotoService(status: status)
    }
    @IBAction func btnSelectFileUser(_ sender: Any) {
        delegate?.gotoFile()
    }
    
    @IBAction func btnSelectDateBooking(_ sender: Any) {
        self.view.endEditing(true)
        self.statusTime = 1
        let date : UIDatePickerMode?
        if status == 0{
            date = UIDatePickerMode.date
        }
        else{
            date = UIDatePickerMode.dateAndTime
        }
        let curDate = Date()
        
        DatePickerDialog().show(title: "Chọn ngày khám", doneButtonTitle: "Xong", cancelButtonTitle: "Hủy", minimumDate: curDate as NSDate?, datePickerMode: date!) {
            (date) -> Void in
            if date != nil {
                if self.status == 0 {
                    self.btnBookingDate.setTitle("\(String().convertDatetoString(date: date as! Date, dateFormat: "EEEE, dd/MM/YYYY "))", for: .normal)
                }else {
                    self.btnBookingDate.setTitle("\(String().convertDatetoString(date: date as! Date, dateFormat: "EEEE, dd/MM/YYYY hh:mm a "))", for: .normal)
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
        self.isListDic = self.listDictric
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
            let calendar = Calendar.current
            let tomorrow = calendar.date(byAdding: .day, value: +1, to: Date())
            let stringTomorrow = String().convertDatetoString(date: tomorrow!, dateFormat: "dd/MM/YYYY")
            let bookingDate = String().convertTimeStampWithDateFormat(timeStamp: dateBook, dateFormat: "dd/MM/YYYY")
            if bookingDate > stringTomorrow {
                 UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chỉ có thể đặt lịch trong khoảng 7h đến 20h hôm nay và ngày mai. Vui lòng chọn lại!", cancelBtnTitle: "Đóng")
            }else {
                let twenty_today = currentDate.dateAt(hours: 20, minutes: 0, days : 0)
                let seven_today = currentDate.dateAt(hours: 07, minutes: 0, days: 0)
                let twenty_tomorrow = tomorrow?.dateAt(hours: 20, minutes: 0, days: 0)
                let sevent_tomorrow = tomorrow?.dateAt(hours: 07, minutes: 0, days: 0)
                let t_t = String().convertDatetoString(date: twenty_today, dateFormat: "dd HH:mm")
                let s_t = String().convertDatetoString(date: seven_today, dateFormat: "dd HH:mm")
                let t_tr = String().convertDatetoString(date: twenty_tomorrow!, dateFormat: "dd HH:mm")
                let s_tr = String().convertDatetoString(date: sevent_tomorrow!, dateFormat: "dd HH:mm")
                let bk = String().convertTimeStampWithDateFormat(timeStamp: dateBook, dateFormat: "dd HH:mm")
                
                if bookingDate == stringTomorrow {
                    if bk > t_tr || bk < s_tr {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chỉ có thể đặt lịch trong khoảng 7h đến 20h hôm nay và ngày mai. Vui lòng chọn lại!", cancelBtnTitle: "Đóng")
                    }else {
                        isvalidCheck()
                    }
                }else {
                    if bk > t_t || bk < s_t {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chỉ có thể đặt lịch trong khoảng 7h đến 20h hôm nay và ngày mai. Vui lòng chọn lại!", cancelBtnTitle: "Đóng")
                    }else {
                        isvalidCheck()
                    }
                }
            }
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
            if fileUser.profile.phoneNumber == "" {
                self.txtPhoneNumber.text = ""
                self.txtPhoneNumber.placeholder = "Số điện thoại"
            }
            txtPhoneNumber.text = fileUser.profile.phoneNumber
        }
    }
    
    func setDataListSer(notification: Notification){
        self.sumService = 0
        print(sumService)
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
                if listService.count > 0 {
                    btnService.setTitle(" \(listService.count) dịch vụ được chọn", for: .normal)
                }else {
                    btnService.setTitle("Danh sách dịch vụ ", for: .normal)
                }
            }
        }
    }
    
    func setDataListPac(notification: Notification){
        self.sumPack = 0
        if notification.object != nil {
            let listPacks = notification.object as! [PackagesEntity]
            self.listPack = listPacks
            if listPack.count > 0 {
                for item in listPacks {
                    sumPack = sumPack + item.pack.pricePackage
                }
                print(sumPack)
            }
            if listService.count > 0 {
                btnService.setTitle(" \(listService.count + listPack.count) dịch vụ được chọn", for: .normal)
            }else {
                if listPack.count > 0 {
                    btnService.setTitle(" \(listPack.count) dịch vụ được chọn", for: .normal)
                }else {
                    btnService.setTitle("Danh sách dịch vụ ", for: .normal)
                }
            }

        }

    }
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
                    self.statusTime = 0
                    
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
        
    }
    
    func requestExamInHome(){
        
        var  priceService: Double = 100000
        let calendar = Calendar.current
        let hourToDay = calendar.date(byAdding: .hour, value: +1, to: Date())
        let timeStampToDay = hourToDay?.timeIntervalSince1970
        var nowDateBook: Double = 0
        if statusTime == 0 || dateBook < timeStampToDay! {
            nowDateBook = timeStampToDay!
        }else {
            nowDateBook = dateBook
        }
        
        
        if sumService + sumPack < checkPrice {
            priceService = 100000
        }else {
            priceService = 0
        }
        
        var listPackId = [[String: Any]]()
        for item in listPack {
            let id = ["Id": item.pack.id,"Name": item.pack.name]
            listPackId.append(id)
        }
        
        var listServiceId = [[String: Any]]()
        for item in listService {
            let id = ["Id": item.id,"Name": item.name]
            listServiceId.append(id)
        }
        
        if listPackId.count > 0 || listServiceId.count > 0 {
            var param : [String: Any] = [:]
            
            param["Auth"] = Until.getAuthKey()
            param["RequestedUserId"] =  Until.getCurrentId()
            param["ProfileId"] = userBooking.profile.id
            param["BookingDate"] = String(format:"%.0f",nowDateBook * 1000)
            param["PhoneNumber"] = txtPhoneNumber.text!
            param["DistrictId"] = listDictric[indexPatch].id
            param["Address"] = txtAdress.text!
            param["Note"] = txtNode.text!
            param["ListPackages"] = listPackId
            param["ListServices"] = listServiceId
            param["PriceService"] = String(format: "%.0f", priceService)
            
            Alamofire.request(BOOKING_IN_HOME, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        self.btnService.setTitle("Danh sách dịch vụ", for: UIControlState.normal)
                        self.serviceEntity = ServiceEntity()
                        self.btnBrifUser.setTitle("Chọn hồ sơ người khám", for: UIControlState.normal)
                        self.txtPhoneNumber.placeholder = "Số điện thoại"
                        self.txtPhoneNumber.text = ""
                        self.btnChoiceDistric.setTitle("Chọn Quận/Huyện ", for: .normal)
                        self.txtAdress.placeholder = "Nhập địa chỉ sử dụng dịch vụ"
                        self.txtAdress.text = ""
                        self.txtNode.placeholder = "Thêm các yêu cầu riêng"
                        self.txtNode.text = ""
                        self.userBooking = BookingUserEntity()
                        self.listService = [ServicesEntity]()
                        self.listPack = [PackagesEntity]()
                        self.delegate?.gotoExamSchudelAtHome()
                        self.statusTime = 0
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                    Until.hideLoading()
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }
        }else {
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa chọn dịch vụ", cancelBtnTitle: "Đóng")
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
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn hồ sơ", cancelBtnTitle: "Đóng")
        }else if dateBook == 0 {
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn ngày tháng", cancelBtnTitle: "Đóng")
        }else {
            if status == 0 {
                if serviceEntity.name == ""  {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn dịch vụ", cancelBtnTitle: "Đóng")
                }else{
                    requestBoking()
                }
            }else {
                if txtPhoneNumber.text == "" {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng nhập số điện thoại", cancelBtnTitle: "Đóng")
                    txtPhoneNumber.becomeFirstResponder()
                }else if !Until.isValidPhone(phone: txtPhoneNumber.text!){
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Sai định dạng số điện thoại", cancelBtnTitle: "Đóng")
                    txtPhoneNumber.becomeFirstResponder()
                }else if listService.count == 0 && listPack.count == 0 {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn dịch vụ", cancelBtnTitle: "Đóng")
                }else if txtAdress.text == "" {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng nhập địa chỉ", cancelBtnTitle: "Đóng")
                    txtAdress.becomeFirstResponder()
                }else if isListDic.isEmpty {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng nhập quận huyện", cancelBtnTitle: "Đóng")
                }else {
                    if sumService + sumPack < checkPrice {
                        let fontBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
                        let fontRegular = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
                        let myAttrString = NSMutableAttributedString(string: "Chúng tôi sẽ phụ thu thêm\n", attributes: fontRegular)
                        myAttrString.append(NSMutableAttributedString(string: "100.000đ", attributes: fontBold))
                        myAttrString.append(NSMutableAttributedString(string: " do các dịch vụ cuả\n bạn có giá dưới", attributes: fontRegular))
                        myAttrString.append(NSMutableAttributedString(string: " 200.000đ", attributes: fontBold))


                        let alert = UIAlertController.init(title: "Thông báo", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        let actionCancel = UIAlertAction.init(title: "Chọn lại", style: .cancel, handler: { (UIAlertAction) in
                            
                        })
                        let actionOk = UIAlertAction.init(title: "Đồng ý", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
                            self.requestExamInHome()
                        })
                        alert.setValue(myAttrString, forKey: "attributedMessage")
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
