//
//  AddQuestionViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class AddQuestionViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIPickerViewDelegate,UIPickerViewDataSource, AddImageCollectionViewCellDelegate {

    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var contentTxt: UITextView!
    @IBOutlet weak var tagTxt: UITextView!
    @IBOutlet weak var imgClv: UICollectionView!
    @IBOutlet weak var imgClvheight: NSLayoutConstraint!
    @IBOutlet weak var titleTxtBorderView: UIView!
    @IBOutlet weak var titleNaviBarLbl: UILabel!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var addImgView: UIView!
    @IBOutlet weak var addImgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var keyboardViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var lbCate: UILabel!
    
    
    let pickerImageController = DKImagePickerController()
    var imageAssets = [DKAsset]()
    var id = ""
    var name = ""
    var indexPathCate = 0
    
    var imageDic = [String]()
    var thumImgDic = [String]()
    
    var isEditPost = false
    var feedObj = FeedsEntity()
    var searchText = ""
    var ischeck = false
    
    var pickerFrame = CGRect(x: 0, y: 50, width: 270, height: 150)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        requestCate()
        registerNotification()
        configImageCollectionView()
        keyboardViewHeight.constant = 0
        configUI()

        setupImagePicker()
        
        if searchText != "" {
            titleTxt.text = searchText
        }
        
        viewCategory.layer.borderWidth = 1
        viewCategory.layer.cornerRadius = 4
        viewCategory.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: POST_QUESTION)
    }

    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configImageCollectionView(){
        imgClv.delegate = self
        imgClv.dataSource = self
        imgClv.register(UINib.init(nibName: "AddImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddImageCollectionViewCell")
    }
    
    func setupImagePicker(){
        pickerImageController.assetType = DKImagePickerControllerAssetType.allPhotos
        pickerImageController.didSelectAssets = { [unowned self] ( assets: [DKAsset]) in
            self.imageAssets = assets
            if assets.count == 0 && self.feedObj.postEntity.imageUrls.count == 0 {
                self.imgClvheight.constant = 0
            }else{
                self.imgClvheight.constant = 110
            }
            self.view.layoutIfNeeded()
            self.imgClv.reloadData()
        }
    }
    
    func configUI(){
        titleTxtBorderView.layer.cornerRadius = 2
        titleTxtBorderView.layer.borderWidth = 1
        titleTxtBorderView.layer.borderColor = UIColor().hexStringToUIColor(hex: "D8D8D8").cgColor
        
        contentTxt.layer.cornerRadius = 2
        contentTxt.layer.borderWidth = 1
        contentTxt.layer.borderColor = UIColor().hexStringToUIColor(hex: "D8D8D8").cgColor
        
        tagTxt.layer.cornerRadius = 2
        tagTxt.layer.borderWidth = 1
        tagTxt.layer.borderColor = UIColor().hexStringToUIColor(hex: "D8D8D8").cgColor
        
        if isEditPost {
            postBtn.setTitle("Cập nhật", for: .normal)
            titleNaviBarLbl.text = "Sửa câu hỏi"
            titleTxt.isEnabled = false
        }else{
            postBtn.setTitle("Đăng", for: .normal)
            titleNaviBarLbl.text = "Đặt câu hỏi"
            titleTxt.isEnabled = true
        }
        
        if self.imageAssets.count == 0 && self.feedObj.postEntity.imageUrls.count == 0 {
            self.imgClvheight.constant = 0
        }else{
            self.imgClvheight.constant = 110
        }
    }
    
    //MARK: Setup UI for update question view
    func setupDataForUpdateQuestion(){
        if searchText == "" {
            titleTxt.text = feedObj.postEntity.title
        }
        contentTxt.text = feedObj.postEntity.content
        
            for item in listCate {
                if item.id == feedObj.postEntity.categoryId {
                    lbCate.text = item.name
                  id = item.id
                }
        }
        
        var listTag = [String]()
        for item in feedObj.tags {
            listTag.append(item.id)
        }
        let listTagString = listTag.joined(separator: ",")
        tagTxt.text = listTagString
        
        if feedObj.postEntity.isPrivate == false {
            btnSwitch.setOn(false, animated: true)
        }else {
            btnSwitch.setOn(true, animated: true)
        }
        
        imgClv.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count + feedObj.postEntity.imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageCollectionViewCell", for: indexPath) as! AddImageCollectionViewCell
        if indexPath.row >= feedObj.postEntity.imageUrls.count {
            let asset = imageAssets[indexPath.row - feedObj.postEntity.imageUrls.count]
            asset.fetchOriginalImage(true) { (image, info) in
                cell.imageView.image = image
            }
        }else{
            cell.imageView.sd_setImage(with: URL.init(string: feedObj.postEntity.imageUrls[indexPath.row]), placeholderImage: #imageLiteral(resourceName: "placeholder_wide.png"))
        }
        cell.indexPath = indexPath
        cell.deleteBtn.isHidden = false
        cell.delegate = self
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 110, height: 110)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var images = [SKPhoto]()
        
        for item in self.imageAssets{
            item.fetchOriginalImage(true) { (image, info) in
                let photo = SKPhoto.photoWithImage(image!)
                photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
                images.append(photo)
            }
        }
        
        for itemUrl in self.feedObj.postEntity.imageUrls {
            let photo = SKPhoto.photoWithImageURL(itemUrl, holder: #imageLiteral(resourceName: "placeholder_wide.png"))
            images.append(photo)
        }
        
        let browser = SKPhotoBrowser(photos: images)
        self.present(browser, animated: true, completion: nil)
    }
    
    func validateDataQuestion() -> String{
        let titleString = titleTxt.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let contentString = contentTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if titleString == "" {
            titleTxt.becomeFirstResponder()
            return "Vui lòng nhập tiêu đề câu hỏi"
        }else if contentString == "" {
            contentTxt.becomeFirstResponder()
            return "Vui lòng nhập nội dung câu hỏi."
        }else{
            return ""
        }
    }
    //MARK: AddImageCollectionViewCellDelegate
    func deleteImageAction(indexPath: IndexPath) {
        if indexPath.row >= feedObj.postEntity.imageUrls.count {
            imageAssets.remove(at: indexPath.row - feedObj.postEntity.imageUrls.count)
        }else{
            feedObj.postEntity.imageUrls.remove(at: indexPath.row)
        }
        imgClv.reloadData()
    }
    
    //MARK: show keyboard
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.size.height
            keyboardViewHeight.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        keyboardViewHeight.constant = 0
        self.view.layoutIfNeeded()
    }
    
    @IBAction func postTapAction(_ sender: Any) {
        if validateDataQuestion() != "" {
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: validateDataQuestion(), cancelBtnTitle: "Đóng")
        }else{
            if isEditPost {
                if imageAssets.count > 0 {
                    uploadImage()
                }else{
                    updateQuestionToServer()
                }
            }else{
                if imageAssets.count > 0 {
                    uploadImage()
                    Until.sendEventTracker(category: "Post", action: "CreatePostWithImage", label: feedObj.authorEntity.id)
                }else{
                    sendNewQuestionToServer()
                    Until.sendEventTracker(category: "Post", action: "CreatePostWithoutImage", label: feedObj.authorEntity.id)
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
                                let imageThumb = dic["ThumbnailUrl"] as! String
                                if self.isEditPost {
                                    self.feedObj.postEntity.imageUrls.append(imageUrl)
                                    self.feedObj.postEntity.thumbnailImageUrls.append(imageThumb)
                                }else{
                                    self.imageDic.append(imageUrl)
                                    self.thumImgDic.append(imageThumb)
                                }
                            }
                            
                            if self.isEditPost {
                                self.updateQuestionToServer()
                            }else{
                                self.sendNewQuestionToServer()
                            }
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
    
    
    //MARK: Update current question
    func updateQuestionToServer(){
        self.view.endEditing(true)
        
        let titleString = titleTxt.text
        let contentString = contentTxt.text
        let tagString = tagTxt.text.trimmingCharacters(in: .whitespaces)
        
        let post : [String : Any] = [
            "Id" : feedObj.postEntity.id,
            "Title" : titleString!,
            "Content" : contentString!,
            "ImageUrls" : feedObj.postEntity.imageUrls,
            "ThumbnailImageUrls" : feedObj.postEntity.thumbnailImageUrls,
            "Status" : feedObj.postEntity.status,
            "Rating" : feedObj.postEntity.rating,
            "UpdatedDate" : 0,
            "CategoryId": id,
            "IsPrivate": ischeck,
            "IsClassified": false,
            "CreatedDate" : feedObj.postEntity.createdDate
        ]
        
        let questionParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": Until.getCurrentId(),
            "Post": post,
            "Tags": tagString
        ]
        
        
        Until.showLoading()
        Alamofire.request(UPDATE_POST, method: .post, parameters: questionParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        let isUpdated = jsonData["IsUpdated"] as! Bool
                        self.feedObj.postEntity.content = contentString!
                        self.feedObj.postEntity.categoryId = self.id
                        self.feedObj.postEntity.isPrivate = self.ischeck
                        let tags = tagString.components(separatedBy: ",")
                        var tagArr = [TagEntity]()
                        for item in tags {
                            let tag = TagEntity.init()
                            tag.id = item
                            tagArr.append(tag)
                        }
                        
                        if tagString == "" {
                            tagArr.removeAll()
                        }

                        self.feedObj.tags = tagArr
                        
                        if isUpdated {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RELOAD_QUESTION_DETAIL), object: self.feedObj)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RELOAD_ALL_DATA), object: nil)

                            _ = self.navigationController?.popViewController(animated: true)
                        }else{
                            
                        }
                    }
                    
                  
                    
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }
    }
    
    //MARK: Request create new question
    func sendNewQuestionToServer(){
        self.view.endEditing(true)
        
        let titleString = titleTxt.text
        let contentString = contentTxt.text
        let tagTrimmed = tagTxt.text!.replacingOccurrences(of: "\n", with: "", options: .regularExpression)
        
        let post : [String : Any] = [
                "Id" : "",
                "Title" : titleString!,
                "Content" : contentString!,
                "ImageUrls" : imageDic,
                "ThumbnailImageUrls" : thumImgDic,
                "Status" : 0,
                "Rating" : 0,
                "UpdatedDate" : 0,
                "CategoryId": id,
                "IsPrivate": ischeck,
                "IsClassified": false,
                "CreatedDate" : 0
        ]
        
        let questionParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": Until.getCurrentId(),
            "Post": post,
            "Tags": tagTrimmed
        ]
        
        
        Until.showLoading()
        Alamofire.request(POST_QUESTION, method: .post, parameters: questionParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: RELOAD_ALL_DATA), object: nil)

                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }
    }
    
    @IBAction func addImageTapAction(_ sender: Any) {
        self.present(pickerImageController, animated: true, completion: nil)

    }
    
    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cateTapAction(_ sender: Any) {
        creatAlert()
    }
    
    func creatAlert(){
      if feedObj.postEntity.isClassified {
        return
      }
        let alertView = UIAlertController(title: "Chuyên khoa", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerView = UIPickerView(frame: pickerFrame)
        
        
        
        alertView.view.addSubview(pickerView)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if self.name == "" {
                self.lbCate.text = listCate[self.indexPathCate].name
                self.id = listCate[self.indexPathCate].id
            }else {
                self.lbCate.text = self.name
            }
        })
        
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listCate.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listCate[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        id = listCate[row].id
        name = listCate[row].name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestCate() {
        let cateParam : [String : Any] = [
            "Auth": Until.getAuthKey()
            ]
        Alamofire.request(GET_CATE, method: .post, parameters: cateParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let json = result as! [NSDictionary]
                        listCate.removeAll()
                        for element in json {
                            let entity = CateEntity.init(dictionary: element)
                            listCate.append(entity)
                        }
                    }
                    self.setupDataForUpdateQuestion()
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi không thể lấy danh sách chuyên khoa. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
        }
    }
    
    @IBAction func actionSwitch(_ sender: Any) {
        if btnSwitch.isOn {
            ischeck = true
        }else {
            ischeck = false
        }
    }
    
    
}
