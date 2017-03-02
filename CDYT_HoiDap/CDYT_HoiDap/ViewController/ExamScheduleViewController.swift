//
//  ExamScheduleViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ExamScheduleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ExamScheduleCellDelegate{

    @IBOutlet weak var tbListExamSchedule: UITableView!
    @IBOutlet weak var imageCalendar: UIImageView!
    @IBOutlet weak var lbCalendar: UILabel!
    @IBOutlet weak var heightTbListUser: NSLayoutConstraint!
    @IBOutlet weak var viewHiddent: UIView!
    
    var listService = [ServiceEntity]()
    var listallUSer = [AllUserEntity]()
    var isCheckShow = false
    var indexBooking = IndexPath()
    
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
        cell.listBooking = listallUSer[indexPath.row].booking
        cell.profileUser = listallUSer[indexPath.row].profile
        cell.setData()
      }
        return cell
    }
    //MARK: delegate
    func gotoDetailUser(index: IndexPath, listBook: BookingEntity) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "DetailsFileUsersViewController") as! DetailsFileUsersViewController
      viewcontroller.listService = listService
        viewcontroller.name = listallUSer[index.row].profile.patientName
        viewcontroller.listCheckin = listBook.checkInResult
        viewcontroller.listBooking = listBook
        viewcontroller.dateExam = listallUSer[index.row].profile.createdDate
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    func showDetailStatus(index: IndexPath) {
        tbListExamSchedule.reloadRows(at: [index], with: .automatic)
        indexBooking = index
    }
    
    func deleteBooking() {
        reuqestDeleteBooking()
    }
    
    func accepBooking() {
        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Chức năng đang hoàn thiện \n Vui lòng thử lại sau", cancelBtnTitle: "Huỷ")
    }
    
    //MARK: setupUI
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
        }else {
            tbListExamSchedule.estimatedRowHeight = 0
            tbListExamSchedule.rowHeight = UITableViewAutomaticDimension
            heightTbListUser.constant = 0
            imageCalendar.isHidden = false
            lbCalendar.isHidden = false
        }
    }
    
    //MARK: REQUEST API
    func requestBooking(){
        let Param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId" : Until.getCurrentId()
        ]
        
        print(Param)
        
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
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
    }
    
    func reuqestDeleteBooking(){
        
        let Param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId" : Until.getCurrentId(),
            "BookingId" : listallUSer[indexBooking.row].booking.id
        ]
        
        Alamofire.request(DELETE_BOOKING, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    self.listallUSer.removeAll()
                    self.requestBooking()
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
    }
    
    
}
