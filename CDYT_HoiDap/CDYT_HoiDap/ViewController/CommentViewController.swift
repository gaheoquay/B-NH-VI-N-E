//
//  CommentViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 1/10/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol CommentViewControllerDelegate {
  func reloadTable()
  func removeMainCommentFromCommentView(mainComment : MainCommentEntity)
  func removeSubCommentFromCommentView(subComment : SubCommentEntity)

}

class CommentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CommentTableViewCellDelegate, EditCommentViewControllerDelegate, WYPopoverControllerDelegate, AddImageCollectionViewCellDelegate {

    @IBOutlet weak var commentTbl: UITableView!
    @IBOutlet weak var keyboardViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgClv: UICollectionView!
    @IBOutlet weak var imgClvHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var resolveImg: UIImageView!
    
    let textInputBar = ALTextInputBar()
    let keyboardObserver = ALKeyboardObservingView()

    let pickerController = DKImagePickerController()
    var imageAssets = [DKAsset]()
    
    var imgCommentDic = [String]()
    var thumImgCommentDic = [String]()
    var pageIndex = 1
    var mainComment = MainCommentEntity()
    var currentUserId = ""
    var feedEntity = FeedsEntity()
    var commentId = ""
  var notification : NotificationNewEntity!
  var notificationId = ""
  var delegate:CommentViewControllerDelegate?

    var popupViewController:WYPopoverController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        configTable()
        configInputBar()
        setupImagePicker()
        
        imgClvHeight.constant = 0
        currentUserId = Until.getCurrentId()
    
        if commentId != "" {
            getCommentFromNotification()
        }
      if (notification != nil && !(notification.isRead)) || !notificationId.isEmpty {
        setReadNotification()
      }

        //Check feedEntity is exsit or not
        if feedEntity.postEntity.title != "" {
            setupData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: DETAIL_COMMENT)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(notification:)), name: NSNotification.Name(rawValue: ALKeyboardFrameDidChangeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMainCommentAfterUpdated(notification:)), name: Notification.Name.init(RELOAD_COMMENT_DETAIL), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSubCommentAfterUpdated(notification:)), name: Notification.Name.init(RELOAD_SUBCOMMENT_DETAIL), object: nil)
   
    }
    
    func configTable(){
        commentTbl.delegate = self
        commentTbl.dataSource = self
        commentTbl.estimatedRowHeight = 1000
        commentTbl.rowHeight = UITableViewAutomaticDimension
        commentTbl.register(UINib.init(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        
        imgClv.delegate = self
        imgClv.dataSource = self
        imgClv.register(UINib.init(nibName: "AddImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddImageCollectionViewCell")

        if commentId != "" {
            commentTbl.addPullToRefreshHandler {
                DispatchQueue.main.async {
                    self.reloadData()
                    
                }
            }
            
            commentTbl.addInfiniteScrollingWithHandler {
                DispatchQueue.main.async {
                    self.loadMore()
                }
            }
        }
        
    }
    
    func reloadData(){
        pageIndex = 1
        getCommentFromNotification()
    }
    
    func loadMore(){
        pageIndex += 1
        getCommentFromNotification()
    }
    
    //MARK: Setup UI
    func setupData(){
        titleLbl.text = feedEntity.postEntity.title
        if feedEntity.postEntity.status == 0 {
            resolveImg.image = UIImage.init(named: "GiaiPhap_Mark_hide.png")
        }else{
            resolveImg.image = UIImage.init(named: "GiaiPhap_Mark.png")
        }
    }
    
    //MARK: UPdate UI for comment
    func setupUIForComment(mainComment : MainCommentEntity){
        titleLbl.text = mainComment.post.title
        if mainComment.post.status == 0 {
            resolveImg.image = UIImage.init(named: "GiaiPhap_Mark_hide.png")
        }else{
            resolveImg.image = UIImage.init(named: "GiaiPhap_Mark.png")
        }
    }
    //MARK: Select image and upload
    func setupImagePicker(){
        pickerController.assetType = DKImagePickerControllerAssetType.allPhotos
        pickerController.maxSelectableCount = 1
        pickerController.didSelectAssets = { [unowned self] ( assets: [DKAsset]) in
            self.imageAssets = assets
            if assets.count > 0 {
                self.imgClvHeight.constant = 70
            }else{
                self.imgClvHeight.constant = 0
            }
            self.view.layoutIfNeeded()
            self.imgClv.reloadData()
            
        }
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
    
    //  MARK: Keyboard showing
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
  //MARk: set read notification
  func setReadNotification(){
    Until.showLoading()
    if notificationId == ""{
      notificationId = notification.id
    }
    let getPostParam : [String : Any] = [
      "Auth": Until.getAuthKey(),
      "RequestedUserId" : Until.getCurrentId(),
      "NotificationId": notificationId
    ]
    
    
    Alamofire.request(SET_READ_NOTIFICATION, method: .post, parameters: getPostParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            if result is NSDictionary {
                let realm = try! Realm()
                try! realm.write {
                  if self.notification != nil {
                    self.notification.isRead = true
                  }
                    self.delegate?.reloadTable()
                }
            }
          }
        }
      }
      
      Until.hideLoading()
    }
    
  }

    //MARK: get comment from notification
    func getCommentFromNotification(){
        self.view.endEditing(true)
        
        let commentParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": currentUserId,
            "CommentId": commentId,
            "Page": pageIndex,
            "Size": "10"
        ]
        
        Until.showLoading()
        
        Alamofire.request(GET_LIST_SUBCOMMENT, method: .post, parameters: commentParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary 
                        let entity = MainCommentEntity.init(dict: jsonData)
                      if self.pageIndex == 1{
                        self.mainComment = entity
                      }else{
                        self.mainComment.subComment += entity.subComment
                      }
                      
                        self.setupUIForComment(mainComment: self.mainComment)
                        self.commentTbl.reloadData()
                        
                    }
                }else{
                    let alert = UIAlertController.init(title: "Thông báo", message: "Có lỗi không thể lấy được dữ liệu bình luận", preferredStyle: UIAlertControllerStyle.alert)
                    let actionOk = UIAlertAction.init(title: "Đóng", style: UIAlertActionStyle.default, handler: { (action) in
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(actionOk)
                    self.present(alert, animated: true, completion: nil)

                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
          self.commentTbl.pullToRefreshView?.stopAnimating()
          self.commentTbl.infiniteScrollingView?.stopAnimating()
        }
    }
    
    //MARK: Table view delegate and datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mainComment.subComment.count > 0 {
            return 1 + mainComment.subComment.count
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
            if currentUserId == feedEntity.authorEntity.id {
                cell.isMyPost = true
            }else{
                cell.isMyPost = false
            }
            cell.delegate = self
            cell.indexPath = indexPath
            cell.mainComment = mainComment
            cell.setDataForMainComment()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
            cell.mainComment = mainComment
            cell.subComment = mainComment.subComment[indexPath.row - 1]
            cell.delegate = self
            cell.setDataForSubComment()
            cell.indexPath = indexPath
            return cell
        }
    }
    
    //MARK: Collection view delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageCollectionViewCell", for: indexPath) as! AddImageCollectionViewCell
        cell.delegate = self
        let asset = imageAssets[indexPath.row]
        asset.fetchOriginalImage(true) { (image, info) in
            cell.imageView.image = image
        }
        cell.deleteBtn.isHidden = true
        return cell
    }
    
    
    func deleteImageAction(indexPath: IndexPath) {
        imageAssets.removeAll()
        imgClv.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 110, height: 110)
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
                            self.sendCommentOnComment()
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
    
    //MARK: Post comment tap action
    func postCommentAction(){
        if Until.getCurrentId() != "" {
            let stringComent = textInputBar.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
                    sendCommentOnComment()
                }
            }
        }else{
            Until.gotoLogin(_self: self, cannotBack: false)
        }
    }
    
    func sendCommentOnComment(){
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
        
        Until.showLoading()
        
        Alamofire.request(POST_COMMENT_ON_COMMENT, method: .post, parameters: commentParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        let entity = SubCommentEntity.init(dict: jsonData)
                        
                        self.mainComment.subComment.insert(entity, at: 0)
                        self.commentTbl.reloadData()
                        
                        self.textInputBar.textView.text = ""
                        self.imgCommentDic = []
                        self.thumImgCommentDic = []
                        
                        self.imgClvHeight.constant = 0
                        self.imageAssets.removeAll()
                        self.imgClv.reloadData()
                        self.view.layoutIfNeeded()
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: COMMENT_ON_COMMENT_SUCCESS), object: nil)

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
    
    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    //MARK: Delete comment
    func deleteComment(objID : String, isSubcomment : Bool, indexPath: IndexPath, subComment: SubCommentEntity){
        Until.showLoading()
        let param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": currentUserId,
            "DeletedObjectId": objID
        ]
        
        
        Alamofire.request(DELETE_ALL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        let isDelete = jsonData["IsDeleted"] as! Bool
                        if isDelete {

                            if isSubcomment {
                                for (index, item) in self.mainComment.subComment.enumerated() {
                                    if item.comment.id == objID {
                                        self.mainComment.subComment.remove(at: index)
                                    }
                                }
                                self.commentTbl.reloadData()
                                self.delegate?.removeSubCommentFromCommentView(subComment: subComment)
                            }else{
                                self.delegate?.removeMainCommentFromCommentView(mainComment: self.mainComment)
                                _ = self.navigationController?.popViewController(animated: true)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RELOAD_ALL_DATA), object: nil)
                            }
                            
                            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Xoá bình luận thành công", cancelBtnTitle: "Đóng")
                            
                        }else{
                            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không thế xoá bình luận, vui lòng thử lại sau.", cancelBtnTitle: "Đóng")
                        }
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi không thể xoá bài viết. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }
    }
    
    //MARK: CommentTableViewCellDelegate
  func markOrUnmarkSolution(mainComment: MainCommentEntity) {}
    func replyCommentAction(mainComment : MainCommentEntity){
        textInputBar.textView.becomeFirstResponder()
    }
    
    func gotoLoginFromCommentTableCell(){
        Until.gotoLogin(_self: self, cannotBack: false)
    }
    
    func gotoUserProfileFromCommentCell(user : AuthorEntity){
        if user.id == Until.getCurrentId() {
            //            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            //            let viewController = storyboard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
            //            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            let storyboard = UIStoryboard.init(name: "User", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "OtherUserViewController") as! OtherUserViewController
            viewController.user = user
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func showMoreActionCommentFromCommentCell(isSubcomment : Bool, subComment: SubCommentEntity, mainComment : MainCommentEntity, indexPath : IndexPath){
        self.view.endEditing(true)
        if mainComment.comment.isSolution {
            if subComment.comment.id != "" {
                let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let editTap = UIAlertAction(title: "Chỉnh sửa", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    if self.popupViewController == nil {
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let popoverVC = mainStoryboard.instantiateViewController(withIdentifier: "EditCommentViewController") as! EditCommentViewController
                        popoverVC.isSubComment = isSubcomment
                        popoverVC.subComment = subComment
                        popoverVC.mainComment = mainComment
                        popoverVC.delegate = self
                        popoverVC.preferredContentSize = CGSize.init(width: 320, height: 250)
                        popoverVC.isModalInPopover = false
                        self.popupViewController = WYPopoverController(contentViewController: popoverVC)
                        self.popupViewController.delegate = self
                        self.popupViewController.wantsDefaultContentAppearance = false;
                        self.popupViewController.presentPopover(from: CGRect.init(x: 0, y: 0, width: 0, height: 0), in: self.view, permittedArrowDirections: WYPopoverArrowDirection.none, animated: true, options: WYPopoverAnimationOptions.fade, completion: nil)
                        
                    }
                })
                
                let deleteTap = UIAlertAction(title: "Xoá", style: .destructive, handler: {
                    (alert: UIAlertAction!) -> Void in
                    
                    let alert = UIAlertController.init(title: "Thông báo", message: "Bạn có chắc chắn xoá bình luận này?", preferredStyle: UIAlertControllerStyle.alert)
                    let noAction = UIAlertAction.init(title: "Huỷ", style: UIAlertActionStyle.cancel, handler: nil)
                    let yesAction = UIAlertAction.init(title: "Xoá", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
                        if isSubcomment {
                            self.deleteComment(objID: subComment.comment.id, isSubcomment: isSubcomment, indexPath: indexPath, subComment: subComment)
                        }else{
                            self.deleteComment(objID: mainComment.comment.id, isSubcomment: isSubcomment, indexPath: indexPath, subComment: subComment)
                        }
                    })
                    
                    alert.addAction(noAction)
                    alert.addAction(yesAction)
                    self.present(alert, animated: true, completion: nil)
                })
                
                let cancelTap = UIAlertAction(title: "Huỷ bỏ", style: .cancel, handler: {
                    (alert: UIAlertAction!) -> Void in
                })
                
                optionMenu.addAction(editTap)
                optionMenu.addAction(deleteTap)
                optionMenu.addAction(cancelTap)
                
                self.present(optionMenu, animated: true, completion: nil)
                return
            }
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn không thể xoá được bình luận này", cancelBtnTitle: "Đóng")

        }else {
            let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let editTap = UIAlertAction(title: "Chỉnh sửa", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                if self.popupViewController == nil {
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let popoverVC = mainStoryboard.instantiateViewController(withIdentifier: "EditCommentViewController") as! EditCommentViewController
                    popoverVC.isSubComment = isSubcomment
                    popoverVC.subComment = subComment
                    popoverVC.mainComment = mainComment
                    popoverVC.delegate = self
                    popoverVC.preferredContentSize = CGSize.init(width: 320, height: 250)
                    popoverVC.isModalInPopover = false
                    self.popupViewController = WYPopoverController(contentViewController: popoverVC)
                    self.popupViewController.delegate = self
                    self.popupViewController.wantsDefaultContentAppearance = false;
                    self.popupViewController.presentPopover(from: CGRect.init(x: 0, y: 0, width: 0, height: 0), in: self.view, permittedArrowDirections: WYPopoverArrowDirection.none, animated: true, options: WYPopoverAnimationOptions.fade, completion: nil)
                    
                }
            })
            
            let deleteTap = UIAlertAction(title: "Xoá", style: .destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                
                let alert = UIAlertController.init(title: "Thông báo", message: "Bạn có chắc chắn xoá bình luận này?", preferredStyle: UIAlertControllerStyle.alert)
                let noAction = UIAlertAction.init(title: "Huỷ", style: UIAlertActionStyle.cancel, handler: nil)
                let yesAction = UIAlertAction.init(title: "Xoá", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
                    if isSubcomment {
                        self.deleteComment(objID: subComment.comment.id, isSubcomment: isSubcomment, indexPath: indexPath, subComment: subComment)
                    }else{
                        self.deleteComment(objID: mainComment.comment.id, isSubcomment: isSubcomment, indexPath: indexPath, subComment: subComment)
                    }
                })
                
                alert.addAction(noAction)
                alert.addAction(yesAction)
                self.present(alert, animated: true, completion: nil)
            })
            
            let cancelTap = UIAlertAction(title: "Huỷ bỏ", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })
            
            optionMenu.addAction(editTap)
            optionMenu.addAction(deleteTap)
            optionMenu.addAction(cancelTap)
            
            self.present(optionMenu, animated: true, completion: nil)
        }
        

    }
    
    //  MARK: WYPopoverControllerDelegate
    func popoverControllerDidDismissPopover(_ popoverController: WYPopoverController!) {
        if popupViewController != nil {
            popupViewController.delegate = nil
            popupViewController = nil
        }
    }
    
    //MARK: EditCommentViewControllerDelegate
    func cancelEditComment() {
        popupViewController.dismissPopover(animated: true)
        popupViewController.delegate = nil
        popupViewController = nil
        
    }
    
    //MARK: Reload main comment after update and get notification
    func reloadMainCommentAfterUpdated(notification : Notification){
        if notification.object != nil {
            let mainCom = notification.object as! MainCommentEntity
            if mainComment.comment.id == mainCom.comment.id {
                mainComment.comment.content = mainCom.comment.content
            }
            commentTbl.reloadData()
        }
    }
    
    //MARK: Reload sub comment after update and get notification
    func reloadSubCommentAfterUpdated(notification : Notification){
        if notification.object != nil {
            let subComment = notification.object as! SubCommentEntity
            
            for itemSub in mainComment.subComment {
                if itemSub.comment.id == subComment.comment.id {
                    itemSub.comment.content = subComment.comment.content
                }
            }
            commentTbl.reloadData()
        }
    }
  func showImageFromDetailPost(skBrowser: SKPhotoBrowser) {
    self.present(skBrowser, animated: true, completion: nil)
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
