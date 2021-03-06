//
//  EditCommentViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 1/16/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol EditCommentViewControllerDelegate {
    func cancelEditComment()
}
class EditCommentViewController: BaseViewController {

    @IBOutlet weak var commentImageTop: NSLayoutConstraint!
    @IBOutlet weak var commentImageHeigh: NSLayoutConstraint!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var contentTxt: UITextView!
    var delegate : EditCommentViewControllerDelegate?
    
    var isSubComment = false
    var subComment = SubCommentEntity()
    var mainComment = MainCommentEntity()
    var imageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentTxt.layer.cornerRadius = 5
        contentTxt.layer.borderWidth = 1
        contentTxt.layer.borderColor = UIColor().hexStringToUIColor(hex: "E6E6E6").cgColor
        
        setInitData()
        
    }
    
    func setInitData() {
        if isSubComment {
            contentTxt.text = subComment.comment.content
        }else{
            contentTxt.text = mainComment.comment.content
        }
    }
    @IBAction func chooseCommentImage(_ sender: Any) {
        
    }
    
    @IBAction func removeImage(_ sender: Any) {
        
    }
    
    
    @IBAction func updateTapAction(_ sender: Any) {
        if isSubComment {
            updateSubComment()
        }else{
            updateMainComment()
        }
    }
    
    @IBAction func cancelTapAction(_ sender: Any) {
        delegate?.cancelEditComment()
    }
    
    //MARK: Update comment content
    func updateMainComment(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            self.view.endEditing(true)
            let contentString = contentTxt.text
            let comment : [String : Any] = [
                "Id" : mainComment.comment.id,
                "Content" : contentString!,
                "ImageUrls" : mainComment.comment.imageUrls,
                "ThumbnailImageUrls" : mainComment.comment.thumbnailImageUrls,
                "IsSolution" : mainComment.comment.isSolution,
                "UpdatedDate" : 0,
                "CreatedDate" : mainComment.comment.createdDate
            ]
            
            let param : [String : Any] = [
                "RequestedUserId": Until.getCurrentId(),
                "Comment": comment
            ]
            Until.showLoading()
            Alamofire.request(UPDATE_COMMENT, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let isUpdated = jsonData["IsUpdated"] as! Bool
                            self.mainComment.comment.content = contentString!
                            
                            if isUpdated {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RELOAD_COMMENT_DETAIL), object: self.mainComment)
                                self.delegate?.cancelEditComment()
                                
                            }
                        }
                        
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
    
    //MARK: Update sub comment
    func updateSubComment(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            self.view.endEditing(true)
            let contentString = contentTxt.text
            let comment : [String : Any] = [
                "Id" : subComment.comment.id,
                "Content" : contentString!,
                "ImageUrls" : subComment.comment.imageUrls,
                "ThumbnailImageUrls" : subComment.comment.thumbnailImageUrls,
                "UpdatedDate" : 0,
                "CreatedDate" : subComment.comment.createdDate
            ]
            let param : [String : Any] = [
                "RequestedUserId": Until.getCurrentId(),
                "SubComment": comment
            ]
            Until.showLoading()
            Alamofire.request(UPDATE_SUBCOMMENT, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let isUpdated = jsonData["IsUpdated"] as! Bool
                            self.subComment.comment.content = contentString!
                            
                            if isUpdated {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RELOAD_SUBCOMMENT_DETAIL), object: self.subComment)
                                self.delegate?.cancelEditComment()
                            }
                        }
                        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
