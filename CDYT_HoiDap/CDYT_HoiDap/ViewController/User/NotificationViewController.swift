//
//  NotificationViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, QuestionDetailViewControllerDelegate ,CommentViewControllerDelegate {
    @IBOutlet weak var notifyTableView: UITableView!
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Until.sendAndSetTracer(value: NOTIFICATION)
    }
    //MARK: Set up table
    func setupTableView(){
        notifyTableView.dataSource = self
        notifyTableView.delegate = self
        notifyTableView.estimatedRowHeight = 200
        notifyTableView.rowHeight = UITableViewAutomaticDimension
        notifyTableView.register(UINib.init(nibName: "NotifyTableViewCell", bundle: nil), forCellReuseIdentifier: "NotifyTableViewCell")
        notifyTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        notifyTableView.addPullToRefreshHandler {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
        
        notifyTableView.addInfiniteScrollingWithHandler {
            DispatchQueue.main.async {
                self.loadMore()
            }
        }
        
    }
    
    func reloadData(){
        page = 1
        listNotification.removeAll()
        getListNotification()
    }
    
    func loadMore(){
        page += 1
        getListNotification()
    }
    
    //MARK: get list notification
    func getListNotification(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]

            let requestUrl = GET_LIST_NOTIFICATION_BY_PAGING + "?page=\(page)&size=\(10)"
            Alamofire.request(requestUrl, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let data = jsonData["Data"] as! [NSDictionary]
                            for item in data {
                                let entity = NotificationNewEntity.init(dictionary: item)
                                listNotification.append(entity)
                            }
                        }
                        self.notifyTableView.reloadData()
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                self.notifyTableView.pullToRefreshView?.stopAnimating()
                self.notifyTableView.infiniteScrollingView?.stopAnimating()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyTableViewCell") as! NotifyTableViewCell
        if listNotification.count > 0 {
            cell.setData(entity: listNotification[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let entity = listNotification[indexPath.row]
        if entity.type == 1 || entity.type == 3 || entity.type == 6 || entity.type == 8 {
            let viewController = storyBoard.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
            viewController.questionID = (entity.parenId)
            viewController.notification = entity
            viewController.delegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            let viewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
            if entity.type == 0 || entity.type == 4 || entity.type == 5{
                viewController.commentId = (entity.detailId)
            }else if entity.type == 2{
                viewController.commentId = (entity.parenId)
            }
            
            viewController.notification = entity
            viewController.delegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    //  MARK: QuestionDetailViewControllerDelegate, CommentViewControllerDelegate
    func reloadTable() {
        notifyTableView.reloadData()
    }
    //  MARK: CommentViewControllerDelegate
    func removeSubCommentFromCommentView(subComment: SubCommentEntity) {}
    
    func removeMainCommentFromCommentView(mainComment: MainCommentEntity) {}
    
    //MARK: Action
    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
