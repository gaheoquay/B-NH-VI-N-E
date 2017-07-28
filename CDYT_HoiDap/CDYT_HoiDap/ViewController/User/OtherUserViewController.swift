//
//  OtherUserViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 1/11/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class OtherUserViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, QuestionTableViewCellDelegate {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var feedTbl: UITableView!
    var selectedUser: [SBDUser] = []
    
    var user = AuthorEntity()
    var page = 1
    var listFeeds = [FeedsEntity]()
    private var users: [SBDUser] = []
    private var userListQuery: SBDUserListQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        Until.showLoading()
        getFeeds()
        setupUserData()
        self.loadUserList(initial: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: USER_PAGE)
    }
    
    func setupUserData() {
        avaImg.layer.cornerRadius = 8
        avaImg.clipsToBounds = true
        avaImg.sd_setImage(with: URL.init(string: user.thumbnailAvatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut.png"))
        nameLbl.text = user.fullname
    }
    
    func configTableView(){
        feedTbl.delegate = self
        feedTbl.dataSource = self
        feedTbl.register(UINib.init(nibName: "RecentFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentFeedTableViewCell")
        feedTbl.register(UINib.init(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        feedTbl.estimatedRowHeight = 500
        feedTbl.rowHeight = UITableViewAutomaticDimension
        
        feedTbl.addPullToRefreshHandler {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
        
        feedTbl.addInfiniteScrollingWithHandler {
            DispatchQueue.main.async {
                self.loadMore()
            }
        }
        
    }
    
    func reloadData(){
        page = 1
        listFeeds.removeAll()
        getFeeds()
    }
    
    func loadMore(){
        page += 1
        getFeeds()
    }
    
    func getFeeds(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let param : [String : Any] = [
                "Page": page,
                "Size": 10,
                "UserId": user.id,
                "RequestedUserId" : Until.getCurrentId()
                
            ]
            
            Alamofire.request(GET_QUESTION_FOLLOW_BY_USER, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! [NSDictionary]
                            
                            for item in jsonData {
                                let entity = FeedsEntity.init(dictionary: item)
                                self.listFeeds.append(entity)
                            }
                            
                            self.feedTbl.reloadData()
                            
                        }
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
                self.feedTbl.pullToRefreshView!.stopAnimating()
                self.feedTbl.infiniteScrollingView!.stopAnimating()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    //MARK: Table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listFeeds.count > 0 {
            return listFeeds.count + 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentFeedTableViewCell") as! RecentFeedTableViewCell
            cell.titleLbl.text = "Hoạt động gần đây"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as! QuestionTableViewCell
            cell.indexPath = indexPath
            cell.delegate = self
            cell.feedEntity = listFeeds[indexPath.row - 1]
            cell.setData(isHiddenCateAndDoctor: false)
            return cell
        }
    }
    
    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func accountTapAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateInfoViewController") as! UpdateInfoViewController
        vc.otherUserId = user.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func messageTapAction(_ sender: Any) {
        let realm = try! Realm()
        let currentUser = realm.objects(UserEntity.self)
        if currentUser.count == 0 {
            Until.gotoLogin(_self: self, cannotBack: false)
        }else{
            if currentUser.first?.role == 0 {
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng nâng cấp để sử dụng chức năng này", cancelBtnTitle: "Đồng ý")
                return
            }else if currentUser.first?.role == 1 || currentUser.first?.role == 2 {
                if user.role == 0 {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn không thể chat với người này", cancelBtnTitle: "Đồng ý")
                    return
                }
            }
            SBDGroupChannel.createChannel(with: self.selectedUser, isDistinct: true) { (channel, error) in
                if error != nil {
                    let vc = UIAlertController(title: "Lỗi", message: error?.domain, preferredStyle: UIAlertControllerStyle.alert)
                    let closeAction = UIAlertAction(title: "Đóng", style: UIAlertActionStyle.cancel, handler: { (action) in
                        
                    })
                    vc.addAction(closeAction)
                    DispatchQueue.main.async {
                        self.present(vc, animated: true, completion: nil)
                    }
                    return
                }
                DispatchQueue.main.async {
                    let vc = GroupChannelChattingViewController()
                    vc.groupChannel = channel
                    self.present(vc, animated: false, completion: nil)
                }
            }
        }
    }
    //MARK: Load list user to chat
    @objc private func loadUserList(initial: Bool) {
        if initial == true {
            self.users.removeAll()
            self.selectedUser.removeAll()
            
            
            self.userListQuery = nil;
        }
        if self.userListQuery == nil {
            self.userListQuery = SBDMain.createAllUserListQuery()
            self.userListQuery = SBDMain.createUserListQuery(withUserIds: [user.id])
            self.userListQuery?.limit = 25
        }
        if self.userListQuery?.hasNext == false {
            return
        }
        
        self.userListQuery?.loadNextPage(completionHandler: { (users, error) in
            if error != nil {
                let vc = UIAlertController(title: "Lỗi", message: error?.domain, preferredStyle: UIAlertControllerStyle.alert)
                let closeAction = UIAlertAction(title: "Đóng", style: UIAlertActionStyle.cancel, handler:nil)
                vc.addAction(closeAction)
                DispatchQueue.main.async {
                    self.present(vc, animated: true, completion: nil)
                }
                return
            }
            
            for user in users! as [SBDUser] {
                self.selectedUser.append(user)
            }
        })
    }
    
    //MARK: QuestionTableViewCellDelegate
    func showQuestionDetail(indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
        vc.feedObj = listFeeds[indexPath.row - 1]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoListQuestionByTag(hotTag: TagEntity) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "QuestionByTagViewController") as! QuestionByTagViewController
        viewController.hotTag = hotTag
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func gotoUserProfileFromQuestionCell(user: AuthorEntity) {
        //ko can thiet thuc hien ham nay vi dang o trong trang profile cua nguoi dung nay roi
    }
    
    func selectDoctor(indexPath: IndexPath) {
        
    }
    func selectSpecialist(indexPath: IndexPath) {
        
    }
    
    func approVal(indexPath: IndexPath) {
        
    }
    
    func gotoUserProfileFromQuestionDoctor(doctor: AuthorEntity) {
        
    }
}
