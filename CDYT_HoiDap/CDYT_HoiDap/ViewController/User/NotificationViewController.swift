//
//  NotificationViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var notifyTableView: UITableView!
  var listNotification = [ListNotificationEntity]()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    getListNotification()
  }
  
  //MARK: Set up table
  func setupTableView(){
    notifyTableView.dataSource = self
    notifyTableView.delegate = self
    notifyTableView.estimatedRowHeight = 200
    notifyTableView.rowHeight = UITableViewAutomaticDimension
    notifyTableView.register(UINib.init(nibName: "NotifyTableViewCell", bundle: nil), forCellReuseIdentifier: "NotifyTableViewCell")
    notifyTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
  }
  //MARK: get list notification
  func getListNotification(){
    
    let hotParam : [String : Any] = [
      "Auth": Until.getAuthKey(),
      "Page": 1,
      "Size": 100,
      "RequestedUserId" : Until.getCurrentId()
    ]
    Until.showLoading()
    Alamofire.request(GET_LIST_NOTIFICATION, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! [NSDictionary]
            
            for item in jsonData {
              let entity = ListNotificationEntity.init(dictionary: item)
              self.listNotification.append(entity)
            }
          }
          self.notifyTableView.reloadData()
        }else{
          UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
        }
      }else{
        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
      }
      Until.hideLoading()
      self.notifyTableView.pullToRefreshView?.stopAnimating()
      self.notifyTableView.infiniteScrollingView?.stopAnimating()

    }
  }

  //MARK: UITableViewDelegate, UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listNotification.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyTableViewCell") as! NotifyTableViewCell
    cell.setData(entity: listNotification[indexPath.row])
    return cell
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  //MARK: Action
  @IBAction func backTapAction(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
}
