//
//  ViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class ViewController: BaseViewController,KeyWordTableViewCellDelegate {
  
  //MARK: Outlet
  @IBOutlet weak var tbQuestion: UITableView!
  @IBOutlet weak var searchView: UIView!
  var listFedds = [FeedsEntity]()
  var listHotTag = [HotTagEntity]()
  var page = 1
  var role = 0
  
  @IBOutlet weak var lbSetQuestion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let realm = try! Realm()
      if let user = realm.objects(UserEntity.self).first {
        role = user.role
      }
      
      if (role == 0){
        lbSetQuestion.text = "Đặt câu hỏi"
      } else {
        lbSetQuestion.text = "Tạo bài viết"
      }
      
      NotificationCenter.default.addObserver(self, selector: #selector(self.gotoDetail(notification:)), name: NSNotification.Name.init(GO_TO_DETAIL_WHEN_TAP_NOTIFICATION), object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(self.showNotification(notification:)), name: NSNotification.Name.init(SHOW_NOTIFICAION), object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(self.gotoChat(notification:)), name: NSNotification.Name.init(GO_TO_CHAT), object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(setUpBadge), name: Notification.Name.init(UPDATE_BADGE), object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(gotoSchedule), name: Notification.Name.init(GO_TO_SCHEDULE), object: nil)
        
      setupUI()
      initTableView()
      Until.showLoading()
      getFeeds()
      getHotTagFromServer()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: HOME)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupUI() {
        searchView.layer.cornerRadius = 4
        searchView.clipsToBounds = true
    }
    
    //MARK: init table view
  
    func initTableView(){
      
        tbQuestion.dataSource = self
        tbQuestion.delegate = self
        tbQuestion.estimatedRowHeight = 999
        tbQuestion.rowHeight = UITableViewAutomaticDimension
        tbQuestion.register(UINib.init(nibName: "KeyWordTableViewCell", bundle: nil), forCellReuseIdentifier: "KeyWordTableViewCell")
        tbQuestion.register(UINib.init(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
      
        tbQuestion.addPullToRefreshHandler {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
      
        tbQuestion.addInfiniteScrollingWithHandler {
            DispatchQueue.main.async {
                self.loadMore()
            }
        }
      
    }
    func reloadData(){
        page = 1
        listHotTag.removeAll()
        listFedds.removeAll()
        getHotTagFromServer()
        getFeeds()
    }
    func loadMore(){
        page += 1
        getFeeds()
    }
    
    //  MARK: KeyWordTableViewCellDelegate
    func gotoListQuestionByTag(hotTag: TagEntity) {
      
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionByTagViewController") as! QuestionByTagViewController
        viewController.hotTag = hotTag
        self.navigationController?.pushViewController(viewController, animated: true)
      
    }
    
    //  MARK: request server
    func getHotTagFromServer(){
      
        do {
          
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = jsonString.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
          
            let hotParam : [String : Any] = [
                "Page": 1,
                "Size": 10,
                "RequestedUserId" : Until.getCurrentId()
            ]
          
            Alamofire.request(HOTEST_TAG, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
              
              if let status = response.response?.statusCode {
                
                    if status == 200 {
                        if let result = response.result.value {
                            let jsonData = result as! [NSDictionary]
                            
                            for item in jsonData {
                                let hotTag = HotTagEntity.init(dictionary: item)
                                self.listHotTag.append(hotTag)
                            }
                        }
                        self.tbQuestion.reloadData()
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                } else {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }
          
        } catch let error as NSError {
            print(error)
        }
    }
    
    func getFeeds(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            
            let hotParam : [String : Any] = [
                "Page": page,
                "Size": 10,
                "RequestedUserId" : Until.getCurrentId()
            ]
            Alamofire.request(GET_FEEDS, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
              
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
                self.tbQuestion.pullToRefreshView?.stopAnimating()
                self.tbQuestion.infiniteScrollingView?.stopAnimating()
            }
            
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    //    MARK: Action
    
    @IBAction func gotoSearch(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func addQuestionTapAction(_ sender: Any) {
        if Until.getCurrentId() != "" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddQuestionViewController") as! AddQuestionViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            Until.gotoLogin(_self: self, cannotBack: false)
        }
        
    }
    @IBAction func gotoAbout(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: receive notifiy when mark an comment is solution
    func reloadDataFromServer(notification : Notification){
        reloadData()
    }
  
  
  
}

//MARK: QuestionTableViewCellDelegate
extension ViewController : QuestionTableViewCellDelegate {
  
    func showQuestionDetail(indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
        vc.questionID = listFedds[indexPath.row].postEntity.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoUserProfileFromQuestionCell(user: AuthorEntity) {
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "OtherUserViewController") as! OtherUserViewController
        viewController.user = user
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func gotoUserProfileFromQuestionDoctor(doctor: AuthorEntity) {
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "OtherUserViewController") as! OtherUserViewController
        viewController.user = doctor
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    func selectSpecialist(indexPath: IndexPath) {}
    func selectDoctor(indexPath: IndexPath) {}
    
    func approVal(indexPath: IndexPath) {}
}
//MARK: UIViewController,UITableViewDelegate
extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return listFedds.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "KeyWordTableViewCell") as! KeyWordTableViewCell
            cell.listTag = listHotTag
            cell.delegate = self
            cell.clvKeyword.reloadData()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as! QuestionTableViewCell
            cell.delegate = self
            cell.indexPath = indexPath
            if listFedds.count > 0 {
                cell.feedEntity = listFedds[indexPath.row]
                cell.isPrivate = listFedds[indexPath.row].postEntity.isPrivate
            }
            cell.setData(isHiddenCateAndDoctor: false)
            
            return cell
        }
    }
}

extension ViewController {
    func setUpBadge(){
        let tabbar = self.tabBarController as? RAMAnimatedTabBarController
        if unreadMessageCount + notificationCount != 0 {
            tabbar?.tabBar.items![3].badgeValue = "\(unreadMessageCount + notificationCount)"
        }else{
            tabbar?.tabBar.items![3].badgeValue = nil
        }
    }
    
    func gotoDetail(notification:Notification){
        let dicData = notification.object as! NSDictionary
        navigationNotificaton(dicData: dicData)
    }
    func showNotification(notification:Notification){
        let userInfo = notification.object as! NSDictionary
        if let apsInfo = userInfo["aps"] as? NSDictionary{
            let dicData = apsInfo["data"] as! NSDictionary
            let alert = apsInfo["alert"] as! String
            RNNotificationView.show(withImage: UIImage(named: "Logo.png"),
                                    title: "BỆNH VIỆN E",
                                    message: alert,
                                    duration: 2,
                                    //                              iconSize: CGSize(width: 22, height: 22), // Optional setup
                onTap: {
                    self.navigationNotificaton(dicData: dicData)
            })
            
        }
    }
    
    func navigationNotificaton(dicData:NSDictionary){
        let type = dicData["Type"] as! String
        let parentId = dicData["ParentId"] as! String
        let notificationId = dicData["Id"] as! String
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if type == "1" || type == "3" || type == "6" {
            let viewController = storyBoard.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
            viewController.questionID = parentId
            viewController.notificationId = notificationId
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            let viewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
            viewController.commentId = parentId
            viewController.notificationId = notificationId
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func gotoChat(notification:Notification){
      
        let dicData = notification.object as! NSDictionary
        var userListQuery = SBDMain.createAllUserListQuery()
        userListQuery = SBDMain.createUserListQuery(withUserIds: [dicData["id"] as! String])
        userListQuery?.limit = 25
        if userListQuery?.hasNext == false {
            return
        }
        
        userListQuery?.loadNextPage(completionHandler: { (users, error) in
            if error != nil {
                return
            }
            var selectedUser = [SBDUser]()
            for user in users! as [SBDUser] {
                selectedUser.append(user)
            }
            SBDGroupChannel.createChannel(with: selectedUser, isDistinct: true) { (channel, error) in
                if error != nil {
                    return
                }
                DispatchQueue.main.async {
                    let vc = GroupChannelChattingViewController()
                    vc.groupChannel = channel
                    self.present(vc, animated: false, completion: nil)
                }
            }
        })
    }
    
    func gotoSchedule(){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ExamScheduleViewController") as! ExamScheduleViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

