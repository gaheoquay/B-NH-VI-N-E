//
//  QuestionByTagViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class QuestionByTagViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindData()
    initTableView()
    getFeeds()

    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
//  MARK: bindData
  func bindData(){
    lbTitle.text = hotTagEntity.tag.id
  }
  //MARK: init table view
  func initTableView(){
    tbQuestion.dataSource = self
    tbQuestion.delegate = self
    tbQuestion.estimatedRowHeight = 999
    tbQuestion.rowHeight = UITableViewAutomaticDimension
    tbQuestion.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    tbQuestion.register(UINib.init(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
  }
//  MARK: Action
  
  @IBAction func actionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  //  MARK: request data
  func getFeeds(){
    var requestedUserId = ""
    let realm = try! Realm()
    let users = realm.objects(UserEntity.self)
    if users.count > 0 {
      requestedUserId = users.first!.id
    }
    let hotParam : [String : Any] = [
      "Auth": Until.getAuthKey(),
      "Page": 1,
      "Size": 10,
      "RequestedUserId" : requestedUserId,
      "Tag" : hotTagEntity.tag.id
    ]
    Until.showLoading()
    Alamofire.request(GET_QUESTION_BY_TAG, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! [NSDictionary]
            
            for item in jsonData {
              let entity = FeedsEntity.init(dictionary: item)
              self.listFedds.append(entity)
            }
            
            self.tbQuestion.reloadData()
            
          }
        }else{
          UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
        }
      }else{
        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
      }
      Until.hideLoading()
    }
    
  }

  //MARK: UIViewController,UITableViewDelegate
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listFedds.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as! QuestionTableViewCell
    cell.feedEntity = listFedds[indexPath.row]
    cell.setData()
    return cell
  }

//  MARK: Outlet
  @IBOutlet weak var lbTitle: UILabel!
  @IBOutlet weak var tbQuestion: UITableView!
  var listFedds = [FeedsEntity]()
  var hotTagEntity : HotTagEntity!
}
