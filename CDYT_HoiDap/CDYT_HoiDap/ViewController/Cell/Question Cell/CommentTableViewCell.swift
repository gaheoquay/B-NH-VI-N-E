//
//  CommentTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit
protocol CommentTableViewCellDelegate {
    func replyCommentAction(mainComment : MainCommentEntity)
    func gotoLoginFromCommentTableCell()
    func gotoUserProfileFromCommentCell(user : AuthorEntity)
}
class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var solutionLbl: UILabel!
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var imgComment: UIImageView!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var leftViewWidth: NSLayoutConstraint!
    @IBOutlet weak var avaImgHeight: NSLayoutConstraint!
    @IBOutlet weak var seperatorHeight: NSLayoutConstraint!
    
    @IBOutlet weak var replyLbl: UILabel!
    @IBOutlet weak var markToResolveBtn: UIButton!
    
    var delegate : CommentTableViewCellDelegate?
    var mainComment = MainCommentEntity()
    var subComment = SubCommentEntity()
    
    var isSubcomment = false
    let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var isMyPost = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avaImg.layer.cornerRadius = 8
        
        replyLbl.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(replyTapAction)))
        
        likeIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(likeCommentAction)))
        
        avaImg.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(gotoUserProfile)))
        nameLbl.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(gotoUserProfile)))
    }

    func gotoUserProfile(){
        if isSubcomment {
            delegate?.gotoUserProfileFromCommentCell(user: subComment.author)
        }else{
            delegate?.gotoUserProfileFromCommentCell(user: mainComment.author)
        }
        
    }
    
    func replyTapAction(){
        delegate?.replyCommentAction(mainComment: mainComment)
    }
    
    func likeCommentAction(){
        let userID = Until.getCurrentId()
        if userID == "" {
            delegate?.gotoLoginFromCommentTableCell()
        }else{
            var commentID = ""
            var param = ""
            if isSubcomment {
                commentID = subComment.comment.id
                param = LIKE_COMMENT_ON_COMMENT
            }else{
                commentID = mainComment.comment.id
                param = LIKE_COMMENT
            }
            
            let likeParam : [String : Any] = [
                "Auth": Until.getAuthKey(),
                "RequestedUserId": userID,
                "CommentId": commentID
            ]
            
            print(JSON.init(likeParam))
            
            Until.showLoading()
            Alamofire.request(param, method: .post, parameters: likeParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let isLike = jsonData["IsLiked"] as! Bool
                            
                            if self.isSubcomment {
                                self.subComment.isLike = isLike
                                if isLike {
                                    self.subComment.likeCount += 1
                                }else{
                                    self.subComment.likeCount -= 1
                                }
                                self.setDataForSubComment()
                            }else{
                                self.mainComment.isLike = isLike
                                if isLike {
                                    self.mainComment.likeCount += 1
                                }else{
                                    self.mainComment.likeCount -= 1
                                }
                                self.setDataForMainComment()
                            }
                        }
                    }else{
                        //                    UIAlertController().showAlertWith(title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    //                UIAlertController().showAlertWith(title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
            }
        
        }
    }
    
    func setDataForMainComment() {
        isSubcomment = false
        
        if mainComment.comment.isSolution {
            self.contentView.backgroundColor = UIColor().hexStringToUIColor(hex: "F1FDEA")
            solutionLbl.isHidden = false
            
            if isMyPost {
                solutionLbl.text = "Bạn đã chọn làm giải pháp"
                markToResolveBtn.isHidden = false
                markToResolveBtn.isUserInteractionEnabled = true
            }else{
                solutionLbl.text = "Câu trả lời được chọn làm giải pháp"
                markToResolveBtn.isHidden = true
                markToResolveBtn.isUserInteractionEnabled = false
            }
            
            markToResolveBtn.setImage(UIImage.init(named: "GiaiPhap_Mark.png"), for: UIControlState.normal)
            markToResolveBtn.isHidden = false
        }else{
            self.contentView.backgroundColor = UIColor.white
            
            solutionLbl.isHidden = true
            solutionLbl.text = ""
            
            if isMyPost {
                markToResolveBtn.isHidden = false
            }else{
                markToResolveBtn.isHidden = true
            }
            
            markToResolveBtn.setImage(UIImage.init(named: "GiaiPhap_Mark_hide.png"), for: UIControlState.normal)
        }
        
        avaImg.sd_setImage(with: URL.init(string: mainComment.author.thumbnailAvatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut.png"))
        nameLbl.text = mainComment.author.nickname
        timeLbl.text = String().convertTimeStampWithDateFormat(timeStamp: mainComment.comment.createdDate, dateFormat: "dd/MM/yy HH:mm")
        
        if mainComment.comment.imageUrls.count > 0 {
            imgComment.isHidden = false
            imgHeight.constant = 140
            imgComment.sd_setImage(with: URL.init(string: mainComment.comment.thumbnailImageUrls[0]), placeholderImage: UIImage.init(named: "placeholder_wide.png"))
        }else{
            imgComment.isHidden = true
            imgHeight.constant = 0
        }
        
        contentLbl.text = mainComment.comment.content
        
        if mainComment.isLike {
            likeIcon.image = UIImage.init(named: "Clover1.png")
        }else{
            likeIcon.image = UIImage.init(named: "Clover0.png")
        }
        
        likeCountLbl.text = "\(mainComment.likeCount)"
        
        leftViewWidth.constant = 0
        avaImgHeight.constant = 50
        
        if mainComment.subComment.count > 0 {
            seperatorHeight.constant = 0
        }else{
            seperatorHeight.constant = 1
        }
    }
    
    func setDataForSubComment() {
        isSubcomment = true
        markToResolveBtn.isHidden = true
        
        solutionLbl.isHidden = true
        solutionLbl.text = ""
        
        avaImg.sd_setImage(with: URL.init(string: subComment.author.thumbnailAvatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut.png"))
        nameLbl.text = subComment.author.nickname
        timeLbl.text = String().convertTimeStampWithDateFormat(timeStamp: subComment.comment.createdDate, dateFormat: "dd/MM/yy HH:mm")
        
        if subComment.comment.imageUrls.count > 0 {
            imgComment.isHidden = false
            imgHeight.constant = 130
            imgComment.sd_setImage(with: URL.init(string: subComment.comment.thumbnailImageUrls[0]), placeholderImage: UIImage.init(named: "placeholder_wide.png"))
        }else{
            imgComment.isHidden = true
            imgHeight.constant = 0
        }
        
        contentLbl.text = subComment.comment.content
        
        if subComment.isLike {
            likeIcon.image = UIImage.init(named: "Clover1.png")
        }else{
            likeIcon.image = UIImage.init(named: "Clover0.png")
        }
        
        likeCountLbl.text = "\(subComment.likeCount)"
        
        leftViewWidth.constant = 60
        avaImgHeight.constant = 30
    }
    
    @IBAction func markSolutionTapAction(_ sender: Any) {
        let userID = Until.getCurrentId()
        if userID == "" {
            delegate?.gotoLoginFromCommentTableCell()
        }else{
            
            let markParam : [String : Any] = [
                "Auth": Until.getAuthKey(),
                "RequestedUserId": userID,
                "CommentId": mainComment.comment.id
            ]
            
            print(JSON.init(markParam))
            
            Until.showLoading()
            Alamofire.request(MARK_AS_SOLUTION, method: .post, parameters: markParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let comment = CommentEntity.init(dictionary: jsonData)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RELOAD_ALL_DATA), object: comment)
                        }
                    }else{
                        UIAlertController().showAlertWith(vc: self.appDel.window!.rootViewController!, title: "Thông báo", message: "Có lỗi xảy ra, vui lòng thử lai sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self.appDel.window!.rootViewController!, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lai sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
            }
            
        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
