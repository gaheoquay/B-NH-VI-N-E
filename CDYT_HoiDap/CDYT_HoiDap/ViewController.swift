//
//  ViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,KeyWordTableViewCellDelegate, QuestionTableViewCellDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(reloadDataFromServer(notification:)), name: Notification.Name.init(RELOAD_ALL_DATA), object: nil)
    
    setupUI()
    initTableView()
    Until.showLoading()
    getFeeds()
    getHotTagFromServer()
    // Do any additional setup after loading the view, typically from a nib.
  }

    func setupUI() {
        searchView.layer.cornerRadius = 8
        searchView.clipsToBounds = true
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
//        self.tbQuestion.pullToRefreshView?.startAnimating()
        self.reloadData()
      }
    }
    tbQuestion.addInfiniteScrollingWithHandler {
      DispatchQueue.main.async {
//        self.tbQuestion.infiniteScrollingView?.startAnimating()
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
  func gotoListQuestionByTag(hotTagId: String) {
    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionByTagViewController") as! QuestionByTagViewController
    viewController.hotTagId = hotTagId
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  
//  MARK: request server
  func getHotTagFromServer(){
    
    let hotParam : [String : Any] = [
      "Auth": Until.getAuthKey(),
      "Page": 1,
      "Size": 10,
      "RequestedUserId" : Until.getCurrentId()
    ]
//    Until.showLoading()
    Alamofire.request(HOTEST_TAG, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
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
      }else{
        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
      }
//      Until.hideLoading()
    }
  }

  func getFeeds(){
    let hotParam : [String : Any] = [
      "Auth": Until.getAuthKey(),
      "Page": page,
      "Size": 10,
      "RequestedUserId" : Until.getCurrentId()
    ]
//    Until.showLoading()
    print(JSON.init(hotParam))
    Alamofire.request(GET_FEEDS, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
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

  }
  
//MARK: UIViewController,UITableViewDelegate
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
        }
      
      cell.setData()
      return cell
    }
  }
    
    //MARK: QuestionTableViewCellDelegate
    func showQuestionDetail(indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
        vc.feedObj = listFedds[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoUserProfileFromQuestionCell(user: AuthorEntity) {
        if user.id == Until.getCurrentId() {
//            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//            let viewController = storyboard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
//            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            let storyboard = UIStoryboard.init(name: "User", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "OtherUserViewController") as! OtherUserViewController
            viewController.user = user
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
     
//    MARK: Action
  
  @IBAction func gotoSearch(_ sender: Any) {
    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
    self.navigationController?.pushViewController(viewController, animated: true)
  }
    @IBAction func addQuestionTapAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddQuestionViewController") as! AddQuestionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: receive notifiy when mark an comment is solution
    func reloadDataFromServer(notification : Notification){
        reloadData()
    }
    
//MARK: Outlet
  @IBOutlet weak var tbQuestion: UITableView!
    @IBOutlet weak var searchView: UIView!
  var listFedds = [FeedsEntity]()
  var listHotTag = [HotTagEntity]()
  var page = 1
  var canLoadMore = true
}

