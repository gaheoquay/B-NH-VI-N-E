//
//  ExamScheduleViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ExamScheduleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ExamScheduleCellDelegate,DetailsFileUsersViewControllerDelegate{

    @IBOutlet weak var tbListExamSchedule: UITableView!
    @IBOutlet weak var imageCalendar: UIImageView!
    @IBOutlet weak var lbCalendar: UILabel!
    @IBOutlet weak var heightTbListUser: NSLayoutConstraint!
    @IBOutlet weak var viewHiddent: UIView!
    
    var listService = [ServiceEntity]()
    var listallUSer = [AllUserEntity]()
    var indexBooking = IndexPath()
    var pageIndex = 1
    var currentDate = Date()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestBooking()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listallUSer.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExamScheduleCell" ) as! ExamScheduleCell
      cell.indexPath = indexPath
      cell.delegate = self
      if listallUSer.count > 0 {
        cell.userEntity = listallUSer[indexPath.row]
        if listallUSer[indexPath.row].booking.bookType == 2 {
            if listallUSer[indexPath.row].booking.status == 7 ||  listallUSer[indexPath.row].booking.status == 6 {
                cell.isHidden = true
            }
        }else {
            if listallUSer[indexPath.row].booking.status == 4 {
                cell.isHidden = true
            }
        }
        
      }
        cell.setData()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let curentDate = Date()
        let stringCurentDate = String().convertDatetoString(date: curentDate, dateFormat: "dd/MM/YYYY")
        if listallUSer.count > 0 {
        let stringBookingDate = String().convertTimeStampWithDateFormat(timeStamp: listallUSer[indexPath.row].booking.bookingDate / 1000, dateFormat: "dd/MM/YYYY")
        if (listallUSer[indexPath.row].booking.status == 3 || listallUSer[indexPath.row].booking.status == 2 || (listallUSer[indexPath.row].booking.status == 0) && ((stringBookingDate > stringCurentDate)) || (stringBookingDate < stringCurentDate) || listallUSer[indexPath.row].booking.bookType == 2) {
            return 152
        }else {
            return 242
            }
        }
        return 152
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
   //MARK: delegate
    
    func gotoDetailUser(index: IndexPath) {
        if listallUSer[index.row].booking.bookType == 2 {
            let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "DetaiAnalysisViewController") as! DetaiAnalysisViewController
            viewcontroller.booKing = listallUSer[index.row].booking
            viewcontroller.listServices = listallUSer[index.row].listSer
            viewcontroller.listPack = listallUSer[index.row].listPac
            viewcontroller.adress = listallUSer[index.row].booking.adress
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }else {
            let main = UIStoryboard(name: "Main", bundle: nil)
            let viewcontroller = main.instantiateViewController(withIdentifier: "DetailsFileUsersViewController") as! DetailsFileUsersViewController
            viewcontroller.listService = listService
            viewcontroller.name = listallUSer[index.row].profile.patientName
            viewcontroller.checkInResult = listallUSer[index.row].booking.checkInResult
            viewcontroller.booKingRecord = listallUSer[index.row].booking
            viewcontroller.dateExam = listallUSer[index.row].booking.bookingDate / 1000
            viewcontroller.delegate = self
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
    
        
    func deleteBooking(index: IndexPath) {
        
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có muốn huỷ khám?", preferredStyle: .alert)
        let alertActionOk = UIAlertAction(title: "Huỷ Khám", style: .default) { (UIAlertAction) in
            self.reuqestDeleteBooking(index: index)
        }
        let alertActionCancel = UIAlertAction(title: "Bỏ qua", style: .cancel) { (UIAlertAction) in
            
        }
        alert.addAction(alertActionOk)
        alert.addAction(alertActionCancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func accepBooking(index: IndexPath) {
        
        let date_fourty = currentDate.dateAt(hours: 16, minutes: 0, days: 0)
        
        if currentDate > date_fourty {
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không thể đặt lịch vào ngày này! Bệnh viện ngưng đặt lịch khám sau 16h hàng ngày và chủ nhật.", cancelBtnTitle: "Đóng")
        }else {
            if listService.count > 0 {
            requestCheckin(index: index)
            }else{
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Lịch khám đang được tải về . Bạn vui lòng đợi trong giây lát", cancelBtnTitle: "Đóng")
            }
        }
    }
    
    func reloadDataExam() {
        tbListExamSchedule.reloadData()
    }
    //MARK: setupUI
    
    func reloadData(){
        pageIndex = 1
        requestBooking()
    }
    
    func loadMore(){
        pageIndex += 1
        requestBooking()
    }

    
    func setupTable(){
        if listallUSer.count > 0 {
        tbListExamSchedule.delegate = self
        tbListExamSchedule.dataSource = self
        tbListExamSchedule.estimatedRowHeight = 999
        tbListExamSchedule.rowHeight = UITableViewAutomaticDimension
        heightTbListUser.constant = UIScreen.main.bounds.size.height - 80
        tbListExamSchedule.register(UINib.init(nibName: "ExamScheduleCell", bundle: nil), forCellReuseIdentifier: "ExamScheduleCell")
        imageCalendar.isHidden = true
        lbCalendar.isHidden = true
            
            tbListExamSchedule.addPullToRefreshHandler {
                DispatchQueue.main.async {
                    self.reloadData()
                    
                }
            }
            
            tbListExamSchedule.addInfiniteScrollingWithHandler {
                DispatchQueue.main.async {
                    self.loadMore()
                }
            }
        }else {
            tbListExamSchedule.estimatedRowHeight = 0
            tbListExamSchedule.rowHeight = UITableViewAutomaticDimension
            heightTbListUser.constant = 0
            imageCalendar.isHidden = false
            lbCalendar.isHidden = false
        }
        
        if listService.count > 0 {
            return
        }else {
            requestListService()
        }
        
        self.tbListExamSchedule.reloadData()

    }
    
    //MARK: REQUEST API
    func requestBooking(){
        let Param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId" : Until.getCurrentId()
        ]
        print(Param)
        listallUSer.removeAll()
        Until.showLoading()
        Alamofire.request(GET_BOOKING_ONLY, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! [NSDictionary]
                        for item in jsonData {
                            let entity = AllUserEntity.init(dictionary: item)
                            self.listallUSer.append(entity)
                            
                        }
                    }
                    self.setupTable()
                    self.tbListExamSchedule.reloadData()
                    Until.hideLoading()
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
        self.tbListExamSchedule.pullToRefreshView?.stopAnimating()
        self.tbListExamSchedule.infiniteScrollingView?.stopAnimating()
    }
    
    func reuqestDeleteBooking(index: IndexPath){
        
        let Param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId" : Until.getCurrentId(),
            "BookingId" : listallUSer[index.row].booking.id
        ]
        Until.showLoading()

        Alamofire.request(DELETE_BOOKING, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    self.listallUSer.remove(at: index.row)
                    self.tbListExamSchedule.reloadData()
                    Until.hideLoading()

                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
    }
    
    func requestCheckin(index: IndexPath){
        
        let serVice = listService.filter { (serViceEntiy) -> Bool in
            String(serViceEntiy.serviceId) == listallUSer[index.row].booking.serviceId
        }
        
        var param : [String : Any] = [:]
        
        param["Auth"] = Until.getAuthKey()
        param["BookingId"] = listallUSer[index.row].booking.id
        param["TimeCheckIn"] = String(format: "%.0f", listallUSer[index.row].booking.bookingDate)
        param["CountryId"] = listallUSer[index.row].profile.countryId
        param["ProvinceId"] = listallUSer[index.row].profile.provinceId
        param["DictrictId"] =  listallUSer[index.row].profile.dictrictId
        param["ZoneId"] = listallUSer[index.row].profile.zoneId
        param["ServiceId"] = serVice[0].serviceId
        param["Age"] = listallUSer[index.row].profile.age
        param["PatientName"] = listallUSer[index.row].profile.patientName
        param["GenderId"] = listallUSer[index.row].profile.gender == 1 ? "M":"F"
        param["Birthday"] = String(format: "%.0f",listallUSer[index.row].profile.dOB)
        param["PhoneNumber"] = listallUSer[index.row].profile.phoneNumber
        param["Address"] = listallUSer[index.row].profile.address
        param["Cmt"] = listallUSer[index.row].profile.passportId
        param["GuardianName"] = listallUSer[index.row].profile.bailsmanName
        param["CmtGuardian"] = listallUSer[index.row].profile.bailsmanPassportId
        param["JobId"] = listallUSer[index.row].profile.jobId
        param["DepartmentId"] = String(format: "%0.f", serVice[0].roomId)
        param["PhoneGuardian"] = listallUSer[index.row].profile.bailsmanPhoneNumber
        print(param)
        Until.showLoading()
        Alamofire.request(CHECK_IN, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                print(status)
                if status == 200{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Đặt lịch khám thành công", cancelBtnTitle: "Đóng")
                    self.listallUSer[index.row].booking.status = 2
                    self.tbListExamSchedule.reloadRows(at: [index], with: .automatic)
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Lỗi! Không thể xác nhận đặt khám này", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
    }
    
    func requestListService(){
        Alamofire.request(BOOKING_GET_LIST_SERVICE, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! [NSDictionary]
                        
                        for item in jsonData {
                            let entity = ServiceEntity.init(dictionary: item)
                            self.listService.append(entity)
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

    func gotoDetailHistoryHospital(indexPatch: IndexPath) {
        
    }
    
    func gotoDetailHistoryAtHome(indexPatch: IndexPath) {
        
    }
    
}
