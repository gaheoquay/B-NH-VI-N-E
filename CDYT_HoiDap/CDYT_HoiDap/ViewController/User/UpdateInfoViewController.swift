//
//  UpdateInfoViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class UpdateInfoViewController: BaseViewController {
    
    @IBOutlet weak var avaImg1: UIImageView!
    @IBOutlet weak var avaImg2: UIImageView!
    @IBOutlet weak var nameLbl1: UILabel!
    @IBOutlet weak var nameLbl2: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var dobBtn: UIButton!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var errLbl: UILabel!
    @IBOutlet weak var avaImg1Height: NSLayoutConstraint!
    @IBOutlet weak var avaImg2Height: NSLayoutConstraint!
    @IBOutlet weak var logoutBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var changePassViewHeight: NSLayoutConstraint!
    @IBOutlet weak var changePassView: UIView!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var emailTxt: UITextField!

    @IBOutlet weak var verifyLb: UILabel!
    @IBOutlet weak var verifyIcon: UIImageView!
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var departmentTittle: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobLb: UILabel!
    
    @IBOutlet weak var departmentTopConstant: NSLayoutConstraint!
    @IBOutlet weak var departmentBottomConstant: NSLayoutConstraint!
    @IBOutlet weak var jobTitleConstant: NSLayoutConstraint!
    @IBOutlet weak var jobTitleBottomConstant: NSLayoutConstraint!
    @IBOutlet weak var departmentSeperator: UILabel!
    @IBOutlet weak var jobTitleSeperator: UILabel!
    
    let pickerImageController = DKImagePickerController()
    var imageAssets = [DKAsset]()
    
    var imageUrl = ""
    var thumbnailUrl = ""

    var userToShow = UserEntity()
    var genderType = ""
    var dobDate = Double()

    var otherUserId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        initDkImagePicker()
        
        if otherUserId == "" {
            let realm = try! Realm()
            let users = realm.objects(UserEntity.self)
            if users.count > 0 {
                userToShow = users.first!
            }
            setDataForView()
        }else{
            getUserById()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: MY_ACCOUNT)

    }
    
    func setupUI(){
        avaImg1.layer.cornerRadius = 10
        avaImg1.clipsToBounds = true
        
        avaImg2.layer.cornerRadius = 10
        avaImg2.clipsToBounds = true
        
        logoutBtn.layer.cornerRadius = 8
        logoutBtn.clipsToBounds = true
    }
    
    func getUserById(){
        let param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": otherUserId
        ]
        
      
        Until.showLoading()
        Alamofire.request(GET_USER_BY_ID, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        
                        let entity = UserEntity.initWithDictionary(dictionary: jsonData)

                        self.userToShow = entity
                        
                        self.setDataForView()
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
    
    func setDataForView(){
        if otherUserId != "" {
            avaImg1.isHidden = true
            avaImg1Height.constant = 0
            
            nameLbl1.text = ""
            
            logoutBtn.isHidden = true
            logoutBtnHeight.constant = 0
            
            avaImg2.isHidden = false
            avaImg2Height.constant = 90
            avaImg2.sd_setImage(with: URL.init(string: userToShow.avatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut.png"))
            
            nameLbl2.isHidden = false
            nameLbl2.text = userToShow.nickname
            
            changePassViewHeight.constant = 0
            changePassView.isHidden = true
            
            genderBtn.isUserInteractionEnabled = false
            dobBtn.isUserInteractionEnabled = false
            addressTxt.isUserInteractionEnabled = false
            phoneTxt.isUserInteractionEnabled = false
            fullnameTxt.isUserInteractionEnabled = false
            
            updateBtn.isHidden = true
            if userToShow.role == 1 && userToShow.isVerified == true {
                verifyLb.text = "đã được xác minh"
                verifyIcon.isHidden = false
            }else{
                verifyLb.text = ""
                verifyIcon.isHidden = true
            }
            
        }else{
            avaImg1.isHidden = false
            avaImg1Height.constant = 55
            avaImg1.sd_setImage(with: URL.init(string: userToShow.thumbnailAvatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut.png"))
            
            nameLbl1.text = userToShow.nickname
            
            logoutBtn.isHidden = false
            logoutBtnHeight.constant = 25
            
            avaImg2.isHidden = true
            avaImg2Height.constant = 0
            
            nameLbl2.isHidden = true
            nameLbl2.text = ""
            
            changePassViewHeight.constant = 35
            changePassView.isHidden = false
            updateBtn.isHidden = false
            
            verifyLb.text = ""
            verifyIcon.isHidden = true
        }
        
        if userToShow.role == 1 {
            jobLb.text = userToShow.jobTitle == "" ? "chưa cập nhật" : userToShow.jobTitle
            
            if userToShow.departmentId != "" {
                for item in listCate {
                    if item.id == userToShow.departmentId {
                        departmentLbl.text = item.name
                    }
                }
            }else{
                departmentLbl.text = "chưa cập nhật"
            }
            
        }else{
            departmentLbl.text = ""
            departmentTittle.text = ""
            jobTitle.text = ""
            jobLb.text = ""
            
            departmentTopConstant.constant = 0
            departmentBottomConstant.constant = 0
            jobTitleConstant.constant = 0
            jobTitleBottomConstant.constant = 0
            
            departmentSeperator.isHidden = true
            jobTitleSeperator.isHidden = true

        }
        
        if userToShow.gender == 1 {
            genderBtn.setTitle("Nam", for: UIControlState.normal)
            genderType = "1"
        }else{
            genderBtn.setTitle("Nữ", for: UIControlState.normal)
            genderType = "0"
        }
        
        if userToShow.dob != 0 {
            dobBtn.setTitle(String().convertTimeStampWithDateFormat(timeStamp: userToShow.dob, dateFormat: "dd/MM/yyyy"), for: .normal)
        }else{
            dobBtn.setTitle("chưa cập nhật", for: UIControlState.normal)
        }
        
        addressTxt.text = userToShow.address
        phoneTxt.text = userToShow.phone
        fullnameTxt.text = userToShow.fullname

        imageUrl = userToShow.avatarUrl
        thumbnailUrl = userToShow.thumbnailAvatarUrl
        emailTxt.text = userToShow.email
    }
    
    @IBAction func genderBtnTapAction(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let manTap = UIAlertAction(title: "Nam", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.genderType = "1"
            self.genderBtn.setTitle("Nam", for: UIControlState.normal)
        })
        
        let femaleTap = UIAlertAction(title: "Nữ", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.genderType = "0"
            self.genderBtn.setTitle("Nữ", for: UIControlState.normal)
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
        DatePickerDialog().show(title: "Ngày sinh", doneButtonTitle: "Xong", cancelButtonTitle: "Hủy", datePickerMode: .date) {
            (date) -> Void in
            if date != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                self.dobBtn.setTitle("\(dateFormatter.string(from: date! as Date))", for: UIControlState.normal)
                self.dobDate = date!.timeIntervalSince1970
            }
        }
    }
    
    @IBAction func selectAvaImgAction(_ sender: Any) {
        self.present(pickerImageController, animated: true, completion: nil)

    }
    
    @IBAction func logoutBtnTapAction(_ sender: Any) {
        requestLogOut()
    }
    
    func requestLogOut(){
        
        let realm = try! Realm()
        let user = realm.objects(UserEntity.self)
        

        
        let uuid = NSUUID().uuidString
        var token = ""
        if let value = UserDefaults.standard.object(forKey: NOTIFICATION_TOKEN) as? String {
            token = value
        }
        let device : [String : Any] = [
            "OS": 0,
            "DeviceId": uuid,
            "Token": token
        ]
        
        let logoutParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "NicknameOrEmail": user[0].email,
            "Device": device
        ]
        print(JSON.init(logoutParam))

        
        Until.showLoading()
        Alamofire.request(LOG_OUT, method: .post, parameters: logoutParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    Until.hideLoading()
                    try! realm.write {
                        realm.delete(user)
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    listNotification.removeAll()
                }else if status == 400 {
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Sai du", cancelBtnTitle: "Đóng")
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }
        
        
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
    
    @IBAction func changePassTapAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangPassViewController") as! ChangPassViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
//        if validateDataUpdate() == "" {
            errLbl.isHidden = true
            if imageAssets.count > 0 {
                uploadImage()
            }else{
                updateUserInfoToServer()
            }
//        }else{
//            errLbl.isHidden = false
//            errLbl.text = validateDataUpdate()
//        }
    }
    
    func updateUserInfoToServer(){
        
        let updateParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "RequestedUserId": userToShow.id,
            "AvatarUrl": imageUrl,
            "ThumbnailAvatarUrl": thumbnailUrl,
            "FullName": fullnameTxt.text!,
            "Job" : "",
            "Address" : addressTxt.text!,
            "Company" : "",
            "Gender" : genderType,
            "DOB" : dobDate,
            "Phone": phoneTxt.text!
        ]
        
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
                            
                            let alert = UIAlertController.init(title: "Thông báo", message: "Cập nhật thông tin tài khoản thành công", preferredStyle: UIAlertControllerStyle.alert)
                            let actionOk = UIAlertAction.init(title: "Đóng", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
//                                _ = self.navigationController?.popViewController(animated: true)
                            })
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UPDATE_USERINFO), object: nil)

                            alert.addAction(actionOk)
                            self.present(alert, animated: true, completion: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
