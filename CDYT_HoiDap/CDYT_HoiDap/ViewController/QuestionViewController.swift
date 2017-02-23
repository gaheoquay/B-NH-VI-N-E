//
//  QuestionViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class QuestionViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource, QuestionTableViewCellDelegate ,UIPickerViewDelegate,UIPickerViewDataSource {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(reloadDataFromServer(notification:)), name: Notification.Name.init(RELOAD_ALL_DATA), object: nil)
    
    requestServer()
    initTableView()
    Until.showLoading()
    getFeeds()
    
  }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: SLECT_QUESTION_NO_ANSWER)
        isHiddent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tbQuestion.reloadData()
        
    }
  
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
    
  //  MARK: request data
  func getFeeds(){
    let hotParam : [String : Any] = [
      "Auth": Until.getAuthKey(),
      "Page": page,
      "Size": 10,
      "RequestedUserId" : Until.getCurrentId()
    ]
//    Until.showLoading()
    Alamofire.request(GET_UNANSWER, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! [NSDictionary]
            
            for item in jsonData {
              let entity = FeedsEntity.init(dictionary: item)
              self.listFedds.append(entity)
            }
            
            
          }
          self.tbQuestion.reloadData()
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
    cell.delegate = self
    cell.indexPath = indexPath
    if listFedds.count > 0 {
        cell.feedEntity = listFedds[indexPath.row]
    }
    cell.setData(isHiddenCateAndDoctor: true)
    return cell
  }
  
    //MARK: QuestionTableViewCellDelegate
    func showQuestionDetail(indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
        vc.feedObj = listFedds[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
  func gotoListQuestionByTag(hotTagId: String) {
    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionByTagViewController") as! QuestionByTagViewController
    viewController.hotTagId = hotTagId
    self.navigationController?.pushViewController(viewController, animated: true)
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
    
    //MARK: receive notifiy when mark an comment is solution
    func reloadDataFromServer(notification : Notification){
        reloadData()
    }
    
    func selectSpecialist(indexPath: IndexPath) {
        creatAlert(title: "Special List",picker: pickerViewCate)
        indexPathOfCell = indexPath

    }
    
    func selectDoctor(indexPath: IndexPath) {
        if listDoctorInCate.count > 0 {
            indexPathOfCell = indexPath
            creatAlert(title: "Select Doctor",picker: pickerViewDoctor)
            
        }else {
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn khoa trước", cancelBtnTitle: "Đóng")
            
        }

    }
    
    func creatAlert(title: String, picker: UIPickerView){
        let alertView = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        
        
        
        alertView.view.addSubview(picker)
        
        picker.delegate = self
        picker.dataSource = self
        
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.listFedds[self.indexPathOfCell.row].ischeck = true
            self.tbQuestion.reloadRows(at: [self.indexPathOfCell], with: .automatic)
            
        })
        
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }
    
    func requestServer(){
        let hotParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            ]
      
        Until.showLoading()
        Alamofire.request(GET_LIST_DOCTOR, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! [NSDictionary]
                        
                        for item in jsonData {
                            let entity = ListDoctorEntity.init(dictionary: item)
                            listAllDoctor.append(entity)
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
    
     
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewCate {
            return listCate.count
        }else {
            return listDoctorInCate.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewCate {
            return listCate[row].name
        }else {
            
            return listDoctorInCate[row].fullname
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewCate {
            idCate = listCate[row].id
            nameCate = listCate[row].name
            listFedds[indexPathOfCell.row].cateGory.id = idCate
            listFedds[indexPathOfCell.row].cateGory.name = nameCate
            
            for item in listAllDoctor {
                if item.category.id == idCate {
                    listDoctorInCate = item.doctors
                }
            }
            
        }else{
            idDoc = listDoctorInCate[row].id
            nameDoc = listDoctorInCate[row].fullname
            listFedds[indexPathOfCell.row].assigneeEntity.id = idDoc
            listFedds[indexPathOfCell.row].assigneeEntity.fullname = nameDoc
        }
        
    }
    
    func requestApproval(){
        
        let post : [String : Any] = [
            "Id" : listFedds[indexPathOfCell.row].postEntity.id,
            "Title" : listFedds[indexPathOfCell.row].postEntity.title,
            "Content" : listFedds[indexPathOfCell.row].postEntity.content,
            "ImageUrls" : listFedds[indexPathOfCell.row].postEntity.imageUrls,
            "ThumbnailImageUrls" : listFedds[indexPathOfCell.row].postEntity.thumbnailImageUrls,
            "Status" : 0,
            "Rating" : 0,
            "UpdatedDate" : 0,
            "CategoryId": idCate,
            "IsPrivate": listFedds[indexPathOfCell.row].postEntity.isPrivate,
            "IsClassified": false,
            "CreatedDate" : 0
        ]
        
        let questionParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": Until.getCurrentId(),
            "Post": post,
            "AssignToUserId": idDoc
        ]
        Alamofire.request(GET_LASTED_POST, method: .post, parameters: questionParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    self.listFedds[self.indexPathOfCell.row].ischeck = false
                    self.tbQuestion.reloadData()
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
        
        
    }
    
    func approVal() {
        if listDoctorInCate.count > 0 && nameDoc != "" {
            requestApproval()
        }else{
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn khoa và bác sĩ", cancelBtnTitle: "Đóng")
        }
    }
    
    
    
  //  MARK: Outlet
  @IBOutlet weak var tbQuestion: UITableView!
  var listFedds = [FeedsEntity]()
  var page = 1
    let pickerViewDoctor = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
    let pickerViewCate = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
    
    var indexPathOfCell = IndexPath()
    var idCate = ""
    var idDoc = ""
    var nameCate = ""
    var nameDoc = ""
    var ischeckHide = true
    var listDoctorInCate = [AuthorEntity]()
  
    
}
