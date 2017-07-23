//
//  QuestionDetailViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit
protocol QuestionDetailViewControllerDelegate {
  func reloadTable()
}

class QuestionDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, MoreCommentTableViewCellDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CommentTableViewCellDelegate, DetailQuestionTableViewCellDelegate, WYPopoverControllerDelegate,EditCommentViewControllerDelegate, CommentViewControllerDelegate {

    @IBOutlet weak var detailTbl: UITableView!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var imgCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var keyboardViewHeight: NSLayoutConstraint!
    @IBOutlet weak var markImg: UIImageView!
    
    var feedObj = FeedsEntity()
    var listComment = [MainCommentEntity]()
    var popupViewController:WYPopoverController!

    let textInputBar = ALTextInputBar()
    let keyboardObserver = ALKeyboardObservingView()
    
    let pickerController = DKImagePickerController()
    var imageAssets = [DKAsset]()

    var imgCommentDic = [String]()
    var thumImgCommentDic = [String]()
    
    var currentUserId = ""
    var pageIndex = 1
    var questionID = ""
    var commentEntity = CommentEntity()
    
  var notification : NotificationNewEntity!
  var delegate:QuestionDetailViewControllerDelegate?
  var notificationId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        configTable()
        
        if questionID != "" {
            getPostBy(postId: questionID)
        }else{
            setupMarkerForQuestion()
            getListCommentByPostID(postId: feedObj.postEntity.id)
        }
        if (notification != nil && !(notification.isRead)) || !notificationId.isEmpty {
            setReadNotification()
        }
        configInputBar()
        setupImagePicker()
        
        imgCollectionViewHeight.constant = 0
        currentUserId = Until.getCurrentId()
        textInputBar.textView.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: DETAILS_POST)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(notification:)), name: NSNotification.Name(rawValue: ALKeyboardFrameDidChangeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(markACommentToSolution(notification:)), name: Notification.Name.init(RELOAD_ALL_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCommentData), name: Notification.Name.init(COMMENT_ON_COMMENT_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadQuestionAfterUpdated(notification:)), name: Notification.Name.init(RELOAD_QUESTION_DETAIL), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMainCommentAfterUpdated(notification:)), name: Notification.Name.init(RELOAD_COMMENT_DETAIL), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSubCommentAfterUpdated(notification:)), name: Notification.Name.init(RELOAD_SUBCOMMENT_DETAIL), object: nil)

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
        
        detailTbl.addPullToRefreshHandler {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
        
        detailTbl.addInfiniteScrollingWithHandler {
            DispatchQueue.main.async {
                self.loadMore()
            }
        }
    }
    
    func reloadData(){
        pageIndex = 1
        listComment.removeAll()
        if questionID != "" {
            getListCommentByPostID(postId: questionID)
        }else{
            getListCommentByPostID(postId: feedObj.postEntity.id)
        }
        
    }
    
    func loadMore(){
        pageIndex += 1
        if questionID != "" {
            getListCommentByPostID(postId: questionID)
        }else{
            getListCommentByPostID(postId: feedObj.postEntity.id)
        }
    }
    
    //MARK: Show marker for question 
    func setupMarkerForQuestion() {
        if feedObj.postEntity.status == 0 {
            markImg.image = UIImage.init(named: "GiaiPhap_Mark_hide.png")
        }else{
            markImg.image = UIImage.init(named: "GiaiPhap_Mark.png")
        }
    }
    
    //MARK: Reload question after update and get notification
    func reloadQuestionAfterUpdated(notification : Notification){
        if notification.object != nil {
            let feed = notification.object as! FeedsEntity
            self.feedObj = feed
            self.detailTbl.reloadData()
        }
    }
    
    //MARK: Reload main comment after update and get notification
    func reloadMainCommentAfterUpdated(notification : Notification){
        if notification.object != nil {
            let mainComment = notification.object as! MainCommentEntity
            for item in listComment {
                if item.comment.id == mainComment.comment.id {
                    item.comment.content = mainComment.comment.content
                }
            }
            
            detailTbl.reloadData()
        }
    }
    
    //MARK: Reload sub comment after update and get notification
    func reloadSubCommentAfterUpdated(notification : Notification){
        if notification.object != nil {
            let subComment = notification.object as! SubCommentEntity
            for itemComment in listComment {
                for itemSub in itemComment.subComment {
                    if itemSub.comment.id == subComment.comment.id {
                        itemSub.comment.content = subComment.comment.content
                    }
                }
            }
            
            detailTbl.reloadData()
        }
    }
    
    //MARK: Receive notify when have new comment 
    func reloadCommentData() {
        reloadData()
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
  //MARk: set read notification
  func setReadNotification(){
    do {
        let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
        let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        let auth = code.replacingOccurrences(of: "\n", with: "")
        let header = [
            "Auth": auth
        ]
        Until.showLoading()
        if notificationId == "" {
            notificationId = notification.id
        }
        let getPostParam : [String : Any] = [
            "RequestedUserId" : Until.getCurrentId(),
            "NotificationId": notificationId
        ]
        Alamofire.request(SET_READ_NOTIFICATION, method: .post, parameters: getPostParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
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
    } catch let error as NSError {
        print(error)
    }

  }

  
    //  MARK: Keyboard showing
    func keyboardWillShow(notification:NSNotification){
        if let userInfo = notification.userInfo {
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            textInputBar.frame.origin.y = frame.origin.y
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.keyboardViewHeight.constant = frame.size.height
                
            }
        }
    }
    
    func keyboardWillHide(notification:NSNotification){
        if let userInfo = notification.userInfo {
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            UIView.animate(withDuration:0.3) {
                if frame.origin.y == UIScreen.main.bounds.height{
                    self.textInputBar.frame.origin.y = frame.origin.y - 44
                }else{
                    self.textInputBar.frame.origin.y = frame.origin.y
                }
            }
            self.keyboardViewHeight.constant = 0

        }
    }
    
    func keyboardFrameChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            UIView.animate(withDuration: 0.3, animations: {
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
    
    //MARk: Get data init
    func getPostBy(postId : String){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            Until.showLoading()
            
            let getPostParam : [String : Any] = [
                "RequestedUserId" : Until.getCurrentId(),
                "PostId": postId
            ]
            
            
            Alamofire.request(GET_POST_BY_ID, method: .post, parameters: getPostParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            
                            self.feedObj = FeedsEntity.init(dictionary: jsonData)
                            self.setupMarkerForQuestion()
                            
                            self.getListCommentByPostID(postId: self.feedObj.postEntity.id)
                            
                            self.detailTbl.reloadData()
                            
                        }
                    }else if status == 201{
                        let alert = UIAlertController.init(title: "Thông báo", message: "Bài viết đã bị xóa", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction.init(title: "Đồng ý", style: UIAlertActionStyle.default, handler: { (action) in
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi không thể lấy được dữ liệu câu hỏi. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
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
    
    func getListCommentByPostID(postId : String){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let postParam : [String : Any] = [
                "Page": pageIndex,
                "Size": 10,
                "RequestedUserId" : Until.getCurrentId(),
                "PostId": postId
            ]
            Alamofire.request(GET_LIST_COMMENT_BY_POSTID, method: .post, parameters: postParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! [NSDictionary]
                            
                            for item in jsonData {
                                let entity = MainCommentEntity.init(dict: item)
                                self.listComment.append(entity)
                            }
                            self.feedObj.commentCount = self.listComment.count
                            self.detailTbl.reloadData()
                            
                        }
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi không thể lấy được dữ liệu Bình luận. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                self.detailTbl.pullToRefreshView?.stopAnimating()
                self.detailTbl.infiniteScrollingView?.stopAnimating()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    //MARK: Post comment tap action
    func postCommentAction(){
        if Until.getCurrentId() != "" {
            if imageAssets.count > 0 {
                uploadImage()
            }else{
                let stringComent = textInputBar.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if stringComent == "" {
                    let alert = UIAlertController(title: "Thông Báo", message: "Bình luận không được để khoảng trắng.", preferredStyle: .alert)
                    let OkeAction: UIAlertAction = UIAlertAction(title: "Đóng", style: .cancel) { action -> Void in
                        self.textInputBar.becomeFirstResponder()
                    }
                    alert.addAction(OkeAction)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    sendCommentToServer()
                }
            }
        }else{
          Until.gotoLogin(_self: self, cannotBack: false)
        }
    }
    
    func sendCommentToServer(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            self.view.endEditing(true)
            
            let commentEntity = CommentEntity()
            commentEntity.content = textInputBar.text
            commentEntity.imageUrls = imgCommentDic
            commentEntity.thumbnailImageUrls = thumImgCommentDic
            
            let commentParam : [String : Any] = [
                "RequestedUserId": currentUserId,
                "Comment": CommentEntity().toDictionary(entity: commentEntity),
                "PostId": feedObj.postEntity.id
            ]
            
            Until.showLoading()
            
            Alamofire.request(POST_COMMENT, method: .post, parameters: commentParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let entity = MainCommentEntity.init(dict: jsonData)
                            
                            if self.feedObj.postEntity.status == 1 {
                                self.listComment.insert(entity, at: 1)
                            }else{
                                self.listComment.insert(entity, at: 0)
                            }
                            
                            self.feedObj.commentCount += 1
                            self.detailTbl.reloadData()
                            
                            self.textInputBar.textView.text = ""
                            self.textInputBar.text = ""
                            self.imgCommentDic = []
                            self.thumImgCommentDic = []
                            
                            self.imgCollectionViewHeight.constant = 0
                            self.imageAssets.removeAll()
                            self.imgCollectionView.reloadData()
                            self.view.layoutIfNeeded()
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RELOAD_ALL_DATA), object: nil)
                            
                        }
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi không thể lấy được dữ liệu Bình luận. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
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
    
    //MARK: Select image and upload
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
    
    func pickImage(){
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func uploadImage(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            Until.showLoading()
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (index, element) in self.imageAssets.enumerated(){
                    element.fetchOriginalImage(true, completeBlock: {(image, info) -> Void in
                        if let imageData = UIImageJPEGRepresentation(image!, 0.5) {
                            multipartFormData.append(imageData, withName: "Image", fileName: "file\(index).png", mimeType: "image/png")
                        }
                    })
                }
            }, to: UPLOAD_IMAGE, headers:header, encodingCompletion: { encodingResult in
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
                                Until.hideLoading()
                                
                                self.sendCommentToServer()
                            }
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                    Until.hideLoading()
                }
            })
        } catch let error as NSError {
            print(error)
        }
    }
    
    //MARK: receive notifiy when mark an comment is solution
    func markACommentToSolution(notification : Notification){
        if notification.object != nil {
            let commentEntitys = notification.object as! CommentEntity
            self.commentEntity = commentEntitys
            
            if commentEntity.isSolution == true {
                markImg.image = UIImage.init(named: "GiaiPhap_Mark.png")
            }else{
                markImg.image = UIImage.init(named: "GiaiPhap_Mark_hide.png")
            }
            
            for item in listComment {
                if item.comment.id == commentEntity.id {
                    item.comment.isSolution = commentEntity.isSolution
                }
            }
        }
        
        detailTbl.reloadData()
    }
    
    //MARK: Table view delegate and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        if feedObj.postEntity.id != "" { //trường hợp chưa có thông tin về bài viết (chưa lấy đc dữ liệu từ server)
            return 1 + listComment.count
        }else{
            return 0
        }
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
            cell.feed = self.feedObj
            cell.setData()
            cell.delegate = self
            return cell
        }else{
            if listComment.count == 0 {
                return UITableViewCell()
            }
            let entity = listComment[indexPath.section - 1]
            if entity.isShowMore {
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
                    cell.isMyPost = currentUserId == feedObj.authorEntity.id
                    cell.feed = self.feedObj
                    cell.mainComment = listComment[indexPath.section - 1]
                    cell.setDataForMainComment()
                    cell.indexPath = indexPath
                    cell.delegate = self
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
                    cell.feed = self.feedObj
                    cell.mainComment = listComment[indexPath.section - 1]
                    cell.subComment = listComment[indexPath.section - 1].subComment[indexPath.row - 1]
                    cell.setDataForSubComment()
                    cell.indexPath = indexPath
                    cell.delegate = self
                    return cell
                }
            }else{
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
                    cell.feed = self.feedObj
                    cell.isMyPost = currentUserId == feedObj.authorEntity.id
                    cell.mainComment = listComment[indexPath.section - 1]
                    cell.setDataForMainComment()
                    cell.indexPath = indexPath
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
                        cell.feed = self.feedObj
                        cell.mainComment = listComment[indexPath.section - 1]
                        cell.subComment = listComment[indexPath.section - 1].subComment[indexPath.row - 1]
                        cell.setDataForSubComment()
                        cell.indexPath = indexPath
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
        cell.deleteBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 60, height: 60)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    //MARK: Delete comment
    func deleteComment(objID : String, isSubcomment : Bool, indexPath: IndexPath){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            Until.showLoading()
            let param : [String : Any] = [
                "RequestedUserId": currentUserId,
                "DeletedObjectId": objID
            ]
            Alamofire.request(DELETE_ALL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let isDelete = jsonData["IsDeleted"] as! Bool
                            if isDelete {
                                if isSubcomment {
                                    for (index, item) in self.listComment[indexPath.section - 1].subComment.enumerated() {
                                        if item.comment.id == objID {
                                            self.listComment[indexPath.section - 1].subComment.remove(at: index)
                                        }
                                    }
                                }else{
                                    for (index, item) in self.listComment.enumerated() {
                                        if item.comment.id == objID {
                                            self.listComment.remove(at: index)
                                        }
                                    }
                                    self.feedObj.commentCount -= 1
                                }
                                
                                self.detailTbl.reloadData()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RELOAD_ALL_DATA), object: nil)
                                
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
        } catch let error as NSError {
            print(error)
        }
    }
    
    //MARK: Delete post
    func deleteQuestion(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            Until.showLoading()
            let param : [String : Any] = [
                "RequestedUserId": currentUserId,
                "DeletedObjectId": feedObj.postEntity.id
            ]
            Alamofire.request(DELETE_ALL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let isDelete = jsonData["IsDeleted"] as! Bool
                            if isDelete {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RELOAD_ALL_DATA), object: nil)
                                
                                let alert = UIAlertController.init(title: "Thông báo", message: "Xoá bài viết thành công.", preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction.init(title: "Đóng", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                                    _ = self.navigationController?.popViewController(animated: true)
                                })
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: nil)
                                
                            }else{
                                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Xoá bài viết bị lỗi, vui lòng thử lại sau.", cancelBtnTitle: "Đóng")
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
        } catch let error as NSError {
            print(error)
        }
    }
    
    //MARK: DetailQuestionTableViewCellDelegate
    func gotoLoginFromDetailQuestionVC() {
      Until.gotoLogin(_self: self, cannotBack: false)
    }
    
    func gotoUserProfileFromDetailQuestion(user: AuthorEntity) {
        if user.id == Until.getCurrentId() {
        }else{
            let storyboard = UIStoryboard.init(name: "User", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "OtherUserViewController") as! OtherUserViewController
            viewController.user = user
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func showMoreActionFromDetailQuestion() {
        
        self.view.endEditing(true)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editTap = UIAlertAction(title: "Chỉnh sửa", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddQuestionViewController") as! AddQuestionViewController
            vc.feedObj = self.feedObj
            vc.isEditPost = true
            self.navigationController?.pushViewController(vc, animated: true)

        })
        
        let deleteTap = UIAlertAction(title: "Xoá", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let alert = UIAlertController.init(title: "Thông báo", message: "Bạn có chắc chắn xoá bài viết này?", preferredStyle: UIAlertControllerStyle.alert)
            let noAction = UIAlertAction.init(title: "Huỷ", style: UIAlertActionStyle.cancel, handler: nil)
            let yesAction = UIAlertAction.init(title: "Xoá", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
                self.deleteQuestion()
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
    
    func showImageFromDetailPost(skBrowser: SKPhotoBrowser) {
        self.present(skBrowser, animated: true, completion: nil)
    }
    
    func gotoQuestionTagListFromDetailPost(hotTag: TagEntity) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "QuestionByTagViewController") as! QuestionByTagViewController
        viewController.hotTag = hotTag
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: MoreCommentTableViewCellDelegate
    func showMoreSubcomment() {
        detailTbl.reloadData()
    }
    
    //MARK: CommentTableViewCellDelegate
  func markOrUnmarkSolution(mainComment: MainCommentEntity) {
    let solution = listComment.first { (entity) -> Bool in
      entity.comment.isSolution == true
    }
    if solution != nil && solution?.comment.id != mainComment.comment.id {
      let alert = UIAlertController.init(title: "Thông báo", message: "Bạn chỉ được chọn duy nhất một giải pháp. Bạn có muốn chọn lại không?", preferredStyle: UIAlertControllerStyle.alert)
      let actionOK = UIAlertAction.init(title: "Đồng ý", style: UIAlertActionStyle.default, handler: { (alert) in
        solution?.comment.isSolution = false
        self.requestMarkOrUnMarkSolution(mainComment: mainComment)
      })
      let actionCancel = UIAlertAction.init(title: "Hủy", style: UIAlertActionStyle.cancel, handler: nil)
      alert.addAction(actionOK)
      alert.addAction(actionCancel)
      self.present(alert, animated: true, completion: nil)
    }else{
        if mainComment.comment.isSolution == true {
            let alert = UIAlertController.init(title: "Thông báo", message: "Bạn có muốn bỏ chọn câu trả lời này làm giải pháp?", preferredStyle: UIAlertControllerStyle.alert)
            let actionOK = UIAlertAction.init(title: "Đồng ý", style: UIAlertActionStyle.default, handler: { (alert) in
                solution?.comment.isSolution = false
                self.requestMarkOrUnMarkSolution(mainComment: mainComment)
            })
            let actionCancel = UIAlertAction.init(title: "Hủy", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(actionOK)
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
        }else {
            requestMarkOrUnMarkSolution(mainComment: mainComment)
        }
    }
  }
  func requestMarkOrUnMarkSolution(mainComment: MainCommentEntity){
    do {
        let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
        let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        let auth = code.replacingOccurrences(of: "\n", with: "")
        let header = [
            "Auth": auth
        ]
        let markParam : [String : Any] = [
            "RequestedUserId": Until.getCurrentId(),
            "CommentId": mainComment.comment.id
        ]
        Until.showLoading()
        Alamofire.request(MARK_AS_SOLUTION, method: .post, parameters: markParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        let comment = CommentEntity.init(dictionary: jsonData)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: RELOAD_ALL_DATA), object: comment)
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra, vui lòng thử lai sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lai sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }
    } catch let error as NSError {
        print(error)
    }
  }
    func replyCommentAction(mainComment: MainCommentEntity) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        vc.feedEntity = feedObj
        vc.mainComment = mainComment
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoLoginFromCommentTableCell() {
      Until.gotoLogin(_self: self, cannotBack: false)
    }
    
    func gotoUserProfileFromCommentCell(user: AuthorEntity) {
        if user.id == Until.getCurrentId() {
        }else{
            let storyboard = UIStoryboard.init(name: "User", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "OtherUserViewController") as! OtherUserViewController
            viewController.user = user
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func showMoreActionCommentFromCommentCell(isSubcomment: Bool, subComment: SubCommentEntity, mainComment: MainCommentEntity, indexPath: IndexPath) {
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
                            self.deleteComment(objID: subComment.comment.id, isSubcomment: isSubcomment, indexPath: indexPath)
                        }else{
                            self.deleteComment(objID: mainComment.comment.id, isSubcomment: isSubcomment, indexPath: indexPath)
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
                    self.deleteComment(objID: subComment.comment.id, isSubcomment: isSubcomment, indexPath: indexPath)
                }else{
                    self.deleteComment(objID: mainComment.comment.id, isSubcomment: isSubcomment, indexPath: indexPath)
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
    
    //MARK: CommentViewControllerDelegate
  func reloadTable() {}
    func removeMainCommentFromCommentView(mainComment: MainCommentEntity) {
        if listComment.count > 0 {
            for (index,item) in listComment.enumerated() {
                if item.comment.id == mainComment.comment.id {
                    listComment.remove(at: index)
                }
            }
            detailTbl.reloadData()
        }
    }
    
    func removeSubCommentFromCommentView(subComment: SubCommentEntity) {
        if listComment.count > 0 {
            for mainComment in listComment {
                for (index,subCom) in mainComment.subComment.enumerated() {
                    if subCom.comment.id == subComment.comment.id {
                        mainComment.subComment.remove(at: index)
                    }
                }
            }
            detailTbl.reloadData()
        }
    }
    
    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func requestListDoctor(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            Alamofire.request(GET_LIST_DOCTOR, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        listAllDoctor.removeAll()
                        if let result = response.result.value {
                            let jsonData = result as! [NSDictionary]
                            
                            for item in jsonData {
                                let entity = ListDoctorEntity.init(dictionary: item)
                                listAllDoctor.append(entity)
                            }
                            
                        }
                    }
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }
}
