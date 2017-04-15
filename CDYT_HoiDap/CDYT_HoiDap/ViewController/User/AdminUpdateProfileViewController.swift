//
//  AdminUpdateProfileViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 22/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol AdminUpdateProfileViewControllerDelegate {
    func reloadDataUpdateProfile(author: AuthorEntity, admin: ListAdminEntity, isAdmin: Bool)
}

class AdminUpdateProfileViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var lbFullName: UILabel!
    @IBOutlet weak var txtAdress: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtJobtitle: UITextField!
    @IBOutlet weak var lbDepartmen: UILabel!
    @IBOutlet weak var lbJobtitle: UILabel!
    @IBOutlet weak var btnGender: UIButton!
    @IBOutlet weak var btnDob: UIButton!
    @IBOutlet weak var txtName: UITextField!
    
    let pickerImageController = DKImagePickerController()
    var imageAssets = [DKAsset]()
    var imageUrl = ""
    var thumbnailUrl = ""
    var author = AuthorEntity()
    var admin = ListAdminEntity()
    var role = 0
    var genderType = 0
    var doB : Double = 0
    var departmenId = ""
    var indexPatchCate = 0
    var delegate : AdminUpdateProfileViewControllerDelegate?
    var departmenName = ""
    var isAdmin = false
    
    @IBOutlet weak var btnDepartmen: UIButton!
    
    let pickerViewCate = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        initDkImagePicker()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpUI(){
        if !isAdmin {
            btnDepartmen.isEnabled = false
            lbFullName.text = author.nickname
            txtName.text = author.fullname
            txtPhoneNumber.text = author.phone
            btnDepartmen.setTitle("\(departmenName)", for: .normal)
            txtJobtitle.text = author.jobTitle
            txtEmail.text = author.email
            txtAdress.text = author.address
            btnDepartmen.isHidden = false
            txtJobtitle.isHidden = false
            lbDepartmen.isHidden = false
            lbJobtitle.isHidden = false
            imgAvatar.sd_setImage(with: URL.init(string: author.thumbnailAvatarUrl), placeholderImage: #imageLiteral(resourceName: "AvaDefaut.png"))
            imageUrl = author.avatarUrl
            thumbnailUrl = author.thumbnailAvatarUrl
            btnDob.setTitle("\(String().convertTimeStampWithDateFormat(timeStamp: author.dob, dateFormat: "dd/MM/YYYY"))", for: .normal)
            doB = author.dob
            if author.gender == 1 {
                btnGender.setTitle("Nam", for: .normal)
            }else {
                btnGender.setTitle("Nữ", for: .normal)
            }
        }else {
            lbFullName.text = admin.nickName
            txtName.text = admin.fullName
            txtPhoneNumber.text = admin.phone
            btnDepartmen.isHidden = true
            txtJobtitle.isHidden = true
            lbDepartmen.isHidden = true
            lbJobtitle.isHidden = true
            txtEmail.text = admin.email
            txtAdress.text = admin.adress
            imgAvatar.sd_setImage(with: URL.init(string: admin.thumbnailAvatar), placeholderImage: #imageLiteral(resourceName: "AvaDefaut.png"))
            imageUrl = admin.avatar
            thumbnailUrl = admin.thumbnailAvatar
            btnDob.setTitle("\(String().convertTimeStampWithDateFormat(timeStamp: admin.dob, dateFormat: "dd/MM/YYYY"))", for: .normal)
            doB = admin.dob
            if admin.gender == 1 {
                btnGender.setTitle("Nam", for: .normal)
            }else {
                btnGender.setTitle("Nữ", for: .normal)
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
    
    func updateUserInfoToServer(){
        var user : [String:Any] = [:]
        
        var dpId = ""
        var id = ""
        var nickName = ""
        if !isAdmin {
            role = author.role
            id = author.id
            nickName = author.nickname
            dpId = self.departmenId
        }else {
            id = admin.id
            nickName = admin.nickName
            role = admin.role
            dpId = ""
        }
        
        user = [
            "Id": id,
            "Email": txtEmail.text!,
            "Password": "",
            "Nickname": nickName,
            "FullName": txtName.text!,
            "Role": role,
            "Job": "",
            "Address": txtAdress.text!,
            "Phone": txtPhoneNumber.text!,
            "Company": "",
            "SocialType": 0,
            "SocialId": "",
            "Gender": genderType,
            "AvatarUrl": imageUrl,
            "ReputationRate": 0,
            "ThumbnailAvatarUrl": thumbnailUrl,
            "IsVerified": true,
            "DepartmentId" : dpId,
            "JobTitle" : txtJobtitle.text!,
            "CreatedDate": 0,
            "UpdateDate": 0,
            "DOB":doB
        ]
        
        let updateParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "User": user,
            "RequestedUserId": Until.getCurrentId()
        ]
        
        Until.showLoading()
        print(updateParam)
        Alamofire.request(UPDATE_BY_ADMIN, method: .post, parameters: updateParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        if !self.isAdmin {
                            let entity = AuthorEntity.init(dictionary: jsonData)
                            self.author = entity
                        }else {
                            let entity = ListAdminEntity.init(dictionary: jsonData)
                            self.admin = entity
                        }
                    }
                    let alert = UIAlertController.init(title: "Thông báo", message: "Cập nhật thông tin tài khoản thành công", preferredStyle: UIAlertControllerStyle.alert)
                    let actionOk = UIAlertAction.init(title: "Đóng", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                        self.delegate?.reloadDataUpdateProfile(author: self.author, admin: self.admin, isAdmin: self.isAdmin)
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(actionOk)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }
    }
    
    func creatAlert(title: String, picker: UIPickerView){
        let alertView = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alertView.view.addSubview(picker)
        
        picker.delegate = self
        picker.dataSource = self
        
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.departmenId = listCate[self.indexPatchCate].id
            self.btnDepartmen.setTitle("\(listCate[self.indexPatchCate].name)", for: .normal)
        })
        
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }

    
    func initDkImagePicker(){
        pickerImageController.assetType = DKImagePickerControllerAssetType.allPhotos
        pickerImageController.maxSelectableCount = 1
        pickerImageController.didSelectAssets = { [unowned self] ( assets: [DKAsset]) in
            self.imageAssets = assets
            if assets.count > 0 {
                let asset = assets[0]
                asset.fetchOriginalImage(true, completeBlock: {(image, info) -> Void in
                    self.imgAvatar.image = image!
                })
                
            }
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnUpdateInfo(_ sender: Any) {
        if imageAssets.count > 0 {
            uploadImage()
        }else{
            updateUserInfoToServer()
        }
    }
    @IBAction func btnSelectImage(_ sender: Any) {
        self.present(pickerImageController, animated: true, completion: nil)
    }
    
    @IBAction func btnChoiceGender(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let manTap = UIAlertAction(title: "Nam", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.genderType = 1
            self.btnGender.setTitle("Nam", for: UIControlState.normal)
        })
        
        let femaleTap = UIAlertAction(title: "Nữ", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.genderType = 0
            self.btnGender.setTitle("Nữ", for: UIControlState.normal)
        })
        
        let cancelTap = UIAlertAction(title: "Huỷ", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(manTap)
        optionMenu.addAction(femaleTap)
        optionMenu.addAction(cancelTap)
        
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func btnDob(_ sender: Any) {
        DatePickerDialog().show(title: "Ngày sinh", doneButtonTitle: "Xong", cancelButtonTitle: "Hủy", datePickerMode: .date) {
            (date) -> Void in
            if date != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                self.btnDob.setTitle("\(dateFormatter.string(from: date! as Date))", for: UIControlState.normal)
                self.doB = date!.timeIntervalSince1970
            }
        }
        
    }
    
    @IBAction func btnDepartmen(_ sender: Any) {
        creatAlert(title: "Chọn chuyên khoa", picker: pickerViewCate)
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
        self.indexPatchCate = row
    }
    
    
}
