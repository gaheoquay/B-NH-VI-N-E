//
//  DetailQuestionTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit
protocol DetailQuestionTableViewCellDelegate {
    func gotoLoginFromDetailQuestionVC()
    func gotoUserProfileFromDetailQuestion(user : AuthorEntity)
    func showMoreActionFromDetailQuestion()
    func showImageFromDetailPost(skBrowser : SKPhotoBrowser )
    func gotoQuestionTagListFromDetailPost(tagId : String)
}

class DetailQuestionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var imgCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var commentCountIcon: UIImageView!
    
    @IBOutlet weak var imgTag: UIImageView!
    @IBOutlet weak var moreActionBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
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
                
        likeCountLbl.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(likePostAction)))
        nameLbl.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(showUserProfile)))
        avaImg.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(showUserProfile)))
    }

    func showUserProfile(){
        if feed.postEntity.isPrivate != true || feed.authorEntity.id == Until.getCurrentId() {
        delegate?.gotoUserProfileFromDetailQuestion(user: feed.authorEntity)
        }
    }
    
    @IBAction func moreActionBtnTap(_ sender: Any) {
        delegate?.showMoreActionFromDetailQuestion()
    }
    
    @IBAction func likeBtnTapAction(_ sender: Any) {
        likePostAction()
    }
    
    //MARK: Like post action
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
                    }
                }else{
                }
                Until.hideLoading()
            }
        }
    }
    
    func setData(){
        
        let realm = try! Realm()
        if feed.postEntity.isPrivate != true || feed.authorEntity.id == Until.getCurrentId() {
            avaImg.sd_setImage(with: URL.init(string: feed.authorEntity.thumbnailAvatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut.png"))
            nameLbl.text = feed.authorEntity.nickname

        }else {
            nameLbl.text = "Ẩn Danh"
            avaImg.image = UIImage(named: "AvaDefaut.png")
        }
        
        timeLbl.text = String().convertTimeStampWithDateFormat(timeStamp: feed.postEntity.createdDate, dateFormat: "dd/MM/yy HH:mm")
        
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
            likeBtn.setImage(UIImage.init(named: "Clover1.png"), for: UIControlState.normal)
        }else{
            likeBtn.setImage(UIImage.init(named: "Clover0.png"), for: UIControlState.normal)
        }
        
        tagCollectionView.reloadData()
        imgCollectionView.reloadData()
      
      
      if let users = realm.objects(UserEntity.self).first {
        if users.id == feed.authorEntity.id || users.role == 2 {
          moreActionBtn.isHidden = false
        }else{
          moreActionBtn.isHidden = true
        }
      }else{
        moreActionBtn.isHidden = true
      }
      
        if feed.isFollowed {
            followBtn.setTitleColor(UIColor().hexStringToUIColor(hex: "3A3A3A"), for: UIControlState.normal)
            followBtn.setTitle("Bỏ theo dõi", for: UIControlState.normal)
        }else{
            followBtn.setTitleColor(UIColor().hexStringToUIColor(hex: "89D924"), for: UIControlState.normal)
            followBtn.setTitle("Theo dõi", for: UIControlState.normal)
        }
    }
    
    //MARK: Collection view delegate
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
                cell.imageView.sd_setImage(with: URL.init(string: feed.postEntity.thumbnailImageUrls[indexPath.row]), placeholderImage: UIImage.init(named:
                    "placeholder_wide.png"))
            cell.deleteBtn.isHidden = true

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imgCollectionView {
            var images = [SKPhoto]()
            
            for item in self.feed.postEntity.imageUrls{
                
                let photo = SKPhoto.photoWithImageURL(item)
                photo.shouldCachePhotoURLImage = true
                images.append(photo)
            }
            let browser = SKPhotoBrowser(photos: images)
            
            delegate?.showImageFromDetailPost(skBrowser: browser)
        }else{
           delegate?.gotoQuestionTagListFromDetailPost(tagId: feed.tags[indexPath.row].id)
        }
    }

    //MARK: Follow post
    @IBAction func followPostBtnAction(_ sender: Any) {
        let userId = Until.getCurrentId()
        if userId == "" {
            delegate?.gotoLoginFromDetailQuestionVC()
        }else{
            let followParam : [String : Any] = [
                "Auth": Until.getAuthKey(),
                "RequestedUserId": userId,
                "PostId": feed.postEntity.id
            ]
            
            print(followParam)
            Until.showLoading()
            Alamofire.request(FOLLOW_POST, method: .post, parameters: followParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let isFollowed = jsonData["IsFollowed"] as! Bool
                            
                            self.feed.isFollowed = isFollowed
                        
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
