//
//  UpdateInfoViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class UpdateInfoViewController: UIViewController {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var currentPassTxt: UITextField!
    @IBOutlet weak var newPassTxt: UITextField!
    @IBOutlet weak var confirmNewPassTxt: UITextField!
    @IBOutlet weak var errLb: UILabel!
    
    let pickerImageController = DKImagePickerController()
    var imageAssets = [DKAsset]()
    
    var imageUrl = ""
    var thumbnailUrl = ""
    
    var userEntity = UserEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        initDkImagePicker()
        
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        if users.count > 0 {
            userEntity = users.first!
        }
    }
    
    func setupUI(){
        avaImg.layer.cornerRadius = 10
        avaImg.clipsToBounds = true
        
        fullnameTxt.text = userEntity.fullname
        avaImg.sd_setImage(with: URL.init(string: userEntity.thumbnailAvatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut"))
    }
    
    @IBAction func selectAvaImgAction(_ sender: Any) {
        self.present(pickerImageController, animated: true, completion: nil)

    }
    
    func initDkImagePicker(){
        pickerImageController.assetType = DKImagePickerControllerAssetType.allPhotos
        pickerImageController.maxSelectableCount = 1
        pickerImageController.didSelectAssets = { [unowned self] ( assets: [DKAsset]) in
            self.imageAssets = assets
            if assets.count > 0 {
                let asset = assets[0]
                asset.fetchOriginalImage(true, completeBlock: {(image, info) -> Void in
                    self.avaImg.image = image!
                })
                
            }else{
                self.avaImg.image = UIImage.init(named: "AvaDefaut")
            }
        }
        
    }
    
    func uploadImage(){
        
        Until.showLoading()
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let asset = self.imageAssets[0]
            asset.fetchOriginalImage(true, completeBlock: {(image, info) -> Void in
                if let imageData = UIImageJPEGRepresentation(image!, 0.5) {
                    multipartFormData.append(imageData, withName: "Image", fileName: "file.png", mimeType: "image/png")
                }
            })
        }, to: UPLOAD_IMAGE, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let status = response.response?.statusCode
                    if status == 200{
                        if let result = response.result.value {
                            let json = result as! [NSDictionary]
                            print(json)
                            self.imageUrl = json[0]["ImageUrl"] as! String
                            self.thumbnailUrl = json[0]["ThumbnailUrl"] as! String
                            
                            self.updateUserInfoToServer()
                        }
                    }
                    
                }
                Until.hideLoading()
                
            case .failure(let encodingError):
                print(encodingError)
                Until.hideLoading()
            }
        })
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        if validateDataUpdate() == "" {
            errLb.isHidden = true
            if imageAssets.count > 0 {
                uploadImage()
            }else{
                updateUserInfoToServer()
            }
        }else{
            errLb.isHidden = false
            errLb.text = validateDataUpdate()
        }
    }
    
    func validateDataUpdate() -> String {
        let currPass = currentPassTxt.text
        let newPass = newPassTxt.text
        let conNewPass = confirmNewPassTxt.text
        
        
        if currPass == "" && newPass == "" && conNewPass == ""{
            return ""
        }else if currPass == "" || newPass == "" || conNewPass == "" {
            return "Vui lòng điền đầy đủ thông tin để đổi mật khẩu"
            
        }else{
            if newPass != conNewPass {
                return "Mật khẩu và xác nhận mật khẩu phải trùng nhau"
            }else{
                return ""
            }
        }
    }
    
    func updateUserInfoToServer(){
        
        let fullname = fullnameTxt.text
        let newPass = newPassTxt.text
        let oldPass = currentPassTxt.text
        
        
        let updateParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "IdUser": userEntity.id,
            "OldPassword": oldPass == "" ? "" : DataEncryption.getMD5(from: oldPass)!,
            "NewPassword": newPass == "" ? "" : DataEncryption.getMD5(from: newPass)!,
            "AvatarUrl": imageUrl,
            "Thumbnail": thumbnailUrl,
            "FullName": fullname!
        ]
        
        print(JSON.init(updateParam))
        
        Until.showLoading()
        Alamofire.request(UPDATE_PROFILE, method: .post, parameters: updateParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        let reaml = try! Realm()
                        let entity = UserEntity.initWithDictionary(dictionary: jsonData)
                        
                        try! reaml.write {
                            reaml.add(entity, update: true)
                        }
                    }
                }else if status == 400 {
                    UIAlertController().showAlertWith(title: "Thông báo", message: "Email hoặc tên đăng nhập đã tồn tại, vui lòng thử lại.", cancelBtnTitle: "Đóng")
                }else{
                    UIAlertController().showAlertWith(title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
