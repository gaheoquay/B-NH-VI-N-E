//
//  QuestionDetailViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class QuestionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MoreCommentTableViewCellDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CommentTableViewCellDelegate, DetailQuestionTableViewCellDelegate {

    @IBOutlet weak var detailTbl: UITableView!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var imgCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var keyboardViewHeight: NSLayoutConstraint!
    
    var feed = FeedsEntity()
    var listComment = [MainCommentEntity]()
    
    let textInputBar = ALTextInputBar()
    let keyboardObserver = ALKeyboardObservingView()
    
    let pickerController = DKImagePickerController()
    var imageAssets = [DKAsset]()

    var imgCommentDic = [String]()
    var thumImgCommentDic = [String]()
    var isCommentOnComment = false
    
    var currComment = MainCommentEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configTable()
        getListCommentByPostID()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(notification:)), name: NSNotification.Name(rawValue: ALKeyboardFrameDidChangeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        configInputBar()
        setupImagePicker()
        
        imgCollectionViewHeight.constant = 0
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func configTable(){
        detailTbl.delegate = self
        detailTbl.dataSource = self
        detailTbl.estimatedRowHeight = 1000
        detailTbl.rowHeight = UITableViewAutomaticDimension
        detailTbl.register(UINib.init(nibName: "DetailQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailQuestionTableViewCell")
        detailTbl.register(UINib.init(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        detailTbl.register(UINib.init(nibName: "MoreCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "MoreCommentTableViewCell")
        
        imgCollectionView.delegate = self
        imgCollectionView.dataSource = self
        imgCollectionView.register(UINib.init(nibName: "AddImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddImageCollectionViewCell")
    }
    
    func configInputBar(){
        let rightButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 50, height: 30))
        rightButton.setTitle("GỬI", for: UIControlState.normal)
        rightButton.setTitleColor(UIColor().hexStringToUIColor(hex: "01a7fa"), for: UIControlState.normal)
        rightButton.addTarget(self, action: #selector(postCommentAction), for: .touchUpInside)
        
        let leftButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        leftButton.setImage(UIImage(named: "Camera.png"), for: UIControlState.normal)
        leftButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        
        
        keyboardObserver.isUserInteractionEnabled = false
        textInputBar.textView.placeholder = "Nhập nội dung thảo luận..."
        textInputBar.showTextViewBorder = true
        textInputBar.horizontalPadding = 5
        textInputBar.alwaysShowRightButton = true
        textInputBar.horizontalSpacing = 5
        textInputBar.rightView = rightButton
        
        textInputBar.leftView = leftButton
        textInputBar.frame = CGRect.init(x: 0, y: view.frame.size.height - textInputBar.defaultHeight, width: view.frame.size.width, height: textInputBar.defaultHeight)
        textInputBar.textView.maxNumberOfLines = 6
        textInputBar.keyboardObserver = keyboardObserver
        view.addSubview(textInputBar)
        
    }
    
    //MARK: Post comment tap action
    func postCommentAction(){
        let stringComent = textInputBar.text!
        if stringComent == "" {
            let alert = UIAlertController(title: "Thông Báo", message: "Bình luận không được để trống", preferredStyle: .alert)
            let OkeAction: UIAlertAction = UIAlertAction(title: "Đóng", style: .cancel) { action -> Void in
                self.textInputBar.becomeFirstResponder()
            }
            alert.addAction(OkeAction)
            self.present(alert, animated: true, completion: nil)
        }else {
            if imageAssets.count > 0 {
                uploadImage()
            }else{
                if isCommentOnComment {
                    sendCommentOnComment(mainComment: currComment)
                }else{
                    sendCommentToServer()
                }
            }
        }
    }
    
    func uploadImage(){
        Until.showLoading()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (index, element) in self.imageAssets.enumerated(){
                element.fetchOriginalImage(true, completeBlock: {(image, info) -> Void in
                    if let imageData = UIImageJPEGRepresentation(image!, 0.5) {
                        multipartFormData.append(imageData, withName: "Image", fileName: "file\(index).png", mimeType: "image/png")
                    }
                })
            }
        }, to: UPLOAD_IMAGE, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let status = response.response?.statusCode
                    if status == 200{
                        if let result = response.result.value {
                            let json = result as! [NSDictionary]
                            for dic in json {
                                let imageUrl = dic["ImageUrl"] as! String
                                self.imgCommentDic.append(imageUrl)
                                
                                let imageThumb = dic["ThumbnailUrl"] as! String
                                self.thumImgCommentDic.append(imageThumb)
                            }
                            self.sendCommentToServer()
                        }
                    }
                    Until.hideLoading()
                }
                
            case .failure(let encodingError):
                print(encodingError)
                Until.hideLoading()
            }
        })
    }
    
    func sendCommentToServer(){
        self.view.endEditing(true)
        
        let commentEntity = CommentEntity()
        commentEntity.content = textInputBar.text
        commentEntity.imageUrls = imgCommentDic
        commentEntity.thumbnailImageUrls = thumImgCommentDic
        
        let commentParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": Until.getCurrentId(),
            "Comment": CommentEntity().toDictionary(entity: commentEntity),
            "PostId": feed.postEntity.id
        ]
        
        print(JSON.init(commentParam))
        Until.showLoading()
        
        Alamofire.request(POST_COMMENT, method: .post, parameters: commentParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        let entity = MainCommentEntity.init(dict: jsonData)
                        
                        self.listComment.append(entity)
                        self.detailTbl.reloadData()
                        
                        self.textInputBar.textView.text = ""
                        self.imgCommentDic = []
                        self.thumImgCommentDic = []
                        
                        self.imgCollectionViewHeight.constant = 0
                        self.imageAssets.removeAll()
                        self.imgCollectionView.reloadData()
                        self.view.layoutIfNeeded()
                        
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
    
    func pickImage(){
        self.present(pickerController, animated: true, completion: nil)
    }
    
    //  MARK: Keyboard
    func keyboardWillShow(notification:NSNotification){
        if let userInfo = notification.userInfo {
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            textInputBar.frame.origin.y = frame.origin.y
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.keyboardViewHeight.constant = frame.size.height
                
            }
        }
    }
    
    func keyboardWillHide(notification:NSNotification){
        if let userInfo = notification.userInfo {
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            UIView.animate(withDuration:0) {
                self.keyboardViewHeight.constant = frame.size.height
                self.textInputBar.frame.origin.y = frame.origin.y
                
            }
        }
    }
    
    func keyboardFrameChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            UIView.animate(withDuration: 0.2, animations: {
                self.keyboardViewHeight.constant = frame.size.height
                self.textInputBar.frame.origin.y = frame.origin.y
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return keyboardObserver
        }
    }
    
    // This is also required
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    func setupImagePicker(){
        pickerController.assetType = DKImagePickerControllerAssetType.allPhotos
        pickerController.maxSelectableCount = 1
        pickerController.didSelectAssets = { [unowned self] ( assets: [DKAsset]) in
            self.imageAssets = assets
            if assets.count > 0 {
                self.imgCollectionViewHeight.constant = 70
            }else{
                self.imgCollectionViewHeight.constant = 0
            }
            self.view.layoutIfNeeded()
            self.imgCollectionView.reloadData()

        }
    }
    
    func getListCommentByPostID(){
        let hotParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "Page": 1,
            "Size": 10,
            "RequestedUserId" : Until.getCurrentId(),
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
            let entity = listComment[section - 1]
            
            if entity.isShowMore {
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
            cell.delegate = self
            return cell
        }else{
            let entity = listComment[indexPath.section - 1]
            if entity.isShowMore {
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
                    cell.mainComment = listComment[indexPath.section - 1]
                    cell.setDataForMainComment()
                    cell.delegate = self
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
                    cell.mainComment = listComment[indexPath.section - 1]
                    cell.subComment = listComment[indexPath.section - 1].subComment[indexPath.row - 1]
                    cell.setDataForSubComment()
                    cell.delegate = self
                    return cell
                }
            }else{
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
                    cell.mainComment = listComment[indexPath.section - 1]
                    cell.setDataForMainComment()
                    cell.delegate = self
                    return cell
                }else{
                    if listComment[indexPath.section - 1].subComment.count > 1 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCommentTableViewCell") as! MoreCommentTableViewCell
                        cell.commentEntity = listComment[indexPath.section - 1]
                        cell.setData()
                        cell.delegate = self
                        return cell
                    }else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
                        cell.mainComment = listComment[indexPath.section - 1]
                        cell.subComment = listComment[indexPath.section - 1].subComment[indexPath.row - 1]
                        cell.setDataForSubComment()
                        cell.delegate = self
                        return cell

                    }
                }
            }
        }
    }
    
    //MARK: Collection view delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageCollectionViewCell", for: indexPath) as! AddImageCollectionViewCell
        let asset = imageAssets[indexPath.row]
        asset.fetchOriginalImage(true) { (image, info) in
            cell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 60, height: 60)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    //MARK: DetailQuestionTableViewCellDelegate
    func replyToPost(feedEntity: FeedsEntity) {
        textInputBar.textView.placeholder = "Nhập nội dung thảo luận"
        textInputBar.becomeFirstResponder()
        isCommentOnComment = false
        
    }
    
    //MARK: MoreCommentTableViewCellDelegate
    func showMoreSubcomment() {
        detailTbl.reloadData()
    }
    
    //MARK: CommentTableViewCellDelegate
    func replyCommentAction(mainComment: MainCommentEntity) {
        textInputBar.textView.placeholder = "@trả lời bình luận của \(mainComment.author.nickname)"
        textInputBar.becomeFirstResponder()
        
        currComment = mainComment
        isCommentOnComment = true
    }
    
    func sendCommentOnComment(mainComment : MainCommentEntity){
        self.view.endEditing(true)
        
        let commentEntity = CommentEntity()
        commentEntity.content = textInputBar.text
        commentEntity.imageUrls = imgCommentDic
        commentEntity.thumbnailImageUrls = thumImgCommentDic
        
        let commentParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": Until.getCurrentId(),
            "Comment": CommentEntity().toDictionary(entity: commentEntity),
            "CommentId": mainComment.comment.id
        ]
        
        print(JSON.init(commentParam))
        Until.showLoading()
        
        Alamofire.request(POST_COMMENT_ON_COMMENT, method: .post, parameters: commentParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        let entity = SubCommentEntity.init(dict: jsonData)
                        
                        mainComment.subComment.append(entity)
                        self.detailTbl.reloadData()
                        
                        self.textInputBar.textView.text = ""
                        self.imgCommentDic = []
                        self.thumImgCommentDic = []
                        
                        self.imgCollectionViewHeight.constant = 0
                        self.imageAssets.removeAll()
                        self.imgCollectionView.reloadData()
                        self.view.layoutIfNeeded()
                        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}
