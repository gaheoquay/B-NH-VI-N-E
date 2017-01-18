//
//  AddQuestionViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class AddQuestionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
    
    let pickerImageController = DKImagePickerController()
    var imageAssets = [DKAsset]()
    
    var imageDic = [String]()
    var thumImgDic = [String]()
    
    var isEditPost = false
    var feedObj = FeedsEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        configImageCollectionView()
        imgClvheight.constant = 0
        keyboardViewHeight.constant = 0
        configUI()
        setupImagePicker()
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
            if assets.count == 0 {
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
            imgClvheight.constant = 0
            addImgView.isHidden = true
            addImgViewHeight.constant = 0
            
            setupDataForUpdateQuestion()
        }else{
            postBtn.setTitle("Đăng", for: .normal)
            titleNaviBarLbl.text = "Đặt câu hỏi"
            titleTxt.isEnabled = true
        }
    }
    
    //MARK: Setup UI for update question view
    func setupDataForUpdateQuestion(){
        titleTxt.text = feedObj.postEntity.title
        contentTxt.text = feedObj.postEntity.content
        
        var listTag = [String]()
        for item in feedObj.tags {
            listTag.append(item.id)
        }
        let listTagString = listTag.joined(separator: ",")
        tagTxt.text = listTagString
    }
    
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
                updateQuestionToServer()
            }else{
                if imageAssets.count > 0 {
                    uploadImage()
                }else{
                    sendNewQuestionToServer()
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
                                self.imageDic.append(imageUrl)
                                
                                let imageThumb = dic["ThumbnailUrl"] as! String
                                self.thumImgDic.append(imageThumb)
                            }
                            self.sendNewQuestionToServer()
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
        let tagString = tagTxt.text
        
        let post : [String : Any] = [
            "Id" : feedObj.postEntity.id,
            "Title" : titleString!,
            "Content" : contentString!,
            "ImageUrls" : feedObj.postEntity.imageUrls,
            "ThumbnailImageUrls" : feedObj.postEntity.thumbnailImageUrls,
            "Status" : feedObj.postEntity.status,
            "Rating" : feedObj.postEntity.rating,
            "UpdatedDate" : 0,
            "CreatedDate" : feedObj.postEntity.createdDate
        ]
        
        let questionParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": Until.getCurrentId(),
            "Post": post,
            "Tags": tagString!
        ]
        
        print(JSON.init(questionParam))
        
        Until.showLoading()
        Alamofire.request(UPDATE_POST, method: .post, parameters: questionParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        let isUpdated = jsonData["IsUpdated"] as! Bool
                        self.feedObj.postEntity.content = contentString!

                        let tags = tagString?.components(separatedBy: ",")
                        var tagArr = [TagEntity]()
                        for item in tags! {
                            let tag = TagEntity.init()
                            tag.id = item
                            tagArr.append(tag)
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
                "CreatedDate" : 0
        ]
        
        let questionParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": Until.getCurrentId(),
            "Post": post,
            "Tags": tagTrimmed
        ]
        
        print(JSON.init(questionParam))
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
