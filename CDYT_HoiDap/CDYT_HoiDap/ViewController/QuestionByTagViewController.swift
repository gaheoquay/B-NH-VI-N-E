//
//  QuestionByTagViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class QuestionByTagViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource, QuestionTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        initTableView()
        getFeeds()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: DETAILS_TAG)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //  MARK: bindData
    func bindData(){
        lbTitle.text = hotTag?.tagName ?? ""
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
                "RequestedUserId" : Until.getCurrentId(),
                "Tag" : hotTag?.id ?? ""
            ]
            Until.showLoading()
            Alamofire.request(GET_QUESTION_BY_TAG, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
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
    
    //MARK: UIViewController,UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFedds.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as! QuestionTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        if listFedds.count > 0 {
            cell.feedEntity = listFedds[indexPath.row]
        }
        cell.setData(isHiddenCateAndDoctor: false)
        return cell
    }
    
    //MARK: QuestionTableViewCellDelegate
    func showQuestionDetail(indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
        vc.feedObj = listFedds[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func gotoListQuestionByTag(hotTag: TagEntity) {
        return
        //    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionByTagViewController") as! QuestionByTagViewController
        //    viewController.hotTagId = hotTagId
        //    self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func gotoUserProfileFromQuestionCell(user: AuthorEntity) {
        if user.id == Until.getCurrentId() {
            let storyboard = UIStoryboard.init(name: "User", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UpdateInfoViewController") as! UpdateInfoViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let storyboard = UIStoryboard.init(name: "User", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "OtherUserViewController") as! OtherUserViewController
            viewController.user = user
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func selectSpecialist(indexPath: IndexPath) {
        
    }
    func selectDoctor(indexPath: IndexPath) {
        
    }
    
    func approVal(indexPath: IndexPath) {
        
    }
    
    func gotoUserProfileFromQuestionDoctor(doctor: AuthorEntity) {
        
    }
    
    //  MARK: Outlet
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tbQuestion: UITableView!
    var listFedds = [FeedsEntity]()
    var hotTag: TagEntity?
    var page = 1
}
