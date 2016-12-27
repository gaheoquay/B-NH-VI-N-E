//
//  RegisterViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nicknameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var repassTxt: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var errLbl: UILabel!

    let pickerImageController = DKImagePickerController()
    var imageAssets = [DKAsset]()

    var imageUrl = ""
    var thumbnailUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDkImagePicker()
        setupUI()
    }

    func setupUI(){
        avatarImg.layer.cornerRadius = 10
        avatarImg.clipsToBounds = true
        
        registerBtn.layer.cornerRadius = 5
        registerBtn.clipsToBounds = true
    }
    
    @IBAction func chooseAvatarAction(_ sender: Any) {
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
                    self.avatarImg.image = image!
                })
                
            }else{
                self.avatarImg.image = UIImage.init(named: "AvaDefaut")
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

                            self.registerUserToServer()
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
    
    @IBAction func registerBtnAction(_ sender: Any) {
        if validateData() == "" {
            errLbl.isHidden = true
            if imageAssets.count > 0 {
                uploadImage()
            }else{
                registerUserToServer()
            }
        }else{
            errLbl.isHidden = false
            errLbl.text = validateData()
        }
    }
    
    func registerUserToServer(){
        
        let uuid = NSUUID().uuidString
        
        let device : [String : Any] = [
            "OS": 0,
            "DeviceId": uuid,
            "Token": UserDefaults.standard.object(forKey: NOTIFICATION_TOKEN) as! String
        ]
        
        let nickString = nicknameTxt.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let emailString = emailTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let passString = passTxt.text

        let user : [String : Any] = [
            "Email": emailString!,
            "Password": DataEncryption.getMD5(from: passString),
            "Nickname": nickString!,
            "FullName": "",
            "Role": 1,
            "Job": "",
            "Address": "",
            "Phone": "",
            "Company": "",
            "SocialType": 0,
            "SocialId": "",
            "Gender": 0,
            "AvatarUrl": "",
            "ReputationRate": 0,
            "ThumbnailAvatarUrl": "",
            "IsVerified": false,
            "CreatedDate": 0,
            "UpdateDate": 0,
            "DOB":0
        ]

        let registerParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "User": user,
            "Device": device
        ]
        
        print(JSON.init(registerParam))
        
        Until.showLoading()
        Alamofire.request(REGISTER_USER, method: .post, parameters: registerParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
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
    
    @IBAction func loginBtnAction(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    
    func validateData() -> String{
        let nickString = nicknameTxt.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let emailString = emailTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let passString = passTxt.text
        let rePassString = repassTxt.text
        
        if nickString == "" {
            nicknameTxt.becomeFirstResponder()
            return "Vui lòng điền Tên đăng nhập,"
        }else if emailString == "" {
            emailTxt.becomeFirstResponder()
            return "Vui lòng điền email."
        }else if !Until.isValidEmail(email: emailString!){
            emailTxt.becomeFirstResponder()
            return "Định dạng email không đúng."
        }else if passString == "" || rePassString == "" {
            return "Vui lòng nhập đầy đủ thông tin mật khẩu."
        }else if passString != rePassString {
            return "Mật khẩu và xác nhận mật khẩu phải trùng nhau."
        }else{
            return ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
