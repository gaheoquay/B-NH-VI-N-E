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
    @IBOutlet weak var markImg: UIImageView!
    
    var feed = FeedsEntity()
    var listComment = [MainCommentEntity]()
    
    let textInputBar = ALTextInputBar()
    let keyboardObserver = ALKeyboardObservingView()
    
    let pickerController = DKImagePickerController()
    var imageAssets = [DKAsset]()

    var imgCommentDic = [String]()
    var thumImgCommentDic = [String]()
    
    var currentUserId = ""
    var pageIndex = 1
    
    var questionID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        configTable()

        if questionID != "" {
            getPostBy(postId: questionID)
        }else{
            setupMarkerForQuestion()
            getListCommentByPostID(postId: feed.postEntity.id)
        }
        
        configInputBar()
        setupImagePicker()
        
        imgCollectionViewHeight.constant = 0
        currentUserId = Until.getCurrentId()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(notification:)), name: NSNotification.Name(rawValue: ALKeyboardFrameDidChangeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(markACommentToSolution(notification:)), name: Notification.Name.init(MARK_COMMENT_TO_RESOLVE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCommentData), name: Notification.Name.init(COMMENT_ON_COMMENT_SUCCESS), object: nil)

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
//                self.detailTbl.pullToRefreshView?.startAnimating()
                self.reloadData()
                
            }
        }
        
        detailTbl.addInfiniteScrollingWithHandler {
            DispatchQueue.main.async {
//                self.detailTbl.infiniteScrollingView?.startAnimating()
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
            getListCommentByPostID(postId: feed.postEntity.id)
        }
        
    }
    
    func loadMore(){
        pageIndex += 1
        if questionID != "" {
            getListCommentByPostID(postId: questionID)
        }else{
            getListCommentByPostID(postId: feed.postEntity.id)
        }
    }
    
    //MARK: Show marker for question 
    func setupMarkerForQuestion() {
        if feed.postEntity.status == 0 {
            markImg.image = UIImage.init(named: "GiaiPhap_Mark_hide.png")
        }else{
            markImg.image = UIImage.init(named: "GiaiPhap_Mark.png")
        }
    }
    
    //MARK: Receive notify when have new comment 
    func reloadCommentData() {
        detailTbl.triggerPullToRefresh()
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
    
    //MARk: Get data init
    func getPostBy(postId : String){
        Until.showLoading()
        
        let getPostParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId" : Until.getCurrentId(),
            "PostId": postId
        ]
        
        print(JSON.init(getPostParam))
        
        Alamofire.request(GET_POST_BY_ID, method: .post, parameters: getPostParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        
                        self.feed = FeedsEntity.init(dictionary: jsonData)
                        self.setupMarkerForQuestion()

                        self.getListCommentByPostID(postId: self.feed.postEntity.id)

                        self.detailTbl.reloadData()
                        
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi không thể lấy được dữ liệu câu hỏi. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            
            Until.hideLoading()
        }
    }
    
    func getListCommentByPostID(postId : String){
        Until.showLoading()

        let postParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "Page": pageIndex,
            "Size": 10,
            "RequestedUserId" : Until.getCurrentId(),
            "PostId": postId
        ]
        print(JSON.init(postParam))
        Alamofire.request(GET_LIST_COMMENT_BY_POSTID, method: .post, parameters: postParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
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
            self.detailTbl.pullToRefreshView?.stopAnimating()
            self.detailTbl.infiniteScrollingView?.stopAnimating()
        }
    }
    
    
    //MARK: Post comment tap action
    func postCommentAction(){
        if Until.getCurrentId() != "" {
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
                    sendCommentToServer()
                }
            }
        }else{
          Until.gotoLogin(_self: self, cannotBack: false)
        }
    }
    
    func sendCommentToServer(){
        self.view.endEditing(true)
        
        let commentEntity = CommentEntity()
        commentEntity.content = textInputBar.text
        commentEntity.imageUrls = imgCommentDic
        commentEntity.thumbnailImageUrls = thumImgCommentDic
        
        let commentParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": currentUserId,
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
                        
                        self.listComment.insert(entity, at: 0)
                        self.detailTbl.reloadData()
                        
                        self.textInputBar.textView.text = ""
                        self.imgCommentDic = []
                        self.thumImgCommentDic = []
                        
                        self.imgCollectionViewHeight.constant = 0
                        self.imageAssets.removeAll()
                        self.imgCollectionView.reloadData()
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
    
    //MARK: receive notifiy when mark an comment is solution
    func markACommentToSolution(notification : Notification){
        if notification.object != nil {
            let commentEntity = notification.object as! CommentEntity
            
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
        if feed.postEntity.id != "" { //trường hợp chưa có thông tin về bài viết (chưa lấy đc dữ liệu từ server)
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
            cell.feed = self.feed
            cell.setData()
            cell.delegate = self
            return cell
        }else{
            let entity = listComment[indexPath.section - 1]
            if entity.isShowMore {
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
                    if currentUserId == feed.authorEntity.id {
                        cell.isMyPost = true
                    }else{
                        cell.isMyPost = false
                    }
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
                    if currentUserId == feed.authorEntity.id {
                        cell.isMyPost = true
                    }else{
                        cell.isMyPost = false
                    }
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
    func gotoLoginFromDetailQuestionVC() {
      Until.gotoLogin(_self: self, cannotBack: false)
    }
    
    func gotoUserProfileFromDetailQuestion(user: AuthorEntity) {
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
    
    //MARK: MoreCommentTableViewCellDelegate
    func showMoreSubcomment() {
        detailTbl.reloadData()
    }
    
    //MARK: CommentTableViewCellDelegate
    func replyCommentAction(mainComment: MainCommentEntity) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        vc.feedEntity = feed
        vc.mainComment = mainComment
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoLoginFromCommentTableCell() {
      Until.gotoLogin(_self: self, cannotBack: false)
    }
    
    func gotoUserProfileFromCommentCell(user: AuthorEntity) {
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
    
    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
