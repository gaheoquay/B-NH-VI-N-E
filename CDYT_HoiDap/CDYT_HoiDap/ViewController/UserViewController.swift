//
//  UserViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate,
QuestionTableViewCellDelegate, InsertAccountCellDelegate, DoctorTableViewCellDelegate,RegisterViewControllerDelegate,AdminUpdateProfileViewControllerDelegate {
    
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
    @IBOutlet weak var lbPage1: UILabel!
    @IBOutlet weak var lbPage2: UILabel!
  
    var pageMyFeed = 1
    var listMyFeed = [FeedsEntity]()
    var isMyFeed = false
    var pageFollowing = 1
    var listQuestionFollowing = [FeedsEntity]()
    var isFollowing = false
    var pageWaiting = 1
    var listQuestionWaitingToAnwser = [FeedsEntity]()
    var isWaiting = true
    var groupChannelListViewController: GroupChannelListViewController?
    var sectionCate = 0
    var indexPatchDoctor = IndexPath()
    var listAdmin = [ListAdminEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self).first
        if users?.role == 1 {
            isMyFeed =  false
            isFollowing = false
            isWaiting = true
        }else{
            isMyFeed =  false
            isFollowing = true
            isWaiting = false
        }
        getListAdmin()
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
        refreshView()
    }
    
    func refreshView(){
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        if users.first?.role == 3 {
            questionTableView.estimatedRowHeight = 80
            questionTableView.rowHeight = 80
            questionTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }else {
            questionTableView.estimatedRowHeight = 500
            questionTableView.rowHeight = UITableViewAutomaticDimension
            questionTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
        
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
        let tabbar = self.tabBarController as? RAMAnimatedTabBarController
        tabbar?.setSelectIndex(from: 3, to: 0)
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self).first
        if users?.role == 1 {
            isMyFeed =  false
            isFollowing = false
            isWaiting = true
        }else{
            isMyFeed =  false
            isFollowing = true
            isWaiting = false
        }
        initTable()
        setUpUI()
        setupUserInfo()
        pageMyFeed = 1
        pageFollowing = 1
        pageWaiting = 1
        listMyFeed.removeAll()
        listQuestionWaitingToAnwser.removeAll()
        listQuestionFollowing.removeAll()
        getMyFeeds()
        getWaitingFeed()
        getFollowingFeed()
        getListAdmin()
        refreshView()
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
            nicknameLbl.text = userEntity.fullname
            if userEntity.role == 1 {
                lbPage1.text = "Câu hỏi đang theo dõi"
                lbPage2.text = "Câu hỏi đã tạo"
                layoutWidthViewFollowingQuestion.constant = UIScreen.main.bounds.width/3
            }else{
                layoutWidthViewFollowingQuestion.constant = UIScreen.main.bounds.width/2
                if userEntity.role == 3 {
                    lbPage1.text = "Bác sĩ"
                    lbPage2.text = "Admin"
                }else {
                    lbPage1.text = "Câu hỏi đang theo dõi"
                    lbPage2.text = "Câu hỏi đã tạo"
                }
            }
            self.view.layoutIfNeeded()
        }
    }
    func initTable(){
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.register(UINib.init(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        questionTableView.register(UINib.init(nibName: "RecentFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentFeedTableViewCell")
        questionTableView.register(UINib.init(nibName: "DoctorTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorTableViewCell")
        questionTableView.register(UINib.init(nibName: "InsertAccountCell", bundle: nil), forCellReuseIdentifier: "InsertAccountCell")
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
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let requestUrl = GET_LIST_NOTIFICATION_BY_PAGING + "?page=\(1)&size=\(20)"
            Alamofire.request(requestUrl, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let data = jsonData["Data"] as! [NSDictionary]
                            listNotification.removeAll()
                            for item in data {
                                let entity = NotificationNewEntity.init(dictionary: item)
                                listNotification.append(entity)
                            }
                        }
                    }
                }
            }

        } catch let error as NSError {
            print(error)
        }
    }
    
    
    func getNotificationCount(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let param : [String : Any] = [
                "RequestedUserId": Until.getCurrentId()
            ]
            
            Alamofire.request(GET_UNREAD_NOTIFICATION, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
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
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    func getMyFeeds(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let hotParam : [String : Any] = [
                "Auth": Until.getAuthKey(),
                "Page": pageMyFeed,
                "Size": 10,
                "UserId": Until.getCurrentId(),
                "RequestedUserId" : Until.getCurrentId()
            ]
            
            Alamofire.request(GET_QUESTION_BY_ID, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
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
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
                self.questionTableView.pullToRefreshView?.stopAnimating()
                self.questionTableView.infiniteScrollingView?.stopAnimating()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func getFollowingFeed(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let hotParam : [String : Any] = [
                "Page": pageFollowing,
                "Size": 10,
                "UserId": Until.getCurrentId(),
                "RequestedUserId" : Until.getCurrentId()
            ]
            
            Alamofire.request(GET_QUESTION_FOLLOW_BY_USER, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
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
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
                self.questionTableView.pullToRefreshView?.stopAnimating()
                self.questionTableView.infiniteScrollingView?.stopAnimating()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    func getWaitingFeed(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let hotParam : [String : Any] = [
                "Page": pageWaiting,
                "Size": 10,
                "UserId": Until.getCurrentId(),
                "RequestedUserId" : Until.getCurrentId()
            ]
            Alamofire.request(GET_QUESTION_ASSIGN, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
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
                        //          UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
                self.questionTableView.pullToRefreshView?.stopAnimating()
                self.questionTableView.infiniteScrollingView?.stopAnimating()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func getListAdmin(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let param : [String : Any] = [
                "RequestedUserId" : Until.getCurrentId()
            ]
            
            Alamofire.request(GET_LIST_ADMIN, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! [NSDictionary]
                            
                            for item in jsonData {
                                let entity = ListAdminEntity.init(dictionary: item)
                                self.listAdmin.append(entity)
                            }
                        }
                    }else{
                        //                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
                self.questionTableView.pullToRefreshView?.stopAnimating()
                self.questionTableView.infiniteScrollingView?.stopAnimating()
            }

        } catch let error as NSError {
            print(error)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        if users.first?.role == 3 {
            if isFollowing {
                return listAllDoctor.count
            }
            if isMyFeed {
                return 1
            }
            return 1
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        if users.first?.role == 3 {
            if isFollowing {
                return 50
            }else if isMyFeed{
                return 0
            }
            return 0
        }else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        if users.first?.role == 3 {
            return 80
        }else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        if users.first?.role == 3 {
            if isFollowing {
                let entity = listAllDoctor[section]
                let vw = UIView()
                vw.backgroundColor = UIColor.white
                let lbCateName = UILabel.init()
                lbCateName.font = UIFont.systemFont(ofSize: 13)
                lbCateName.text = entity.category.name
                lbCateName.sizeToFit()
                lbCateName.frame = CGRect.init(x: 8, y: 25 - lbCateName.frame.size.height/2 , width: lbCateName.frame.size.width, height: lbCateName.frame.size.height)
                vw.addSubview(lbCateName)
                let lbNumberOfDoctor = UILabel.init()
                lbNumberOfDoctor.font = UIFont.systemFont(ofSize: 13)
                lbNumberOfDoctor.text = "  " + String(entity.doctors.count) + " bác sĩ  "
                lbNumberOfDoctor.sizeToFit()
                lbNumberOfDoctor.frame = CGRect.init(x: UIScreen.main.bounds.width - lbNumberOfDoctor.frame.size.width - 8, y: 10 , width: lbNumberOfDoctor.frame.size.width, height: 30)
                lbNumberOfDoctor.backgroundColor = UIColor.init(netHex: 0xcfe8ff)
                lbNumberOfDoctor.layer.cornerRadius = 5
                lbNumberOfDoctor.clipsToBounds = true
                vw.addSubview(lbNumberOfDoctor)
                let viewLine = UIView.init(frame: CGRect.init(x: 8, y: 49, width: UIScreen.main.bounds.width - 16, height: 1))
                viewLine.backgroundColor = UIColor.init(netHex: 0xd6d6d6)
                vw.addSubview(viewLine)
                let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height:50 ))
                button.tag = section
                button.setTitle("", for: UIControlState.normal)
                button.addTarget(self, action: #selector(clickHeader(button:)), for: UIControlEvents.touchUpInside)
                vw.addSubview(button)
                return vw
            }else if isMyFeed{
                return nil
            }
            return nil
        }else {
            return nil
        }
        
    }
    
    func clickHeader(button:UIButton){
        print(button.tag)
        let entity = listAllDoctor[button.tag]
        entity.isExpand = !entity.isExpand
        questionTableView.beginUpdates()
        questionTableView.reloadSections(IndexSet.init(integer: button.tag), with: UITableViewRowAnimation.automatic)
        questionTableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        if users.first?.role == 3 {
            
            if isFollowing {
                let entity = listAllDoctor[section]
                if !entity.isExpand {
                    return 0
                }
                return entity.doctors.count + 1
            }
            if isMyFeed {
                return listAdmin.count + 1
            }
        }else {
            if isMyFeed {
                return listMyFeed.count
            }
            if isFollowing {
                return listQuestionFollowing.count
            }
            if  isWaiting {
                return listQuestionWaitingToAnwser.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        let cellSpAdmin = tableView.dequeueReusableCell(withIdentifier: "DoctorTableViewCell") as! DoctorTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as! QuestionTableViewCell
        let cellCreate = tableView.dequeueReusableCell(withIdentifier: "InsertAccountCell") as! InsertAccountCell
        self.sectionCate = indexPath.section
        cellSpAdmin.delegate = self
        cellCreate.indexPatchRow = indexPath.row
        cellCreate.indexPatchSection = indexPath
        cellCreate.delegate = self
        cell.indexPath = indexPath
        cell.delegate = self
        if users.first?.role == 3 {
            cellSpAdmin.isBlock = false
            if indexPath.row == 0 {
                return cellCreate
            }else {
                if isFollowing {
                    cellSpAdmin.author = listAllDoctor[indexPath.section].doctors[indexPath.row - 1].doctorEntity
                    cellSpAdmin.setData()
                }
                if isMyFeed {
                    cellSpAdmin.admin = listAdmin[indexPath.row - 1]
                    cellSpAdmin.setDataAdmin()
                }
                cellSpAdmin.indexPatch = indexPath
                return cellSpAdmin
                
            }
        }else {
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
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        let currentUser = realm.objects(UserEntity.self).first
        if currentUser?.role != 3 {
            return
        }

        let main = UIStoryboard(name: "User", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "AdminUpdateProfileViewController") as! AdminUpdateProfileViewController
        if isFollowing {
            viewcontroller.author = listAllDoctor[indexPath.section].doctors[indexPath.row - 1].doctorEntity
        }
        if isMyFeed {
            viewcontroller.admin = listAdmin[indexPath.row - 1]
        }
        viewcontroller.isAdmin = self.isMyFeed
        viewcontroller.departmenName = listAllDoctor[sectionCate].category.name
        viewcontroller.departmenId = listAllDoctor[sectionCate].category.id
        viewcontroller.delegate = self
        self.indexPatchDoctor = indexPath
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    @IBAction func notificationTapAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func messageTapAction(_ sender: Any) {
        let realm = try! Realm()
        let currentUser = realm.objects(UserEntity.self).first
        if currentUser?.role == 0 {
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng nâng cấp để sử dụng chức năng này", cancelBtnTitle: "Đồng ý")
            return
        }
        self.gotoInbox()
    }
    
    func createAccountDoctor(indexPatchSection: IndexPath, indexPatchRow: Int) {
        let main = UIStoryboard(name: "User", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        viewcontroller.isCreateAcc = true
        viewcontroller.delegate = self
        viewcontroller.indexDoctor = indexPatchSection
        viewcontroller.idCate = listAllDoctor[sectionCate].category.id
        if isMyFeed {
            viewcontroller.isAdmin = true
        }else if isFollowing {
            viewcontroller.isAdmin = false
        }
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    func reloadDataDoctor(indexPatch: IndexPath, doctor: DoctorEntity) {
        listAllDoctor[indexPatch.section].doctors.append(doctor)
        questionTableView.reloadData()
    }
    
    func reloadDataAdmin(admin: ListAdminEntity) {
        listAdmin.append(admin)
        questionTableView.reloadData()
    }
    
    func gotoUpdateProfile(author: AuthorEntity, admin: ListAdminEntity, indexPatchAdmin: IndexPath) {
        let main = UIStoryboard(name: "User", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "AdminUpdateProfileViewController") as! AdminUpdateProfileViewController
        viewcontroller.admin = admin
        viewcontroller.author = author
        viewcontroller.isAdmin = self.isMyFeed
        viewcontroller.departmenName = listAllDoctor[sectionCate].category.name
        viewcontroller.departmenId = listAllDoctor[sectionCate].category.id
        viewcontroller.delegate = self
        self.indexPatchDoctor = indexPatchAdmin
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    func reloadDataUpdateProfile(author: AuthorEntity, admin: ListAdminEntity, isAdmin: Bool) {
        if !isAdmin {
            listAllDoctor[sectionCate].doctors[indexPatchDoctor.row - 1].doctorEntity = author
        }else {
            listAdmin[indexPatchDoctor.row - 1] = admin
        }
        questionTableView.reloadData()
    }
    
    
    
    func blockUser(author: AuthorEntity, admin: ListAdminEntity) {
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let userParam : [String : Any] = [
                "Auth": Until.getAuthKey(),
                "UserId": author.id,
                "RequestedUserId" : Until.getCurrentId()
            ]
            
            let adminParam : [String: Any] = [
                "Auth": Until.getAuthKey(),
                "UserId": admin.id,
                "RequestedUserId" : Until.getCurrentId()
            ]
            
            if isMyFeed {
                if admin.isBlocked {
                    Alamofire.request(UN_BLOCK_USER, method: .post, parameters: adminParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                        if let status = response.response?.statusCode {
                            if status == 200{
                                admin.isBlocked = false
                                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Tài khoản \(admin.fullName) đã được mở khoá thành công", cancelBtnTitle: "Đóng")
                                self.questionTableView.reloadData()
                            }else{
                            }
                        }else{
                            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                        }
                        
                    }
                }else {
                    Alamofire.request(BLOCK_USER, method: .post, parameters: adminParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                        if let status = response.response?.statusCode {
                            if status == 200{
                                admin.isBlocked = true
                                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Tài khoản \(admin.fullName) đã được khoá thành công", cancelBtnTitle: "Đóng")
                                self.questionTableView.reloadData()
                            }else{
                                //                            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                            }
                        }else{
                            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                        }
                        
                    }
                    
                }
            }else if isFollowing {
                if author.isBlocked {
                    Alamofire.request(UN_BLOCK_USER, method: .post, parameters: userParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                        if let status = response.response?.statusCode {
                            if status == 200{
                                author.isBlocked = false
                                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Tài khoản \(author.fullname) đã được mở khoá thành công", cancelBtnTitle: "Đóng")
                                self.questionTableView.reloadData()
                            }else{
                                //                            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                            }
                        }else{
                            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                        }
                        
                    }
                    
                }else {
                    Alamofire.request(BLOCK_USER, method: .post, parameters: userParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                        if let status = response.response?.statusCode {
                            if status == 200{
                                author.isBlocked = true
                                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Tài khoản \(author.fullname) đã được khoá thành công", cancelBtnTitle: "Đóng")
                                self.questionTableView.reloadData()
                            }else{
                                //                            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                            }
                        }else{
                            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                        }
                        
                    }
                }
            }
        } catch let error as NSError {
            print(error)
        }
        
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
    func requestLogOut(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let realm = try! Realm()
            let user = realm.objects(UserEntity.self).first
            let uuid = NSUUID().uuidString
            var token = ""
            if let value = UserDefaults.standard.object(forKey: NOTIFICATION_TOKEN) as? String {
                token = value
            }
            let device : [String : Any] = [
                "OS": 0,
                "DeviceId": uuid,
                "Token": token
            ]
            
            let logoutParam : [String : Any] = [
                "NicknameOrEmail": user!.nickname.isEmpty ? user?.socialId ?? "" : user?.nickname ?? "",
                "Device": device
            ]
            Until.showLoading()
            Alamofire.request(LOG_OUT, method: .post, parameters: logoutParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        Until.hideLoading()
                        try! realm.write {
                            realm.deleteAll()
                            let tabbar = self.tabBarController as? RAMAnimatedTabBarController
                            unreadMessageCount = 0
                            notificationCount = 0
                            tabbar?.tabBar.items![3].badgeValue = nil
                            tabbar?.setSelectIndex(from: 3, to: 0)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue:RELOAD_BOOKING), object: nil)
                            GIDSignIn.sharedInstance().disconnect()
                            self.refreshView()
                        }
                        listNotification.removeAll()
                    }else if status == 400 {
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Sai du", cancelBtnTitle: "Đóng")
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
            }
        } catch let error as NSError {
            print(error)
        }
        
        
    }

    @IBAction func settingTapAction(_ sender: Any) {
        requestLogOut()
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
    func gotoListQuestionByTag(hotTag: TagEntity) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionByTagViewController") as! QuestionByTagViewController
        viewController.hotTag = hotTag
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: receive notifiy when mark an comment is solution
    func reloadDataFromServer(notification : Notification){
        let isReloadMyPost = notification.object as? Bool ?? false
        if isReloadMyPost && !isMyFeed {
            pageMyFeed = 1
            listMyFeed.removeAll()
            getMyFeeds()
        }
        reloadData()
    }
    func selectDoctor(indexPath: IndexPath) {
        
    }
    
    func selectSpecialist(indexPath: IndexPath) {
        
    }
    
    func approVal(indexPath:IndexPath) {
        
    }
    
    func gotoUserProfileFromQuestionDoctor(doctor: AuthorEntity) {
        
    }
    
    func gotoUserProfileFromQuestionCell(user: AuthorEntity) {
        //khong can phai thuc hien ham nay vi dang trong trang profile cua chinh minh
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateInfoViewController") as! UpdateInfoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
