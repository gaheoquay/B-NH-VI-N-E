//
//  UpdateInfoViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class UpdateInfoViewController: UIViewController, SSRadioButtonControllerDelegate {
    
    @IBOutlet weak var avaImg1: UIImageView!
    @IBOutlet weak var avaImg2: UIImageView!
    @IBOutlet weak var nameLbl1: UILabel!
    @IBOutlet weak var nameLbl2: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var verifyLbl: UILabel!
    @IBOutlet weak var meidcalRadio: SSRadioButton!
    @IBOutlet weak var jobPositionTxt: UITextField!
    @IBOutlet weak var otherRadio: SSRadioButton!
    @IBOutlet weak var jobTitleLbl: UILabel!
    @IBOutlet weak var verifyLbl2: UILabel!
    @IBOutlet weak var jobView1: UIView!
    @IBOutlet weak var jobViewHeight1: NSLayoutConstraint!
    @IBOutlet weak var jobView2: UIView!
    @IBOutlet weak var jobViewHeight2: NSLayoutConstraint!
    @IBOutlet weak var workPlaceTxt: UITextField!
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var dobBtn: UIButton!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var errLbl: UILabel!
    @IBOutlet weak var avaImg1Height: NSLayoutConstraint!
    @IBOutlet weak var avaImg2Height: NSLayoutConstraint!
    @IBOutlet weak var logoutBtnHeight: NSLayoutConstraint!
    
    let pickerImageController = DKImagePickerController()
    var imageAssets = [DKAsset]()
    
    var imageUrl = ""
    var thumbnailUrl = ""
    var radioButtonController: SSRadioButtonsController?

    var userEntity = UserEntity()
    var otherUserId = "123123"
    var genderType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        initDkImagePicker()
        
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        if users.count > 0 {
            userEntity = users.first!
        }
        
        setDataForView()
    }
    
    func setupUI(){
        avaImg1.layer.cornerRadius = 10
        avaImg1.clipsToBounds = true
        
        avaImg2.layer.cornerRadius = 10
        avaImg2.clipsToBounds = true
        
        logoutBtn.layer.cornerRadius = 8
        logoutBtn.clipsToBounds = true
        
        radioButtonController = SSRadioButtonsController(buttons: meidcalRadio, otherRadio)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = false
    }
    
    func setDataForView(){
        if otherUserId != "" {
            avaImg1.isHidden = true
            avaImg1Height.constant = 0
            
            nameLbl1.text = ""
            
            logoutBtn.isHidden = true
            logoutBtnHeight.constant = 0
            
            avaImg2.isHidden = false
            avaImg2Height.constant = 90
            avaImg2.sd_setImage(with: URL.init(string: userEntity.avatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut.png"))
            
            nameLbl2.isHidden = false
            nameLbl2.text = userEntity.nickname
            
            jobView1.isHidden = true
            jobViewHeight1.constant = 0
            
            jobView2.isHidden = false
            jobViewHeight2.constant = 60
            
            jobTitleLbl.text = userEntity.job
            if userEntity.isVerified {
                verifyLbl2.text = "(đã được xác minh)"
            }else{
                verifyLbl2.text = "(chưa xác minh)"
            }
            
        }else{
            avaImg1.isHidden = false
            avaImg1Height.constant = 55
            avaImg1.sd_setImage(with: URL.init(string: userEntity.thumbnailAvatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut.png"))
            
            nameLbl1.text = userEntity.nickname
            
            logoutBtn.isHidden = false
            logoutBtnHeight.constant = 25
            
            avaImg2.isHidden = true
            avaImg2Height.constant = 0
            
            nameLbl2.isHidden = true
            nameLbl2.text = ""
            
            jobView1.isHidden = false
            jobViewHeight1.constant = 140
            
            jobView2.isHidden = true
            jobViewHeight2.constant = 0
            
            jobPositionTxt.text = userEntity.job
            
        }
        
        
    }
    
    @IBAction func genderBtnTapAction(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let manTap = UIAlertAction(title: "Nam", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.genderType = "1"
        })
        
        let femaleTap = UIAlertAction(title: "Nữ", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.genderType = "2"
        })
        
        let cancelTap = UIAlertAction(title: "Huỷ", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(manTap)
        optionMenu.addAction(femaleTap)
        optionMenu.addAction(cancelTap)

        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func dobBtnTapAction(_ sender: Any) {
    
    }
    
    func didSelectButton(aButton: UIButton?) {
        
    }
    
    @IBAction func selectAvaImgAction(_ sender: Any) {
        self.present(pickerImageController, animated: true, completion: nil)

    }
    
    @IBAction func logoutBtnTapAction(_ sender: Any) {
    }
    
    func initDkImagePicker(){
        pickerImageController.assetType = DKImagePickerControllerAssetType.allPhotos
        pickerImageController.maxSelectableCount = 1
        pickerImageController.didSelectAssets = { [unowned self] ( assets: [DKAsset]) in
            self.imageAssets = assets
            if assets.count > 0 {
                let asset = assets[0]
                asset.fetchOriginalImage(true, completeBlock: {(image, info) -> Void in
                    self.avaImg1.image = image!
                })
                
            }else{
                self.avaImg1.image = UIImage.init(named: "AvaDefaut.png")
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
            errLbl.isHidden = true
            if imageAssets.count > 0 {
                uploadImage()
            }else{
                updateUserInfoToServer()
            }
        }else{
            errLbl.isHidden = false
            errLbl.text = validateDataUpdate()
        }
    }
    
    func validateDataUpdate() -> String {
//        let currPass = currentPassTxt.text
//        let newPass = newPassTxt.text
//        let conNewPass = confirmNewPassTxt.text
        
        
//        if currPass == "" && newPass == "" && conNewPass == ""{
//            return ""
//        }else if currPass == "" || newPass == "" || conNewPass == "" {
//            return "Vui lòng điền đầy đủ thông tin để đổi mật khẩu"
//            
//        }else{
//            if newPass != conNewPass {
//                return "Mật khẩu và xác nhận mật khẩu phải trùng nhau"
//            }else{
//                return ""
//            }
//        }
        return ""
    }
    
    func updateUserInfoToServer(){
        
        let fullname = fullnameTxt.text
        
        
        let updateParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": userEntity.id,
            "OldPassword": "",
            "NewPassword": "",
            "AvatarUrl": imageUrl,
            "ThumbnailAvatarUrl": thumbnailUrl,
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
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Email hoặc tên đăng nhập đã tồn tại, vui lòng thử lại.", cancelBtnTitle: "Đóng")
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
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
}
