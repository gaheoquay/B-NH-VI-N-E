//
//  UserViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var questionTableView: UITableView!
    var page = 1
    var listMyFeed = [FeedsEntity]()
    var userID = ""
    var userEntity = UserEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        avaImg.layer.cornerRadius = 10
        self.navigationController?.isNavigationBarHidden = true
        
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.register(UINib.init(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        questionTableView.estimatedRowHeight = 500
        questionTableView.rowHeight = UITableViewAutomaticDimension
        questionTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        if users.count > 0 {
            userEntity = users.first!
        }
        
        setupUserInfo()
        getFeeds()
    }
    
    func setupUserInfo(){
        avaImg.sd_setImage(with: URL.init(string: userEntity.avatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut"))
        nicknameLbl.text = userEntity.nickname
    }

    func getFeeds(){
        
        
        let hotParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "Page": page,
            "Size": 10,
            "UserId": userID == "" ? userEntity.id : userID,
            "RequestedUserId" : userEntity.id
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
    }
    
    @IBAction func settingTapAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
