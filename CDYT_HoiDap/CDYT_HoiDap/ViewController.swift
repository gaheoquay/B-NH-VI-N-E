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
  initTableView()
    getFeeds()
    getHotTagFromServer()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
  //MARK: init table view
  func initTableView(){
    tbQuestion.dataSource = self
    tbQuestion.delegate = self
    tbQuestion.estimatedRowHeight = 999
    tbQuestion.rowHeight = UITableViewAutomaticDimension
    tbQuestion.register(UINib.init(nibName: "KeyWordTableViewCell", bundle: nil), forCellReuseIdentifier: "KeyWordTableViewCell")
    tbQuestion.register(UINib.init(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")

  }
//  MARK: KeyWordTableViewCellDelegate
  func gotoListQuestionByTag(indexpath: IndexPath) {
    let entity = listHotTag[indexpath.row]
    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionByTagViewController") as! QuestionByTagViewController
    viewController.hotTagEntity = entity
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
    
    print(JSON.init(hotParam))
    
    Until.showLoading()
    Alamofire.request(HOTEST_TAG, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! [NSDictionary]
            
            for item in jsonData {
              let hotTag = HotTagEntity.init(dictionary: item)
              self.listHotTag.append(hotTag)
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

  func getFeeds(){
    let hotParam : [String : Any] = [
      "Auth": Until.getAuthKey(),
      "Page": 1,
      "Size": 10,
      "RequestedUserId" : Until.getCurrentId()
    ]
    print(JSON.init(hotParam))
    Until.showLoading()
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
      cell.feedEntity = listFedds[indexPath.row]
      cell.setData()
      return cell

    }
  }
    
    //MARK: QuestionTableViewCellDelegate
    func showQuestionDetail(indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
        vc.feed = listFedds[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
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
//MARK: Outlet
  @IBOutlet weak var tbQuestion: UITableView!
  var listFedds = [FeedsEntity]()
  var listHotTag = [HotTagEntity]()
  var page = 1
}

