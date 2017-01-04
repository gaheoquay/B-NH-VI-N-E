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
    
    let pickerImageController = DKImagePickerController()
    var imageAssets = [DKAsset]()
    
    var imageDic = [String]()
    var thumImgDic = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configImageCollectionView()
        imgClvheight.constant = 0
        configUI()
        setupImagePicker()
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
    
    func validateDataQuestion() -> String{
        let titleString = titleTxt.text
        let contentString = contentTxt.text
        
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
    
    @IBAction func postTapAction(_ sender: Any) {
        if validateDataQuestion() != "" {
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: validateDataQuestion(), cancelBtnTitle: "Đóng")
        }else{
            if imageAssets.count > 0 {
                uploadImage()
            }else{
                sendQuestionToServer()
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
                            self.sendQuestionToServer()
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
    
    func sendQuestionToServer(){
        let titleString = titleTxt.text
        let contentString = contentTxt.text
        let tagString = tagTxt.text
        
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
            "Tags": tagString!
        ]
        
        print(JSON.init(questionParam))
        
        Until.showLoading()
        Alamofire.request(POST_QUESTION, method: .post, parameters: questionParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    
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
