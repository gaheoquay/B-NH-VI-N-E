//
//  QuestionDetailViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class QuestionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var detailTbl: UITableView!
    
    var feed = FeedsEntity()
    var listComment = [MainCommentEntity]()
    var isShowMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        configTable()
        getListCommentByPostID()
    }

    func configTable(){
        detailTbl.delegate = self
        detailTbl.dataSource = self
        detailTbl.estimatedRowHeight = 1000
        detailTbl.rowHeight = UITableViewAutomaticDimension
        detailTbl.register(UINib.init(nibName: "DetailQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailQuestionTableViewCell")
        detailTbl.register(UINib.init(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        detailTbl.register(UINib.init(nibName: "MoreCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "MoreCommentTableViewCell")
        
    }
    
    func getListCommentByPostID(){
        var requestedUserId = ""
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        if users.count > 0 {
            requestedUserId = users.first!.id
            
        }
        
        let hotParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "Page": 1,
            "Size": 10,
            "RequestedUserId" : requestedUserId,
            "PostId": feed.postEntity.id
        ]
        print(JSON.init(hotParam))
        Until.showLoading()
        Alamofire.request(GET_LIST_COMMENT_BY_POSTID, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! [NSDictionary]
                        
                        for item in jsonData {
                            let entity = MainCommentEntity.init(dict: item)
                            self.listComment.append(entity)
                        }
                        
                        self.detailTbl.reloadData()
                        
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi không thể lấy được dữ liệu Bình luận. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + listComment.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listComment.count > 0 && section != 0 {
            if isShowMore {
                return listComment[section - 1].subComment.count + 1
            }else{
                if listComment[section - 1].subComment.count > 1 {
                    return 2
                }else{
                    return listComment[section - 1].subComment.count + 1
                }
            }
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailQuestionTableViewCell") as! DetailQuestionTableViewCell
            cell.feed = self.feed
            cell.setData()
            return cell
        }else{
            if isShowMore {
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
                    cell.setDataForMainComment(commentEntity: listComment[indexPath.section - 1])
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCommentTableViewCell") as! MoreCommentTableViewCell
                    cell.commentEntity = listComment[indexPath.section - 1]
                    cell.setData()
                    return cell
                }
            }else{
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
                    cell.setDataForMainComment(commentEntity: listComment[indexPath.section - 1])
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
                    cell.setDataForSubComment(commentEntity: listComment[indexPath.section - 1].subComment[indexPath.row - 1])
                    return cell
                }
            }
            
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
