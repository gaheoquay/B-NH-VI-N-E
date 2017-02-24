//
//  UserViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, QuestionTableViewCellDelegate {
  
  @IBOutlet weak var viewFollowingQuestion: UIView!
  @IBOutlet weak var layoutWidthViewFollowingQuestion: NSLayoutConstraint!
  
  @IBOutlet weak var viewQuestionWaitingToAnwser: UIView!
  @IBOutlet weak var viewCreatedQuestion: UIView!
    @IBOutlet weak var notiCountLb: UILabel!
  @IBOutlet weak var viewUnLogin: UIView!
  @IBOutlet weak var avaImg: UIImageView!
  @IBOutlet weak var nicknameLbl: UILabel!
  @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var messageCountLb: UILabel!
  var pageMyFeed = 1
  var listMyFeed = [FeedsEntity]()
  var isMyFeed = false
  var pageFollowing = 1
  var listQuestionFollowing = [FeedsEntity]()
  var isFollowing = true
  var pageWaiting = 1
  var listQuestionWaitingToAnwser = [FeedsEntity]()
  var isWaiting = false
  var groupChannelListViewController: GroupChannelListViewController?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    registerNotification()
    initTable()
    setUpUI()
    setupUserInfo()
    Until.showLoading()
    getMyFeeds()
    getFollowingFeed()
    getWaitingFeed()
    if Until.getCurrentId() != "" {
        getListNotification()
    }
    
  }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: MY_PAGE)
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
    notiCountLb.isHidden = true
    messageCountLb.isHidden = true
    Until.getBagValue()

    getNotificationCount()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadView), name: NSNotification.Name(rawValue: LOGIN_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupUserInfo), name: NSNotification.Name(rawValue: UPDATE_USERINFO), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataFromServer(notification:)), name: Notification.Name.init(RELOAD_ALL_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMessageCountLabel), name: Notification.Name.init(UPDATE_BADGE), object: nil)

    }
    
  func reloadView(){
    initTable()
    setUpUI()
    setupUserInfo()
    isMyFeed = true
    isFollowing = false
    isWaiting = false
    pageMyFeed = 1
    pageFollowing = 1
    pageWaiting = 1
    listMyFeed.removeAll()
    listQuestionWaitingToAnwser.removeAll()
    listQuestionFollowing.removeAll()
    getMyFeeds()
    getWaitingFeed()
    getFollowingFeed()
  }
  func setUpUI(){
    avaImg.layer.cornerRadius = 10
    self.navigationController?.isNavigationBarHidden = true
    notiCountLb.layer.cornerRadius = 5
    notiCountLb.layer.masksToBounds = true
    setBackgroundView(view: viewFollowingQuestion, check: isFollowing)
    setBackgroundView(view: viewCreatedQuestion, check: isMyFeed)
    setBackgroundView(view: viewQuestionWaitingToAnwser, check: isWaiting)
    questionTableView.reloadData()
    
    messageCountLb.layer.cornerRadius = 5
    messageCountLb.layer.masksToBounds = true

  }
    
  func setBackgroundView(view:UIView,check:Bool){
    if check {
      view.backgroundColor = UIColor.init(netHex: 0xECEDEF)
    }else{
      view.backgroundColor = UIColor.white
    }
  }
  @IBAction func selectFollowingQuestion(_ sender: Any) {
    isFollowing = true
    isMyFeed = false
    isWaiting = false
    setUpUI()
    
  }
  @IBAction func selectMyFeed(_ sender: Any) {
    isFollowing = false
    isMyFeed = true
    isWaiting = false
    setUpUI()
  }
  @IBAction func selectWaitingQuestion(_ sender: Any) {
    isFollowing = false
    isMyFeed = false
    isWaiting = true
    setUpUI()
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
      if userEntity.role == 1 {
        layoutWidthViewFollowingQuestion.constant = UIScreen.main.bounds.width/3
      }else{
        layoutWidthViewFollowingQuestion.constant = UIScreen.main.bounds.width/2
      }
      self.view.layoutIfNeeded()
    }
  }
  func initTable(){
    questionTableView.delegate = self
    questionTableView.dataSource = self
    questionTableView.register(UINib.init(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
    questionTableView.register(UINib.init(nibName: "RecentFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentFeedTableViewCell")
    questionTableView.estimatedRowHeight = 500
    questionTableView.rowHeight = UITableViewAutomaticDimension
    questionTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    
    questionTableView.addPullToRefreshHandler {
      DispatchQueue.main.async {
        self.reloadData()
      }
    }
    questionTableView.addInfiniteScrollingWithHandler {
      DispatchQueue.main.async {
        self.loadMore()
      }
    }
  }
  
  func reloadData(){
    if isMyFeed {
      pageMyFeed = 1
      listMyFeed.removeAll()
      getMyFeeds()
    }else if isFollowing{
      pageFollowing = 1
      listQuestionFollowing.removeAll()
      getFollowingFeed()
    }else{
      pageWaiting = 1
      listQuestionWaitingToAnwser.removeAll()
      getWaitingFeed()
    }
  }
  func loadMore(){
    if isMyFeed {
      pageMyFeed += 1
      getMyFeeds()
    }else if isFollowing{
      pageFollowing += 1
      getFollowingFeed()
    }else{
      pageWaiting += 1
      getWaitingFeed()
    }
  }
    
    func updateMessageCountLabel(){
        if unreadMessageCount != 0 {
            messageCountLb.text = " \(unreadMessageCount) "
            messageCountLb.isHidden = false
        }else{
            messageCountLb.text = ""
            messageCountLb.isHidden = true
        }
    }
    
    func getListNotification(){
        
        let hotParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "Page": 1,
            "Size": 20,
            "RequestedUserId" : Until.getCurrentId()
        ]
      
        Alamofire.request(GET_LIST_NOTIFICATION, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! [NSDictionary]
                        listNotification.removeAll()
                        for item in jsonData {
                            let entity = ListNotificationEntity.initWithDict(dictionary: item)
                            listNotification.append(entity)
                        }
                    }
                }
            }
        }
    }
    
    
    func getNotificationCount(){
        let param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": Until.getCurrentId()
        ]
        
        Alamofire.request(GET_UNREAD_NOTIFICATION, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        notificationCount = jsonData["Count"] as! Int
                        if notificationCount != 0 {
                            self.notiCountLb.text = " \(notificationCount) "
                            self.notiCountLb.isHidden = false
                        }else{
                            self.notiCountLb.text = ""
                            self.notiCountLb.isHidden = true
                        }
                        
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không thể lấy được số lượng thông báo. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
    }
    
    
  func getMyFeeds(){
    
    let hotParam : [String : Any] = [
      "Auth": Until.getAuthKey(),
      "Page": pageMyFeed,
      "Size": 10,
      "UserId": Until.getCurrentId(),
      "RequestedUserId" : Until.getCurrentId()
    ]
    
    //    Until.showLoading()
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
      self.questionTableView.pullToRefreshView?.stopAnimating()
      self.questionTableView.infiniteScrollingView?.stopAnimating()
    }
    
  }
  func getFollowingFeed(){
    
    let hotParam : [String : Any] = [
      "Auth": Until.getAuthKey(),
      "Page": pageFollowing,
      "Size": 10,
      "UserId": Until.getCurrentId(),
      "RequestedUserId" : Until.getCurrentId()
    ]
    
    //    Until.showLoading()
    Alamofire.request(GET_QUESTION_FOLLOWED, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! [NSDictionary]
            
            for item in jsonData {
              let entity = FeedsEntity.init(dictionary: item)
              self.listQuestionFollowing.append(entity)
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
      self.questionTableView.pullToRefreshView?.stopAnimating()
      self.questionTableView.infiniteScrollingView?.stopAnimating()
    }
  }
  func getWaitingFeed(){
    
    let hotParam : [String : Any] = [
      "Auth": Until.getAuthKey(),
      "Page": pageWaiting,
      "Size": 10,
      "UserId": Until.getCurrentId(),
      "RequestedUserId" : Until.getCurrentId()
    ]
    
    //    Until.showLoading()
    Alamofire.request(GET_QUESTION_ASSIGN, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! [NSDictionary]
            
            for item in jsonData {
              let entity = FeedsEntity.init(dictionary: item)
              self.listQuestionWaitingToAnwser.append(entity)
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
      self.questionTableView.pullToRefreshView?.stopAnimating()
      self.questionTableView.infiniteScrollingView?.stopAnimating()
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isMyFeed {
      return listMyFeed.count
    }
    if isFollowing {
      return listQuestionFollowing.count
    }
    if  isWaiting {
      return listQuestionWaitingToAnwser.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as! QuestionTableViewCell
    cell.indexPath = indexPath
    cell.delegate = self

    if isMyFeed {
      if listMyFeed.count > 0 {
        cell.feedEntity = listMyFeed[indexPath.row]
        cell.setData(isHiddenCateAndDoctor: false)
      }
    }else if isFollowing {
      if listQuestionFollowing.count > 0 {
        cell.feedEntity = listQuestionFollowing[indexPath.row]
        cell.setData(isHiddenCateAndDoctor: false)
      }
    }else{
      if listQuestionWaitingToAnwser.count > 0 {
        cell.feedEntity = listQuestionWaitingToAnwser[indexPath.row]
        cell.setData(isHiddenCateAndDoctor: false)
      }
    }
    return cell
  }
  
  @IBAction func notificationTapAction(_ sender: Any) {
    let storyboard = UIStoryboard.init(name: "User", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func messageTapAction(_ sender: Any) {
    self.gotoInbox()
  }
  
  func gotoInbox(){
    
    if self.groupChannelListViewController == nil {
      self.groupChannelListViewController = GroupChannelListViewController()
      self.groupChannelListViewController?.addDelegates()
    }
    self.groupChannelListViewController?.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
    self.navigationController?.pushViewController(self.groupChannelListViewController!, animated: true)
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
    if isMyFeed {
      vc.feedObj = listMyFeed[indexPath.row]
    }else if isFollowing{
      vc.feedObj = listQuestionFollowing[indexPath.row]
    }else{
      vc.feedObj = listQuestionWaitingToAnwser[indexPath.row]
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  func gotoListQuestionByTag(hotTagId: String) {
    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionByTagViewController") as! QuestionByTagViewController
    viewController.hotTagId = hotTagId
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  
  //MARK: receive notifiy when mark an comment is solution
  func reloadDataFromServer(notification : Notification){
    reloadData()
  }
    func selectDoctor(indexPath: IndexPath) {
        
    }
    
    func selectSpecialist(indexPath: IndexPath) {
        
    }
    
    func approVal() {
        
    }
  
  func gotoUserProfileFromQuestionCell(user: AuthorEntity) {
    //khong can phai thuc hien ham nay vi dang trong trang profile cua chinh minh
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
