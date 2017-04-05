//
//  RegisterViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//


import UIKit
protocol RegisterViewControllerDelegate {
    func reloadDataDoctor(indexPatch: IndexPath, doctor:DoctorEntity)
    func reloadDataAdmin(admin: ListAdminEntity)
}

class RegisterViewController: UIViewController, NVActivityIndicatorViewable,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nicknameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var repassTxt: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var errLbl: UILabel!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtDepartmen: UITextField!
    @IBOutlet weak var lbJob: UILabel!
    @IBOutlet weak var viewDepartmen: UIView!
    @IBOutlet weak var lbLineName: UILabel!
    @IBOutlet weak var lbLineDepartmen: UILabel!

    let pickerImageController = DKImagePickerController()
    var imageAssets = [DKAsset]()
    var isCreateAcc = false
    var isAdmin = false
    var imageUrl = ""
    var thumbnailUrl = ""
    let pickerViewCate = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
    var indexPathOfCell = 0
    var indexDoctor = IndexPath()
    var role = 0
    var listDoc = [DoctorEntity]()
    var idCate = ""
    var delegate: RegisterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDkImagePicker()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: REGISTER_USER)
    }

    func setupUI(){
        avatarImg.layer.cornerRadius = 10
        avatarImg.clipsToBounds = true
        registerBtn.layer.cornerRadius = 5
        registerBtn.clipsToBounds = true
        if isCreateAcc {
            if isAdmin {
            role = 2
            txtDepartmen.isHidden = true
            txtFullName.isHidden = true
            lbLineName.isHidden = true
            lbLineDepartmen.isHidden = true
            }else {
            txtFullName.isHidden = false
            txtDepartmen.isHidden = false
//            viewDepartmen.isHidden = false
            lbLineName.isHidden = false
            lbLineDepartmen.isHidden = false
            role = 1
            }
        }else{
            txtFullName.isHidden = true
            txtDepartmen.isHidden = true
//            viewDepartmen.isHidden = true
            lbLineName.isHidden = true
            lbLineDepartmen.isHidden = true
            role = 0
        }
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
                self.avatarImg.image = UIImage.init(named: "AvaDefaut.png")
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
        
        var token = ""
        if let value = UserDefaults.standard.object(forKey: NOTIFICATION_TOKEN) as? String {
            token = value
        }
        
        let device : [String : Any] = [
            "OS": 0,
            "DeviceId": uuid,
            "Token": token
        ]
        
        let nickString = nicknameTxt.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let emailString = emailTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let passString = passTxt.text
        let fullNameString = txtFullName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let jobString = txtDepartmen.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let user : [String : Any] = [
            "Email": emailString!,
            "Password": DataEncryption.getMD5(from: passString),
            "Nickname": nickString!,
            "FullName": fullNameString!,
            "Role": role,
            "Job": "",
            "Address": "",
            "Phone": "",
            "Company": "",
            "SocialType": 0,
            "SocialId": "",
            "Gender": 0,
            "AvatarUrl": imageUrl,
            "ReputationRate": 0,
            "ThumbnailAvatarUrl": thumbnailUrl,
            "IsVerified": false,
            "CreatedDate": 0,
            "UpdateDate": 0,
            "DepartmentId" : idCate,
            "JobTitle" : jobString!,
            "DOB":0
        ]

        let registerParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "User": user,
            "Device": device,
            "RequestedUserId": Until.getCurrentId()
        ]
        Until.showLoading()
        print(registerParam)
        Alamofire.request(REGISTER_USER, method: .post, parameters: registerParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        let reaml = try! Realm()
                        let entity = UserEntity.initWithDictionary(dictionary: jsonData)
                        Until.initSendBird()
                        if self.isCreateAcc {
                            if self.isAdmin {
                                let entity = ListAdminEntity.init(dictionary: jsonData)
                                self.delegate?.reloadDataAdmin(admin: entity)
                                _ = self.navigationController?.popViewController(animated: true)
                            }else {
                                let entity = AuthorEntity.init(dictionary: jsonData)
                                let doctor = DoctorEntity()
                                doctor.doctorEntity = entity
                                self.delegate?.reloadDataDoctor(indexPatch: self.indexDoctor, doctor: doctor)
                                _ = self.navigationController?.popViewController(animated: true)

                            }
                            }else {
                            try! reaml.write {
                                reaml.add(entity, update: true)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LOGIN_SUCCESS), object: nil)
                                _ = self.navigationController?.popToRootViewController(animated: true)
                            }
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
    
    
    func validateData() -> String{
        let nickString = nicknameTxt.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let emailString = emailTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let passString = passTxt.text
        let rePassString = repassTxt.text
        let fullNameString = txtFullName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let jobString = txtDepartmen.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
        }
        
        if isCreateAcc {
            if isAdmin {
                return ""
            }else {
                if fullNameString == "" {
                    return "Vui lòng nhập đầy đủ họ tên"
                }else if jobString == "" {
                    return "Vui lòng chọn chức danh"
                }else{
                    return ""
                }
            }
            }else {
            return ""
        }
    }
  @IBAction func actionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
    
    @IBAction func btnPickCategory(_ sender: Any) {
        creatAlert(title: "Chọn khoa", picker: pickerViewCate)
    }
    
    func creatAlert(title: String, picker: UIPickerView){
        let alertView = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alertView.view.addSubview(picker)
        
        picker.delegate = self
        picker.dataSource = self
        
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.lbJob.text = listCate[self.indexPathOfCell].name
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
        self.indexPathOfCell = row
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
