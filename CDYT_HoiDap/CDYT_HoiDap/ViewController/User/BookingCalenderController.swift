//
//  BookingCalenderController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 23/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol BookingCalenderControllerDelegate {
  func gotoService()
  func gotoFile()
    func gotoExamSchudel()
    func gotoExamSchudelCheckin()
}

class BookingCalenderController: UIViewController,FSCalendarDataSource,FSCalendarDelegate {
  
  
  @IBOutlet weak var btnSendBooking: UIButton!
  @IBOutlet weak var btnService: UIButton!
  @IBOutlet weak var btnBrifUser: UIButton!
  
  var serviceEntity = ServiceEntity()
  var booKingEntity = BookingEntity()
  var dateBook: Double = Date().timeIntervalSince1970
  let currentDate = Date()
  var delegate: BookingCalenderControllerDelegate?
    
    //test
    var checkIn = CheckInResultEntity()
    //endtest
    
    var userBooking = BookingUserEntity()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(reloadBooking), name: Notification.Name.init(RELOAD_BOOKING), object: nil)

    btnService.layer.borderWidth = 0
    btnBrifUser.layer.borderWidth = 0
    btnSendBooking.layer.cornerRadius = 5
    btnSendBooking.clipsToBounds = true
    registerNotification()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.btnService.setTitle("Danh sách dịch vụ", for: UIControlState.normal)
    self.serviceEntity = ServiceEntity()
    self.btnBrifUser.setTitle("Chọn hồ sơ người khám", for: UIControlState.normal)
    self.userBooking = BookingUserEntity()
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
    delegate?.gotoService()
  }
  @IBAction func btnSelectFileUser(_ sender: Any) {
    delegate?.gotoFile()
  }
  
  @IBAction func btnSendBooking(_ sender: Any) {
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
  }
  func registerNotification(){
    NotificationCenter.default.addObserver(self, selector: #selector(setDataListService(notification:)), name: NSNotification.Name(rawValue: GET_LIST_SERVICE), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(setDataFileUser(notification:)), name: NSNotification.Name(rawValue: GET_LIST_FILE_USER), object: nil)
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
  //MARK: SetupDate
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    print("calendar did select date \(String().convertDatetoString(date: date, dateFormat: "dd/MM/YYYY :EEEE"))")
    dateBook = date.timeIntervalSince1970
    
    if monthPosition == .previous || monthPosition == .next {
      calendar.setCurrentPage(date, animated: true)
    }
  }
  func minimumDate(for calendar: FSCalendar) -> Date {
    let date = Date()
    return date
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

            
        }else{
          UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
        }
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
  
  func isvalidCheck(){
    if serviceEntity.name == "" {
      UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa chọn dịch vụ", cancelBtnTitle: "Đóng")
    }else if userBooking.profile.patientName  == "" {
      UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa chọn hồ sơ", cancelBtnTitle: "Đóng")
    }else if dateBook == 0 {
      UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa chọn ngày tháng", cancelBtnTitle: "Đóng")
    }else {
        requestBoking()
    }
  }
}
