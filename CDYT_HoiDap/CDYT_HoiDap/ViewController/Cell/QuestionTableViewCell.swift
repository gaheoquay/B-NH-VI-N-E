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
    func selectSpecialist(indexPath : IndexPath)
    func selectDoctor(indexPath : IndexPath)
    func approVal(indexPath : IndexPath)
}
class QuestionTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegateLeftAlignedLayout {
    
    var isPrivate = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewCate.layer.borderColor = UIColor().hexStringToUIColor(hex: "d6d6d6").cgColor
        viewCate.layer.borderWidth = 1
        viewDoctor.layer.borderWidth = 1
        viewDoctor.layer.borderColor = UIColor().hexStringToUIColor(hex: "d6d6d6").cgColor
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
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self).first

        if !feedEntity.postEntity.isPrivate || users?.id == feedEntity.authorEntity.id {
            delegate?.gotoUserProfileFromQuestionCell(user: feedEntity.authorEntity)
        }
    }
    
    @IBAction func showDetail(_ sender: Any) {
        delegate?.showQuestionDetail(indexPath: self.indexPath)
    }
    
    
    
    func setData(isHiddenCateAndDoctor :Bool){
        let colorbtnApproval = UIColor().hexStringToUIColor(hex: "61abfa")
        let colorbtnUnapproval = UIColor().hexStringToUIColor(hex: "6d6d6d")
        
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self).first
        
        
        if users == nil || users?.role == 0 || users?.role == 1  {
            viewCate.isHidden = true
            viewDoctor.isHidden = true
            imgApproval.isHidden = true
            btnApproval.isHidden = true
            heightViewCate.constant = 0
            layoutBottomViewCate.constant = 0
            layoutBottomCreateDate.constant = 50
        }else {
            layoutBottomViewCate.constant = 8
            if isHiddenCateAndDoctor {
                if feedEntity.postEntity.isClassified {
                    lbCate.text = feedEntity.cateGory.name
                    lbDoctor.text = feedEntity.assigneeEntity.fullname
                    btnApproval.setTitle("Đã \nduyệt", for: .normal)
                    btnApproval.setTitleColor(colorbtnUnapproval, for: .normal)
                    imgApproval.image = UIImage(named: "DaDuyet_1.png")
                }else if feedEntity.cateGory.id != "" {
                    if feedEntity.assigneeEntity.id == "" {
                        lbDoctor.text = "---Bác sĩ(Tất cả)---"
                    }else {
                        lbDoctor.text = feedEntity.assigneeEntity.fullname
                    }
                    lbCate.text = feedEntity.cateGory.name
                    btnApproval.isEnabled = true
                    btnCate.isEnabled = true
                    btnDoctor.isEnabled = true
                    btnApproval.setTitle("Duyệt", for: .normal)
                    btnApproval.setTitleColor(colorbtnApproval, for: .normal)
                    imgApproval.image = UIImage(named: "Duyet_1.png")
                }else {
                    lbDoctor.text = "---Bác sĩ(Tất cả)---"
                    lbCate.text = "---Chuyên khoa---"
                    btnApproval.isEnabled = true
                    btnCate.isEnabled = true
                    btnDoctor.isEnabled = true
                    btnApproval.setTitle("Duyệt", for: .normal)
                    btnApproval.setTitleColor(colorbtnApproval, for: .normal)
                    imgApproval.image = UIImage(named: "Duyet_1.png")
                }
              viewCate.isHidden = false
              viewDoctor.isHidden = false
              imgApproval.isHidden = false
              btnApproval.isHidden = false
            }else {
                viewCate.isHidden = true
                viewDoctor.isHidden = true
                imgApproval.isHidden = true
                btnApproval.isHidden = true
                heightViewCate.constant = 0
            }
        }
        
        
        
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
        let myAttrString = NSMutableAttributedString(string: "Hỏi bởi ", attributes: fontRegular)
        if feedEntity.postEntity.isPrivate != true || users?.id == feedEntity.authorEntity.id {
            myAttrString.append(NSAttributedString(string: feedEntity.authorEntity.nickname, attributes: fontWithColor))
            
        }else{
            myAttrString.append(NSAttributedString(string: "Ẩn danh", attributes: fontWithColor))
        }
        
        if feedEntity.firstCommentedDoctor.id != "" {
            let myAttrStringDoctor = NSMutableAttributedString(string: "Trả lời bởi : ", attributes: fontRegular)
            myAttrStringDoctor.append(NSAttributedString(string: feedEntity.firstCommentedDoctor.fullname, attributes: fontWithColor))
            lbNameDoctor.attributedText = myAttrStringDoctor
            lbTimeAnswerDoctor.text = String().convertTimeStampWithDateFormat(timeStamp: feedEntity.firstCommentTime, dateFormat: "dd/MM/yy HH:mm")
        }else {
            layoutBottomCreateDate.constant = 0
            
        }
        
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
    
    @IBAction func btnSpecicalList(_ sender: Any) {
        delegate?.selectSpecialist(indexPath: indexPath)
        
    }
    
    @IBAction func btnSelectDocTor(_ sender: Any) {
        delegate?.selectDoctor(indexPath: indexPath)
        
    }
    
    @IBAction func btnAproval(_ sender: Any) {
        delegate?.approVal(indexPath: indexPath)
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
    @IBOutlet weak var imgApproval: UIImageView!
    @IBOutlet weak var lbCate: UILabel!
    @IBOutlet weak var lbDoctor: UILabel!
    @IBOutlet weak var viewCate: UIView!
    @IBOutlet weak var viewDoctor: UIView!
    @IBOutlet weak var btnApproval: UIButton!
    @IBOutlet weak var btnCate: UIButton!
    @IBOutlet weak var btnDoctor: UIButton!
    @IBOutlet weak var heightViewCate: NSLayoutConstraint!
    @IBOutlet weak var layoutBottomViewCate: NSLayoutConstraint!
    @IBOutlet weak var lbTimeAnswerDoctor: UILabel!
    @IBOutlet weak var lbNameDoctor: UILabel!
    @IBOutlet weak var layoutBottomCreateDate: NSLayoutConstraint!
    
    
    var delegate : QuestionTableViewCellDelegate?
    var indexPath = IndexPath()
    var pickerFrame = CGRect(x: 0, y: 50, width: 270, height: 150)
    
}
