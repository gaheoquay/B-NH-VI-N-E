//
//  DetailQuestionTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class DetailQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var resolveIcon: UIImageView!
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var imgCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var likeCountIcon: UIImageView!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var commentCountIcon: UIImageView!
    
    var feed = FeedsEntity()
    override func awakeFromNib() {
        super.awakeFromNib()
        avaImg.layer.cornerRadius = 5
        
    }

    func setData(){
        avaImg.sd_setImage(with: URL.init(string: feed.authorEntity.thumbnailAvatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut.png"))
        nameLbl.text = feed.authorEntity.nickname
        timeLbl.text = String().convertTimeStampWithDateFormat(timeStamp: feed.postEntity.createdDate, dateFormat: "dd/MM/yy HH:mm")
        
        if feed.postEntity.status == 0 {
            resolveIcon.isHidden = true
        }else{
            resolveIcon.isHidden = false
        }
        
        if feed.tags.count > 0 {
            tagCollectionView.isHidden = false
            tagCollectionViewHeight.constant = 24
        }else{
            tagCollectionView.isHidden = true
            tagCollectionViewHeight.constant = 0
        }
        
        titleLbl.text = feed.postEntity.title
        contentLbl.text = feed.postEntity.content
        
        if feed.postEntity.imageUrls.count > 0 {
            imgCollectionView.isHidden = false
            imgCollectionViewHeight.constant = 170
        }else{
            imgCollectionView.isHidden = true
            imgCollectionViewHeight.constant = 0
        }
        
        likeCountLbl.text = "\(feed.likeCount)"
        commentCountLbl.text = "\(feed.commentCount)"
        
        if feed.isLiked {
            likeCountIcon.image = UIImage.init(named: "Clover1.png")
        }else{
            likeCountIcon.image = UIImage.init(named: "Clover0.png")
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
