//
//  HistoryUserViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class HistoryUserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SearchFileViewControllerDelegate {

    @IBOutlet weak var tbListHistory: UITableView!
    @IBOutlet weak var heightTbListHistory: NSLayoutConstraint!
    @IBOutlet weak var imgCV: UIImageView!
    @IBOutlet weak var lbCV: UILabel!
    @IBOutlet weak var btnListProfile: UIButton!
    
    
    var listBookingUser = [BookingUserEntity]()
    var listBooking = [BookingEntity]()
    var indexProfile = IndexPath()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBooking.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        if listBooking.count > 0 {
            cell.setDataHistory(entity: listBooking[indexPath.row])
            if listBooking[indexPath.row].bookType == 2 {
                if listBooking[indexPath.row].status == 6 || listBooking[indexPath.row].status == 7  {
                    cell.isHidden = false
                }else {
                    cell.isHidden = true
                }
            }else {
                if listBooking[indexPath.row].status == 4 || listBooking[indexPath.row].status == 3{
                    cell.isHidden = false
                }else {
                    cell.isHidden = true
                }
            }
                   }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listBooking[indexPath.row].bookType == 2 {
            let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
            viewcontroller.booKing = listBooking[indexPath.row]
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }else {
            let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "DetailsHistoryUserViewController") as! DetailsHistoryUserViewController
            viewcontroller.listBooking = listBooking[indexPath.row]
            viewcontroller.date = String().convertTimeStampWithDateFormat(timeStamp: listBooking[indexPath.row].createDate, dateFormat: "dd/MM/YYYY")
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if listBooking[indexPath.row].bookType == 2 {
            if listBooking[indexPath.row].status == 6 || listBooking[indexPath.row].status == 7 {
                return UITableViewAutomaticDimension
            }else {
                return 0
            }
        }else {
            if listBooking[indexPath.row].status == 4 || listBooking[indexPath.row].status == 3 {
                return UITableViewAutomaticDimension
            }else {
                return 0
            }
        }
        
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnGotoListFile(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "SearchFileViewController") as! SearchFileViewController
        viewcontroller.delegate = self
        viewcontroller.isCheckResult = true
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    func setupTable(){
        
        if listBooking.count > 0 {
          
            tbListHistory.register(UINib.init(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
            heightTbListHistory.constant = UIScreen.main.bounds.size.height - 185
            tbListHistory.estimatedRowHeight = 9999
            tbListHistory.rowHeight = UITableViewAutomaticDimension
            tbListHistory.delegate = self
            tbListHistory.dataSource = self
            tbListHistory.isHidden = false
            lbCV.isHidden = true
            imgCV.isHidden = true
          
        }else {
          
            heightTbListHistory.constant = 0
            tbListHistory.estimatedRowHeight = 0
            tbListHistory.rowHeight = UITableViewAutomaticDimension
            tbListHistory.isHidden = true
            lbCV.isHidden = false
            imgCV.isHidden = false
          
        }
        self.view.layoutIfNeeded()
        tbListHistory.reloadData()
    }
  
    //MARK: RequestData
    
    func requestBookingUser(){
      
        let Param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId" : Until.getCurrentId()
        ]
        
//        print(Param)
      
        Until.showLoading()
        Alamofire.request(GET_BOOKING_BY_USERID, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! [NSDictionary]
                        for item in jsonData {
                            let entity = BookingUserEntity.init(dictionary: item)
                            self.listBookingUser.append(entity)
                        }
                        self.btnListProfile.setTitle(self.listBookingUser[self.indexProfile.row].profile.patientName, for: .normal)
                        self.listBooking = self.listBookingUser[self.indexProfile.row].booking
                    }
                    self.setupTable()
                    Until.hideLoading()
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            self.tbListHistory.pullToRefreshView?.stopAnimating()
            self.tbListHistory.infiniteScrollingView?.stopAnimating()
        }
      
    }
    //MARK: Delegate
    func gotoHistory(indexPath: IndexPath) {
        indexProfile = indexPath
        listBookingUser.removeAll()
        requestBookingUser()
    }
    
       

}
