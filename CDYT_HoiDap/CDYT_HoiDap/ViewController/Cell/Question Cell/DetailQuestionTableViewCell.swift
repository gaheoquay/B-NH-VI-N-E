//
//  DetailQuestionTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit
protocol DetailQuestionTableViewCellDelegate {
    func replyToPost(feedEntity : FeedsEntity)
    func gotoLoginFromDetailQuestionVC()
}
class DetailQuestionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
    
    @IBOutlet weak var imgTag: UIImageView!
    var feed = FeedsEntity()
    var delegate : DetailQuestionTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        avaImg.layer.cornerRadius = 8
        imgCollectionView.delegate = self
        imgCollectionView.dataSource = self
        imgCollectionView.register(UINib.init(nibName: "AddImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddImageCollectionViewCell")
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.register(UINib.init(nibName: "KeywordCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "KeywordCollectionViewCell")
        
        commentCountLbl.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(replyToPost)))
        commentCountIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(replyToPost)))
        
        likeCountIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(likePostAction)))
    }

    func replyToPost(){
        delegate?.replyToPost(feedEntity: feed)
    }
    
    func likePostAction(){
        let userId = Until.getCurrentId()
        if userId == "" {
            delegate?.gotoLoginFromDetailQuestionVC()
        }else{
            let followParam : [String : Any] = [
                "Auth": Until.getAuthKey(),
                "RequestedUserId": userId,
                "PostId": feed.postEntity.id
            ]
            
            print(JSON.init(followParam))
            
            Until.showLoading()
            Alamofire.request(LIKE_POST, method: .post, parameters: followParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let isLike = jsonData["IsLiked"] as! Bool
                            
                            self.feed.isLiked = isLike
                            
                            if isLike {
                                self.feed.likeCount += 1
                            }else{
                                self.feed.likeCount -= 1
                            }
                            self.setData()
                            
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
            imgTag.isHidden = false
        }else{
            tagCollectionView.isHidden = true
            tagCollectionViewHeight.constant = 0
            imgTag.isHidden = true
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
            return feed.tags.count
        }else{
            return feed.postEntity.imageUrls.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordCollectionViewCell", for: indexPath) as! KeywordCollectionViewCell
            if feed.tags.count > 0 {
                cell.setData(tagName: feed.tags[indexPath.row].id)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageCollectionViewCell", for: indexPath) as! AddImageCollectionViewCell
                cell.imageView.sd_setImage(with: URL.init(string: feed.postEntity.thumbnailImageUrls[indexPath.row]), placeholderImage: UIImage.init(named: "placeholder_wide.png"))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tagCollectionView {
            let entity = feed.tags[indexPath.row]
            let tagName = "  " + entity.id + "  "
            let width = tagName.widthWithConstrainedHeight(height: 24, font: UIFont.systemFont(ofSize: 14))
            return CGSize.init(width: width, height: 24)
        }else{
            return CGSize.init(width: 230, height: 170)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
