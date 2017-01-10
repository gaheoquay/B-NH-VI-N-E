//
//  UserViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, QuestionTableViewCellDelegate {
  
  @IBOutlet weak var viewUnLogin: UIView!
  @IBOutlet weak var avaImg: UIImageView!
  @IBOutlet weak var nicknameLbl: UILabel!
  @IBOutlet weak var questionTableView: UITableView!
  var page = 1
  var listMyFeed = [FeedsEntity]()
  override func viewDidLoad() {
    super.viewDidLoad()
//    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LOGIN_SUCCESS), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.reloadView), name: NSNotification.Name(rawValue: LOGIN_SUCCESS), object: nil)
    initTable()
    setUpUI()
    setupUserInfo()
    getFeeds()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let realm = try! Realm()
    let users = realm.objects(UserEntity.self)
    if users.count > 0 {
      viewUnLogin.isHidden = true
    }else{
      viewUnLogin.isHidden = false
    }
  }
  func reloadView(){
    initTable()
    setUpUI()
    setupUserInfo()
    getFeeds()
  }
  func setUpUI(){
    avaImg.layer.cornerRadius = 10
    self.navigationController?.isNavigationBarHidden = true
  }
  func setupUserInfo(){
    let realm = try! Realm()
    let users = realm.objects(UserEntity.self)
    var userEntity : UserEntity!
    if users.count > 0 {
      userEntity = users.first!
    }
    if userEntity != nil {
      avaImg.sd_setImage(with: URL.init(string: userEntity.avatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut"))
      nicknameLbl.text = userEntity.nickname
    }
  }
  func initTable(){
    questionTableView.delegate = self
    questionTableView.dataSource = self
    questionTableView.register(UINib.init(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
    questionTableView.estimatedRowHeight = 500
    questionTableView.rowHeight = UITableViewAutomaticDimension
    questionTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
  }
  func getFeeds(){
    
    let realm = try! Realm()
    let users = realm.objects(UserEntity.self)
    var userEntity : UserEntity!
    if users.count > 0 {
      userEntity = users.first!
    }
    
    let hotParam : [String : Any] = [
      "Auth": Until.getAuthKey(),
      "Page": page,
      "Size": 10,
      "UserId": userEntity != nil ? userEntity.id : "",
      "RequestedUserId" : userEntity != nil ? userEntity.id : ""
    ]
    
    print(JSON.init(hotParam))
    Until.showLoading()
    Alamofire.request(GET_QUESTION_BY_ID, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! [NSDictionary]
            
            for item in jsonData {
              let entity = FeedsEntity.init(dictionary: item)
              self.listMyFeed.append(entity)
            }
            
            self.questionTableView.reloadData()
            
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
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listMyFeed.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as! QuestionTableViewCell
    cell.indexPath = indexPath
    cell.delegate = self
    cell.feedEntity = listMyFeed[indexPath.row]
    cell.setData()
    return cell
  }
  
  @IBAction func notificationTapAction(_ sender: Any) {
    let storyboard = UIStoryboard.init(name: "User", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func messageTapAction(_ sender: Any) {
  }
  
  @IBAction func accountTapAction(_ sender: Any) {
    let storyboard = UIStoryboard.init(name: "User", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "UpdateInfoViewController") as! UpdateInfoViewController
    
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func settingTapAction(_ sender: Any) {
    let storyboard = UIStoryboard.init(name: "User", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  @IBAction func actionSetting(_ sender: Any) {
    let storyboard = UIStoryboard.init(name: "User", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func actionLogin(_ sender: Any) {
    Until.gotoLogin(_self: self, cannotBack: false)
  }
  
  //MARK: QuestionTableViewCellDelegate
  func showQuestionDetail(indexPath: IndexPath) {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
    vc.feed = listMyFeed[indexPath.row]
    self.navigationController?.pushViewController(vc, animated: true)
  }
  func gotoListQuestionByTag(hotTagId: String) {
    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionByTagViewController") as! QuestionByTagViewController
    viewController.hotTagId = hotTagId
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
