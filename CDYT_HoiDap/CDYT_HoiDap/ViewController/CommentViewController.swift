//
//  CommentViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 1/10/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var commentTbl: UITableView!
    @IBOutlet weak var keyboardViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgClv: UICollectionView!
    @IBOutlet weak var imgClvHeight: NSLayoutConstraint!
    
    let textInputBar = ALTextInputBar()
    let keyboardObserver = ALKeyboardObservingView()

    let pickerController = DKImagePickerController()
    var imageAssets = [DKAsset]()
    
    var imgCommentDic = [String]()
    var thumImgCommentDic = [String]()
    var pageIndex = 0
    var mainComment = MainCommentEntity()
    var currentUserId = ""
    var feedEntity = FeedsEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        configTable()
        configInputBar()
        setupImagePicker()
        
        imgClvHeight.constant = 0
        currentUserId = Until.getCurrentId()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(notification:)), name: NSNotification.Name(rawValue: ALKeyboardFrameDidChangeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
        
//        commentTbl.addPullToRefreshHandler {
//            DispatchQueue.main.async {
//                self.commentTbl.pullToRefreshView?.startAnimating()
//                self.reloadData()
//                
//            }
//        }
        
//        commentTbl.addInfiniteScrollingWithHandler {
//            DispatchQueue.main.async {
//                self.commentTbl.infiniteScrollingView?.startAnimating()
//                self.loadMore()
//            }
//        }
    }
    
//    func reloadData(){
//        pageIndex = 1
//        listComment.removeAll()
//        if questionID != "" {
//            getListCommentByPostID(postId: questionID)
//        }else{
//            getListCommentByPostID(postId: feed.postEntity.id)
//        }
        
//    }
    
//    func loadMore(){
//        pageIndex += 1
//        if questionID != "" {
//            getListCommentByPostID(postId: questionID)
//        }else{
//            getListCommentByPostID(postId: feed.postEntity.id)
//        }
//    }
    
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
    
    //MARK: Table view delegate and datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + mainComment.subComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
            if currentUserId == feedEntity.authorEntity.id {
                cell.isMyPost = true
            }else{
                cell.isMyPost = false
            }
            cell.mainComment = mainComment
            cell.setDataForMainComment()
//            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
            cell.mainComment = mainComment
            cell.subComment = mainComment.subComment[indexPath.row - 1]
            cell.setDataForSubComment()
//            cell.delegate = self
            return cell
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
        
        print(JSON.init(commentParam))
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
