//
//  QuestionTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit
protocol QuestionTableViewCellDelegate {
    func showQuestionDetail(indexPath : IndexPath)
  func gotoListQuestionByTag(hotTagId: String)
    func gotoUserProfileFromQuestionCell(user : AuthorEntity)
}
class QuestionTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegateLeftAlignedLayout {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    clvTags.dataSource = self
    clvTags.delegate = self
    clvTags.register(UINib.init(nibName: "KeywordCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "KeywordCollectionViewCell")
    
    lbTitle.isUserInteractionEnabled = true
    lbTitle.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(showDetailQuestion)))
    
    lbContent.isUserInteractionEnabled = true
    lbContent.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(showDetailQuestion)))
    
    leftView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(showDetailQuestion)))
    
    lbAuthor.isUserInteractionEnabled = true
    lbAuthor.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(showUserProfile)))
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
    func showDetailQuestion(){
        delegate?.showQuestionDetail(indexPath: self.indexPath)
    }
    
    func showUserProfile(){
        delegate?.gotoUserProfileFromQuestionCell(user: feedEntity.authorEntity)
    }
    
  @IBAction func showDetail(_ sender: Any) {
    delegate?.showQuestionDetail(indexPath: self.indexPath)
  }
  
  func setData(){
    if feedEntity.postEntity.status == 0 {
        leftView.backgroundColor = UIColor().hexStringToUIColor(hex: "f4f4f4")

    }else{
        leftView.backgroundColor = UIColor().hexStringToUIColor(hex: "C7ECA1")
    }
    lbTitle.text = feedEntity.postEntity.title
    lbContent.text = feedEntity.postEntity.content
    lbLikeCount.text = String(feedEntity.likeCount)
    lbCommentCount.text = String(feedEntity.commentCount)
    let fontRegular = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
    let fontWithColor = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName: UIColor.init(netHex: 0x87baef)]
    let myAttrString = NSMutableAttributedString(string: "Hỏi bởi : ", attributes: fontRegular)
    myAttrString.append(NSAttributedString(string: feedEntity.authorEntity.nickname, attributes: fontWithColor))
    lbAuthor.attributedText = myAttrString
    lbCreateDate.text = String().convertTimeStampWithDateFormat(timeStamp: feedEntity.postEntity.createdDate, dateFormat: "dd/MM/yy HH:mm")
    if feedEntity.tags.count == 0 {
      layoutHeighTag.constant = 0
      layoutTopTag.constant = 0
      layoutBottomTag.constant = 0
      clvTags.isHidden = true
      imgTag.isHidden = true
    }else{
      layoutHeighTag.constant = 24
      layoutBottomTag.constant = 6
      layoutTopTag.constant = 6
      clvTags.isHidden = false
      imgTag.isHidden = false
    }
    self.contentView.layoutIfNeeded()
    clvTags.reloadData()
  }
  //  MARK:UICollectionViewDataSource
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return feedEntity.tags.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordCollectionViewCell", for: indexPath) as! KeywordCollectionViewCell
    if feedEntity.tags.count > 0 {
      cell.setData(tagName: feedEntity.tags[indexPath.row].id)
    }
    return cell
  }
  
  // MARK: UICollectionViewDelegateLeftAlignedLayout
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if feedEntity.tags.count > 0 {
      let entity = feedEntity.tags[indexPath.row]
      let tagName = "  " + entity.id + "  "
      let width = tagName.widthWithConstrainedHeight(height: 24, font: UIFont.systemFont(ofSize: 14))
      return CGSize.init(width: width, height: 24)
    }
    return CGSize.init(width: 0, height: 0)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.gotoListQuestionByTag(hotTagId: feedEntity.tags[indexPath.row].id)
  }

//  MARK: Outlet
  @IBOutlet weak var lbLikeCount: UILabel!
  @IBOutlet weak var lbCommentCount: UILabel!
  @IBOutlet weak var lbTitle: UILabel!
  @IBOutlet weak var lbContent: UILabel!
  @IBOutlet weak var clvTags: UICollectionView!
  @IBOutlet weak var lbAuthor: UILabel!
  @IBOutlet weak var lbCreateDate: UILabel!
  var feedEntity = FeedsEntity()
  @IBOutlet weak var imgTag: UIImageView!
  @IBOutlet weak var layoutHeighTag: NSLayoutConstraint!
  @IBOutlet weak var layoutTopTag: NSLayoutConstraint!
  @IBOutlet weak var layoutBottomTag: NSLayoutConstraint!
    @IBOutlet weak var leftView: UIView!
    
    var delegate : QuestionTableViewCellDelegate?
    var indexPath = IndexPath()
}
