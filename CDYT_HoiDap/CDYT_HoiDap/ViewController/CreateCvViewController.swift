//
//  CreateCvViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 25/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

protocol CreateCvViewControllerDelegate {
  func reloadData()
}

class CreateCvViewController: BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource {
  
    @IBOutlet weak var lbTittle: UILabel!
  @IBOutlet weak var lbGender: UILabel!
  @IBOutlet weak var lbDateOfYear: UILabel!
  @IBOutlet weak var txtName: UITextField!
  @IBOutlet weak var txtCMT: UITextField!
  @IBOutlet weak var txtPhoneNumber: UITextField!
  @IBOutlet weak var lbJob: UILabel!
  @IBOutlet weak var lbCountry: UILabel!
  @IBOutlet weak var lbProvince: UILabel!
  @IBOutlet weak var lbZone: UILabel!
  @IBOutlet weak var lbDistric: UILabel!
  @IBOutlet weak var txtPhoneGuardian: UITextField!
  @IBOutlet weak var txtNameGuardian: UITextField!
  @IBOutlet weak var txtCmtGuardian: UITextField!
    @IBOutlet weak var viewNameGuardian: UIView!
    @IBOutlet weak var viewPhoneGuardian: UIView!
    @IBOutlet weak var viewCmtGuardian: UIView!
    @IBOutlet var tapJob: UITapGestureRecognizer!
    @IBOutlet var tapCountry: UITapGestureRecognizer!
    @IBOutlet var tapDistric: UITapGestureRecognizer!
    @IBOutlet var tapProvince: UITapGestureRecognizer!
    @IBOutlet var tapZone: UITapGestureRecognizer!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet var tapGender: UITapGestureRecognizer!
    @IBOutlet var tapDob: UITapGestureRecognizer!
    
  
  var infoUser = FileUserEntity()
  var listCountry = [CountryEntity]()
  var listProvince = [ProvinceEntity]() // Tỉnh
  var listCurrentProvince : [ProvinceEntity]!
  var listDistric = [DistrictEntity]()
  var listCurrentDistric : [DistrictEntity]!
  var listZone = [ZoneEntity]()
  var listJob = [JobEntity]()
  var selectedJob : JobEntity!
  var selectedCountry : CountryEntity!
  var selectedProvince : ProvinceEntity!
  var selectedDistrict : DistrictEntity!
  var selectedZone : ZoneEntity!
    
    var age = 0
    
    var datePicker = Date()
    var dateNow = Date()
  
  lazy var pickerlistCountry = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
  lazy var pickerlistProvince = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
  lazy var pickerlistDistric = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
  lazy var pickerlistZone = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
  lazy var pickerlistJob = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
  
  var delegate:CreateCvViewControllerDelegate?
  
  var genderType = 1
  var timeStampDateOfBirt : Double = 0
    
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
    requestData()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func updateUI(){
    if infoUser.zoneId != "" {
        txtName.text = infoUser.patientName
        genderType = infoUser.gender
        if genderType == 1 {
            lbGender.text = "Nam"
        }else {
            lbGender.text = "Nữ"
        }
        lbTittle.text = "Hồ sơ"
        txtCMT.text = infoUser.passportId
        txtPhoneNumber.text = infoUser.phoneNumber
        lbJob.text = infoUser.jobName
        lbCountry.text = infoUser.countryName
        lbProvince.text = infoUser.provinceName
        lbDistric.text = infoUser.dictrictName
        lbZone.text = infoUser.zoneName
        txtCmtGuardian.text = infoUser.bailsmanPassportId
        txtNameGuardian.text = infoUser.bailsmanName
        txtPhoneGuardian.text = infoUser.bailsmanPhoneNumber
        let dOb = infoUser.dOB
        lbDateOfYear.text = String().convertTimeStampWithDateFormat(timeStamp: dOb, dateFormat: "dd/MM/YYYY")
               txtPhoneGuardian.isEnabled = false
        txtPhoneNumber.isEnabled = false
        txtCmtGuardian.isEnabled = false
        txtNameGuardian.isEnabled = false
        tapJob.isEnabled = false
        tapZone.isEnabled = false
        tapCountry.isEnabled = false
        tapDistric.isEnabled = false
        tapProvince.isEnabled = false
        btnDone.isHidden = true
        txtCmtGuardian.isEnabled = false
        txtNameGuardian.isEnabled = false
        txtPhoneGuardian.isEnabled = false
        tapDob.isEnabled = false
        tapGender.isEnabled = false
        txtCMT.isEnabled = false
        txtName.isEnabled = false
        if infoUser.age > 6 {
        viewCmtGuardian.isHidden = true
        viewNameGuardian.isHidden = true
        viewPhoneGuardian.isHidden = true
        }else {
        viewCmtGuardian.isHidden = false
        viewNameGuardian.isHidden = false
        viewPhoneGuardian.isHidden = false
        }
        
        
        
    }else {
    lbTittle.text = "Tạo hồ sơ"
    lbCountry.text = "Việt Nam"
    timeStampDateOfBirt = Date().timeIntervalSince1970
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    self.lbDateOfYear.text = "\(dateFormatter.string(from: Date()))"
    viewCmtGuardian.isHidden = false
    viewNameGuardian.isHidden = false
    viewPhoneGuardian.isHidden = false
        
        txtNameGuardian.isEnabled = true
        tapJob.isEnabled = true
        tapZone.isEnabled = true
        tapCountry.isEnabled = true
        tapDistric.isEnabled = true
        tapProvince.isEnabled = true
        btnDone.isHidden = false
        txtPhoneGuardian.isEnabled = true
        txtPhoneNumber.isEnabled = true
        txtCmtGuardian.isEnabled = true
        txtNameGuardian.isEnabled = true
        txtCMT.isEnabled = true
        txtName.isEnabled = true
        txtCmtGuardian.isEnabled = true
        txtNameGuardian.isEnabled = true
        txtPhoneGuardian.isEnabled = true
        tapDob.isEnabled = true
        tapGender.isEnabled = true
    }

  }
  //MARK: Button
  
  @IBAction func btnGender(_ sender: Any) {
    self.view.endEditing(true)
    let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let manTap = UIAlertAction(title: "Nam", style: .default, handler: {
      (alert: UIAlertAction!) -> Void in
      self.genderType = 1
      self.lbGender.text = "Nam"
    })
    
    let femaleTap = UIAlertAction(title: "Nữ", style: .default, handler: {
      (alert: UIAlertAction!) -> Void in
      self.genderType = 0
      self.lbGender.text = "Nữ"
    })
    
    let cancelTap = UIAlertAction(title: "Huỷ", style: .cancel, handler: {
      (alert: UIAlertAction!) -> Void in
      
    })
    
    optionMenu.addAction(manTap)
    optionMenu.addAction(femaleTap)
    optionMenu.addAction(cancelTap)
    
    
    self.present(optionMenu, animated: true, completion: nil)
  }
  @IBAction func btnDateOfBirth(_ sender: Any) {
    self.view.endEditing(true)
    DatePickerDialog().show(title: "Ngày sinh", doneButtonTitle: "Xong", cancelButtonTitle: "Hủy", datePickerMode: .date) {
      (date) -> Void in
      
        
      if date != nil {
        self.datePicker = date as! Date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.lbDateOfYear.text = "\(dateFormatter.string(from: date! as Date))"
        self.timeStampDateOfBirt = (date?.timeIntervalSince1970)!
        
        let calendar : Calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.year], from: date as! Date)
        
        self.age = (calendar.date(from: dateComponent)?.age)!
        
        if self.age < 6 {
            self.viewCmtGuardian.isHidden = false
            self.viewNameGuardian.isHidden = false
            self.viewPhoneGuardian.isHidden = false
        }
            
        else {
            self.viewCmtGuardian.isHidden = true
            self.viewNameGuardian.isHidden = true
            self.viewPhoneGuardian.isHidden = true
        }
        
        
      }
        
        
    }
  }
  
  @IBAction func btnJob(_ sender: Any) {
    self.view.endEditing(true)
    if listJob.count == 0 {
      return
    }
    creatAlert(title: "Công việc", picker: pickerlistJob)
  }
  
  @IBAction func btnCitizenship(_ sender: Any) {
    self.view.endEditing(true)
    if listCountry.count == 0 {
      return
    }
    creatAlert(title: "Quốc tịch", picker: pickerlistCountry)
  }
  
  @IBAction func btnCity(_ sender: Any) {
    self.view.endEditing(true)
    if selectedCountry == nil {
      UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn quốc tịch", cancelBtnTitle: "Đồng ý")
      return
    }
    if listCurrentProvince.count == 0 {
      return
    }
    creatAlert(title: "Tỉnh/Thành phố", picker: pickerlistProvince)
  }
  
  @IBAction func btnCreateCv(_ sender: Any) {
    self.view.endEditing(true)
    requestCreateFileUser()
    
  }
  
  @IBAction func btnDistrict(_ sender: Any) {
    self.view.endEditing(true)
    if selectedProvince == nil {
      UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn Tỉnh/Thành phố", cancelBtnTitle: "Đồng ý")
      return
    }
    if listCurrentDistric.count == 0 {
      return
    }
    creatAlert(title: "Quận huyện", picker: pickerlistDistric)
  }
  
  @IBAction func btnZones(_ sender: Any) {
    self.view.endEditing(true)
    if selectedDistrict == nil {
      UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn Tỉnh/Thành phố", cancelBtnTitle: "Đồng ý")
      return
    }
    if listZone.count == 0 {
      return
    }
    creatAlert(title: "Phường xã", picker: pickerlistZone)
  }
  
  
  @IBAction func btnBack(_ sender: Any) {
    self.view.endEditing(true)
    _ = self.navigationController?.popViewController(animated: true)
    
  }
  
  //MARK: CollectionViewINfo
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView == pickerlistZone {
      return listZone.count
    }else if pickerView == pickerlistDistric {
      return listCurrentDistric.count
    }else if pickerView == pickerlistProvince {
      return listCurrentProvince.count
    }else if pickerView == pickerlistCountry {
      return listCountry.count
    }else {
      return listJob.count
    }
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == pickerlistZone {
      selectedZone = listZone[row]
    }else if pickerView == pickerlistDistric {
      selectedDistrict = listCurrentDistric[row]
    }else if pickerView == pickerlistProvince {
      selectedProvince = listCurrentProvince[row]
    }else if pickerView == pickerlistCountry {
      selectedCountry = listCountry[row]
    }else {
      selectedJob = listJob[row]
    }
    
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView == pickerlistZone {
      return listZone[row].name
    }else if pickerView == pickerlistDistric {
      return listCurrentDistric[row].name
    }else if pickerView == pickerlistProvince {
      return listCurrentProvince[row].name
    }else if pickerView == pickerlistCountry {
      return listCountry[row].name
    }else {
      return listJob[row].name
    }
  }
  
  //MARK: AddPicker
  
  func creatAlert(title: String, picker: UIPickerView){
    let alertView = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
    alertView.view.addSubview(picker)
    
    picker.delegate = self
    picker.dataSource = self
    
    
    let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
      if picker == self.pickerlistJob{
        if self.selectedJob == nil{
          self.selectedJob = self.listJob[0]
        }
        self.lbJob.text = self.selectedJob.name
        self.lbJob.textColor = UIColor.init(netHex: 0x61abfa)
      }else if picker == self.pickerlistCountry {
        if self.selectedCountry == nil {
          self.selectedCountry = self.listCountry[0]
        }
        self.lbCountry.text = self.selectedCountry.name
        self.lbCountry.textColor = UIColor.init(netHex: 0x61abfa)
        self.listCurrentProvince = self.listProvince.filter({ (entity) -> Bool in
          entity.countryId == self.selectedCountry.countryId
        })
      }else if picker == self.pickerlistProvince {
        if self.selectedProvince == nil {
          self.selectedProvince = self.listCurrentProvince[0]
        }
        self.lbProvince.text = self.selectedProvince.name
        self.lbProvince.textColor = UIColor.init(netHex: 0x61abfa)
        self.listCurrentDistric = self.listDistric.filter({ (entity) -> Bool in
          entity.provinceId == self.selectedProvince.provinceId
        })
      }else if picker == self.pickerlistDistric {
        if self.selectedDistrict == nil {
          self.selectedDistrict = self.listCurrentDistric[0]
        }
        self.lbDistric.text = self.selectedDistrict.name
        self.lbDistric.textColor = UIColor.init(netHex: 0x61abfa)
        self.requestListZonesById(districtId: String(Int(self.selectedDistrict.districtId)))
      }else if picker == self.pickerlistZone {
        if self.selectedZone == nil {
          self.selectedZone = self.listZone[0]
        }
        self.lbZone.text = self.selectedZone.name
        self.lbZone.textColor = UIColor.init(netHex: 0x61abfa)
      }
    })
    
    alertView.addAction(action)
    present(alertView, animated: true, completion: nil)
  }
//  MARK: request to server
  func requestData(){
    requestListJob()
    requestListCountry()
    requestListProvice()
    requestListDistrict()
  }

  func requestListJob(){
    Alamofire.request(BOOKING_GET_LIST_JOB, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! [NSDictionary]
            
            for item in jsonData {
              let entity = JobEntity.init(dictionary: item)
              self.listJob.append(entity)
            }
          }
        }else{
          UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
        }
      }else{
        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
      }
    }
  }
  func requestListCountry(){
    Alamofire.request(BOOKING_GET_LIST_COUNTRY, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! [NSDictionary]
            for item in jsonData {
              let entity = CountryEntity.init(dictionary: item)
              self.listCountry.append(entity)
              if entity.name.lowercased() == "việt nam"{
                self.selectedCountry = entity
                self.listCurrentProvince = self.listProvince.filter({ (proviceEntity) -> Bool in
                  proviceEntity.countryId == self.selectedCountry.countryId
                })
              }
            }
          }
        }else{
          UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
        }
      }else{
        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
      }
    }
  }
  func requestListProvice(){
    Alamofire.request(BOOKING_GET_LIST_PROVICE, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! [NSDictionary]
            
            for item in jsonData {
              let entity = ProvinceEntity.init(dictionary: item)
              self.listProvince.append(entity)
            }
          }
        }else{
          UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
        }
      }else{
        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
      }
    }
  }
  func requestListDistrict(){
    Alamofire.request(BOOKING_GET_LIST_DISTRICT, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! [NSDictionary]
            
            for item in jsonData {
              let entity = DistrictEntity.init(dictionary: item)
              self.listDistric.append(entity)
            }
          }
        }else{
          UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
        }
      }else{
        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
      }
    }
  }
  func requestListZonesById(districtId:String){
    Alamofire.request(BOOKING_GET_LIST_ZONE_BY_ID + districtId, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! [NSDictionary]
            
            for item in jsonData {
              let entity = ZoneEntity.init(dictionary: item)
              self.listZone.append(entity)
            }
          }
        }else{
          UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
        }
      }else{
        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
      }
    }
  }
  
  func requestCreateFileUser(){
    let name = txtName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//    let passPortId = txtCMT.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//    let phone = txtPhoneNumber.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if name.isEmpty || timeStampDateOfBirt == 0 || selectedCountry == nil || selectedProvince == nil || selectedDistrict == nil || selectedZone == nil {
      UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng nhập đầy đủ thông tin", cancelBtnTitle: "Đóng")
      return
    }else if datePicker > dateNow {
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Ngày sinh không được lớn hơn ngày hiện tại", cancelBtnTitle: "Đóng")
          return
    }
    let userEntity = FileUserEntity()
    userEntity.patientName = txtName.text!
    userEntity.gender = genderType
    userEntity.dOB = timeStampDateOfBirt
    let birthDate = Date(timeIntervalSince1970: userEntity.dOB)
    let calendar : Calendar = Calendar.current
    let dateComponent = calendar.dateComponents([.year], from: birthDate)
    userEntity.age = (calendar.date(from: dateComponent)?.age)!
    if userEntity.age < 6 {
      let bailsmanName = txtNameGuardian.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
      let bailsmanPhoneNumber = txtPhoneGuardian.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
      let bailsmanPassportId = txtCmtGuardian.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
      if bailsmanName.isEmpty || bailsmanPhoneNumber.isEmpty || bailsmanPassportId.isEmpty {
        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Bạn chưa nhập thông tin Người bảo lãnh đối với hồ sơ dưới 6 tuổi.", cancelBtnTitle: "Đóng")
        return
      }
        
    }
    userEntity.passportId = txtCMT.text!
    userEntity.phoneNumber = txtPhoneNumber.text!
    userEntity.jobId = String(format: "%.0f",selectedJob.jobId)
    userEntity.jobName = selectedJob.name
    userEntity.countryId = String(format: "%.0f",selectedCountry.countryId)
    userEntity.countryName = selectedCountry.name
    userEntity.provinceId = String(format: "%.0f",selectedProvince.provinceId)
    userEntity.provinceName = selectedProvince.name
    userEntity.dictrictId = String(format: "%.0f",selectedDistrict.districtId)
    userEntity.dictrictName = selectedDistrict.name
    userEntity.zoneId = String(format: "%.0f",selectedZone.zoneId)
    userEntity.zoneName = selectedZone.name
    userEntity.address = selectedZone.name + " " + selectedDistrict.name + " " + selectedProvince.name + " " + selectedCountry.name
    userEntity.bailsmanName = txtNameGuardian.text!
    userEntity.bailsmanPhoneNumber = txtPhoneGuardian.text!
    userEntity.bailsmanPassportId = txtCmtGuardian.text!
    
    let profile : [String:Any] = FileUserEntity().toDictionary(entity: userEntity)
    let param : [String:Any] = [
      "Auth": Until.getAuthKey(),
      "RequestedUserId" : Until.getCurrentId(),
      "Profile" : profile
    ]
    Until.showLoading()
    print(param)
    Alamofire.request(BOOKING_ADDING_PROFILE, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        if status == 200{
          if response.result.value != nil {
            _ = self.navigationController?.popViewController(animated: true)
            self.delegate?.reloadData()
          }
        }else{
          UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
        }
        Until.hideLoading()
      }else{
        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
      }
    }

    
  }
}
