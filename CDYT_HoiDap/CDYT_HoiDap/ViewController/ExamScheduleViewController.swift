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
    
    var listallUSer = [AllUserEntity]()
    
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
        cell.listBooking = listallUSer[indexPath.row].booking[indexPath.row]
        cell.profileUser = listallUSer[indexPath.row].profile
        cell.setData()
      }
        return cell
    }
    
    func gotoDetailUser(index: IndexPath) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "DetailsFileUsersViewController") as! DetailsFileUsersViewController
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    func setupTable(){
        if listallUSer.count > 0 {
        tbListExamSchedule.delegate = self
        tbListExamSchedule.dataSource = self
        tbListExamSchedule.estimatedRowHeight = 9999
        tbListExamSchedule.rowHeight = UITableViewAutomaticDimension
        heightTbListUser.constant = 502
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
        
        Alamofire.request(GET_BOOKING, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
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
    
    
}
