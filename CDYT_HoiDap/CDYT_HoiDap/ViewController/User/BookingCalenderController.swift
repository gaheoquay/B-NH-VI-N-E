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
}

class BookingCalenderController: UIViewController,FSCalendarDataSource,FSCalendarDelegate {
  
  
  @IBOutlet weak var btnSendBooking: UIButton!
  @IBOutlet weak var btnService: UIButton!
  @IBOutlet weak var btnBrifUser: UIButton!
  
  var listService = ServiceEntity()
//  var listFileUser = FileUserEntity()
  var listBook = BookingEntity()
  var dateBook: Double = Date().timeIntervalSince1970
  let currentDate = Date()
  var delegate: BookingCalenderControllerDelegate?
    
    //test
    var checkIn = CheckInResultEntity()
    //endtest
    
    var listBooking = BookingUserEntity()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    btnService.layer.borderWidth = 0
    btnBrifUser.layer.borderWidth = 0
    btnSendBooking.layer.cornerRadius = 5
    btnSendBooking.clipsToBounds = true
    registerNotification()
    // Do any additional setup after loading the view.
  }
  
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func tapService(_ sender: Any) {
    delegate?.gotoService()
  }
  @IBAction func btnSelectFileUser(_ sender: Any) {
    delegate?.gotoFile()
  }
  
  @IBAction func btnSendBooking(_ sender: Any) {
        isvalidCheck()
  }
  
  
  func registerNotification(){
    NotificationCenter.default.addObserver(self, selector: #selector(setDataListService(notification:)), name: NSNotification.Name(rawValue: GET_LIST_SERVICE), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(setDataFileUser(notification:)), name: NSNotification.Name(rawValue: GET_LIST_FILE_USER), object: nil)
  }
  //MARK: Notificaiton
  func setDataListService(notification : Notification){
    if notification.object != nil {
      let listServ = notification.object as! ServiceEntity
      listService = listServ
      btnService.setTitle(listServ.name, for: .normal)
    }
  }
  func setDataFileUser(notification: Notification){
    if notification.object != nil {
      let fileUser = notification.object as! BookingUserEntity
      listBooking = fileUser
      btnBrifUser.setTitle(fileUser.profile.patientName, for: .normal)
    }
  }
  //MARK: SetupDate
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    print("calendar did select date \(String().convertDatetoString(date: date, dateFormat: "dd/MM/YYYY"))")
    dateBook = date.timeIntervalSince1970
    print(dateBook)
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
      "ProfileId" : listBooking.profile.id,
      "ServiceId" : listService.serviceId,
      "BookingDate" : String(format:"%.0f",dateBook * 1000)
    ]
    print(param)
    Alamofire.request(ADD_BOOKING, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! NSDictionary
            self.listBook = BookingEntity.init(dictionary: jsonData)
          }
            
            let currentDateString = String().convertDatetoString(date: self.currentDate, dateFormat: "dd/MM/YYYY")
            let dateBookingString = String().convertTimeStampWithDateFormat(timeStamp: self.dateBook, dateFormat: "dd/MM/YYYY")
            if currentDateString == dateBookingString {
                self.requestCheckin()
            }
            self.delegate?.gotoExamSchudel()
            
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
    param["BookingId"] = listBook.id
    param["TimeCheckIn"] = String(format: "%.0f", dateBook*1000)
    param["CountryId"] = listBooking.profile.countryId
    param["ProvinceId"] = listBooking.profile.provinceId
    param["DictrictId"] =  listBooking.profile.dictrictId
    param["ZoneId"] = listBooking.profile.zoneId
    param["ServiceId"] = listService.serviceId
    param["Age"] = listBooking.profile.age
    param["PatientName"] = listBooking.profile.patientName
    param["GenderId"] = listBooking.profile.gender == 1 ? "M":"F"
    param["Birthday"] = String(format: "%.0f",listBooking.profile.dOB*1000)
    param["PhoneNumber"] = listBooking.profile.phoneNumber
    param["Address"] = listBooking.profile.address
    param["Cmt"] = listBooking.profile.passportId
    param["GuardianName"] = listBooking.profile.bailsmanName
    param["CmtGuardian"] = listBooking.profile.bailsmanPassportId
    param["JobId"] = listBooking.profile.jobId
    param["DepartmentId"] = String(format: "%0.f", listService.roomId)
    param["PhoneGuardian"] = listBooking.profile.bailsmanPhoneNumber
    print(param)
    Until.showLoading()
    Alamofire.request(CHECK_IN, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        print(status)
        if status == 200{
//            if let result = response.result.value {
//                let json = result as! NSDictionary
//                self.checkIn = CheckInResultEntity.init(dictionary: json as! [String : Any])
//                print(self.checkIn.sequence)
//            }
            
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
    if listService.name == "" {
      UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa chọn dịch vụ", cancelBtnTitle: "Đóng")
    }else if listBooking.profile.patientName  == "" {
      UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa chọn hồ sơ", cancelBtnTitle: "Đóng")
    }else if dateBook == 0 {
      UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa chọn ngày tháng", cancelBtnTitle: "Đóng")
    }else {
        requestBoking()
    }
  }
}
