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

class RegisterViewController: UIViewController, NVActivityIndicatorViewable,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                lbLineName.isHidden = false
                lbLineDepartmen.isHidden = false
                role = 1
            }
        }else{
            txtFullName.isHidden = true
            txtDepartmen.isHidden = true
            lbLineName.isHidden = true
            lbLineDepartmen.isHidden = true
            role = 0
        }
    }
    
    @IBAction func chooseAvatarAction(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alert = UIAlertController(title: "Thêm ảnh", message: "Chọn ảnh", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(title: "Thư viện", style: .default) { (UIAlertAction) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let saveAction = UIAlertAction(title: "Album", style: .default) { (UIAlertAction) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let canAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        
        alert.addAction(canAction)
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let choiceImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.avatarImg.image = choiceImage
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.avatarImg.image = UIImage.init(named: "AvaDefaut.png")
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            Until.showLoading()
            
            Alamofire.upload(multipartFormData: { (MultipartFormData) in
                if let imgUp = self.avatarImg.image!.jpegRepresentationData {
                    MultipartFormData.append(imgUp as Data, withName: "Image", fileName: "file.png", mimeType: "image/png")
                }
            }, to: UPLOAD_IMAGE, headers: header, encodingCompletion: { encodingResult in
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
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    @IBAction func registerBtnAction(_ sender: Any) {
        if validateData() == "" {
            errLbl.isHidden = true
            
            if self.avatarImg != nil {
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
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
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
                "User": user,
                "Device": device,
                "RequestedUserId": Until.getCurrentId()
            ]
            Until.showLoading()
            print(registerParam)
            Alamofire.request(REGISTER_USER, method: .post, parameters: registerParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
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
                                    let alert = UIAlertController(title: "Thông báo", message: "Tạo tài khoản thành công", preferredStyle: .alert)
                                    let alertAction = UIAlertAction(title: "Đóng", style: .default, handler: { (UIAlertAction) in
                                        _ = self.navigationController?.popViewController(animated: true)
                                    })
                                    alert.addAction(alertAction)
                                    self.present(alert, animated: true, completion: nil)
                                }else {
                                    let entity = AuthorEntity.init(dictionary: jsonData)
                                    let doctor = DoctorEntity()
                                    doctor.doctorEntity = entity
                                    self.delegate?.reloadDataDoctor(indexPatch: self.indexDoctor, doctor: doctor)
                                    let alert = UIAlertController(title: "Thông báo", message: "Tạo tài khoản thành công", preferredStyle: .alert)
                                    let alertAction = UIAlertAction(title: "Đóng", style: .default, handler: { (UIAlertAction) in
                                        _ = self.navigationController?.popViewController(animated: true)
                                    })
                                    alert.addAction(alertAction)
                                    self.present(alert, animated: true, completion: nil)
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
        } catch let error as NSError {
            print(error)
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
            return "Vui lòng điền tên đăng nhập."
        }else if !isValidInput(input: nicknameTxt.text!) {
            nicknameTxt.becomeFirstResponder()
            return "Tên đăng nhập từ 6 đến 30 ký tự và không chứa ký tự đặc biệt."
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
        }else if (passString?.characters.count)! < 6 || (passString?.characters.count)! > 30 {
            return "Mật khẩu từ 6 đến 30 ký tự."
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
    
    func isValidInput(input:String) -> Bool {
        let regEx = "[A-Z0-9a-z]{6,30}"
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        return test.evaluate(with: input)
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
extension UIImage {
    var jpegRepresentationData: NSData! {
        return UIImageJPEGRepresentation(self, 0.5)! as NSData   // QUALITY min = 0 / max = 1
    }
}

