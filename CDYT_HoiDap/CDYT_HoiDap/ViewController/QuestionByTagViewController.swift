//
//  QuestionByTagViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class QuestionByTagViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, QuestionTableViewCellDelegate {
  
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
    lbTitle.text = hotTagId
  }
  //MARK: init table view
  func initTableView(){
    tbQuestion.dataSource = self
    tbQuestion.delegate = self
    tbQuestion.estimatedRowHeight = 999
    tbQuestion.rowHeight = UITableViewAutomaticDimension
    tbQuestion.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
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
    listFedds.removeAll()
    getFeeds()
  }
  func loadMore(){
    page += 1
    getFeeds()
  }

//  MARK: Action
  
  @IBAction func actionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  //  MARK: request data
  func getFeeds(){
    let hotParam : [String : Any] = [
      "Auth": Until.getAuthKey(),
      "Page": page,
      "Size": 10,
      "RequestedUserId" : Until.getCurrentId(),
      "Tag" : hotTagId
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
      self.tbQuestion.pullToRefreshView?.stopAnimating()
      self.tbQuestion.infiniteScrollingView?.stopAnimating()
    }
    
  }

  //MARK: UIViewController,UITableViewDelegate
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listFedds.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as! QuestionTableViewCell
    cell.indexPath = indexPath
    cell.delegate = self
    cell.feedEntity = listFedds[indexPath.row]
    cell.setData()
    return cell
  }

    //MARK: QuestionTableViewCellDelegate
    func showQuestionDetail(indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
        vc.feedObj = listFedds[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
  func gotoListQuestionByTag(hotTagId: String) {
    return
//    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionByTagViewController") as! QuestionByTagViewController
//    viewController.hotTagId = hotTagId
//    self.navigationController?.pushViewController(viewController, animated: true)
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
    
//  MARK: Outlet
  @IBOutlet weak var lbTitle: UILabel!
  @IBOutlet weak var tbQuestion: UITableView!
  var listFedds = [FeedsEntity]()
  var hotTagId = ""
  var page = 1
}
