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
    
    var delegate : CommentTableViewCellDelegate?
    var mainComment = MainCommentEntity()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avaImg.layer.cornerRadius = 8
        
        replyLbl.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(replyTapAction)))
    }

    func replyTapAction(){
        delegate?.replyCommentAction(mainComment: mainComment)
    }
    
    func setDataForMainComment() {
        if mainComment.comment.isSolution {
            solutionLbl.isHidden = false
            self.contentView.backgroundColor = UIColor().hexStringToUIColor(hex: "F1FDEA")
        }else{
            solutionLbl.isHidden = true
            solutionLbl.text = ""
            self.contentView.backgroundColor = UIColor.white
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
    
    func setDataForSubComment(commentEntity: SubCommentEntity) {
        if commentEntity.comment.isSolution {
            solutionLbl.isHidden = false
        }else{
            solutionLbl.isHidden = true
            solutionLbl.text = ""
        }
        
        avaImg.sd_setImage(with: URL.init(string: commentEntity.author.thumbnailAvatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut.png"))
        nameLbl.text = commentEntity.author.nickname
        timeLbl.text = String().convertTimeStampWithDateFormat(timeStamp: commentEntity.comment.createdDate, dateFormat: "dd/MM/yy HH:mm")
        
        if commentEntity.comment.imageUrls.count > 0 {
            imgComment.isHidden = false
            imgHeight.constant = 130
            imgComment.sd_setImage(with: URL.init(string: commentEntity.comment.thumbnailImageUrls[0]), placeholderImage: UIImage.init(named: "placeholder_wide.png"))
        }else{
            imgComment.isHidden = true
            imgHeight.constant = 0
        }
        
        contentLbl.text = commentEntity.comment.content
        
        if commentEntity.isLike {
            likeIcon.image = UIImage.init(named: "Clover1.png")
        }else{
            likeIcon.image = UIImage.init(named: "Clover0.png")
        }
        
        likeCountLbl.text = "\(commentEntity.likeCount)"
        
        leftViewWidth.constant = 60
        avaImgHeight.constant = 30
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
