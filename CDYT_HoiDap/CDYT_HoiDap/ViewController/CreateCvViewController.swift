//
//  CreateCvViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 25/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class CreateCvViewController: BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource {
  
  @IBOutlet weak var lbGender: UILabel!
  @IBOutlet weak var lbDateOfYear: UILabel!
  @IBOutlet weak var txtName: UITextField!
  @IBOutlet weak var txtCMT: UITextField!
  @IBOutlet weak var txtPhoneNumber: UITextField!
  @IBOutlet weak var lbJob: UILabel!
  @IBOutlet weak var lbCountry: UILabel!
  @IBOutlet weak var lbProvince: UILabel!
  @IBOutlet weak var lbZone: UILabel!
  @IBOutlet weak var txtAdress: UITextField!
  @IBOutlet weak var lbDistric: UILabel!
  @IBOutlet weak var txtPhoneGuardian: UITextField!
  @IBOutlet weak var txtNameGuardian: UITextField!
  @IBOutlet weak var txtCmtGuardian: UITextField!
  
  
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
  
  lazy var pickerlistCountry = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
  lazy var pickerlistProvince = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
  lazy var pickerlistDistric = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
  lazy var pickerlistZone = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
  lazy var pickerlistJob = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
  
  
  
  var genderType = ""
  var timeStampDateOfBirt : Double = 0
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    requestData()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: Button
  
  @IBAction func btnGender(_ sender: Any) {
    let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let manTap = UIAlertAction(title: "Nam", style: .default, handler: {
      (alert: UIAlertAction!) -> Void in
      self.genderType = "1"
      self.lbGender.text = "Nam"
    })
    
    let femaleTap = UIAlertAction(title: "Nữ", style: .default, handler: {
      (alert: UIAlertAction!) -> Void in
      self.genderType = "0"
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
    DatePickerDialog().show(title: "Ngày sinh", doneButtonTitle: "Xong", cancelButtonTitle: "Hủy", datePickerMode: .date) {
      (date) -> Void in
      if date != nil {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.lbDateOfYear.text = "\(dateFormatter.string(from: date! as Date))"
        self.timeStampDateOfBirt = (date?.timeIntervalSince1970)!
      }
    }
  }
  
  @IBAction func btnJob(_ sender: Any) {
    if listJob.count == 0 {
      return
    }
    creatAlert(title: "Công việc", picker: pickerlistJob)
  }
  
  @IBAction func btnCitizenship(_ sender: Any) {
    if listCountry.count == 0 {
      return
    }
    creatAlert(title: "Quốc tịch", picker: pickerlistCountry)
  }
  
  @IBAction func btnCity(_ sender: Any) {
    if selectedCountry == nil {
      UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn quốc tịch", cancelBtnTitle: "Đồng ý")
      return
    }
    creatAlert(title: "Tỉnh/Thành phố", picker: pickerlistProvince)
  }
  
  @IBAction func btnCreateCv(_ sender: Any) {
    requestCreateFileUser()
    
  }
  
  @IBAction func btnDistrict(_ sender: Any) {
    if selectedProvince == nil {
      UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn Tỉnh/Thành phố", cancelBtnTitle: "Đồng ý")
      return
    }
    creatAlert(title: "Quận huyện", picker: pickerlistDistric)
  }
  
  @IBAction func btnZones(_ sender: Any) {
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
      }else if picker == self.pickerlistCountry {
        if self.selectedCountry == nil {
          self.selectedCountry = self.listCountry[0]
        }
        self.lbCountry.text = self.selectedCountry.name
        self.listCurrentProvince = self.listProvince.filter({ (entity) -> Bool in
          entity.countryId == self.selectedCountry.countryId
        })
      }else if picker == self.pickerlistProvince {
        if self.selectedProvince == nil {
          self.selectedProvince = self.listCurrentProvince[0]
        }
        self.lbProvince.text = self.selectedProvince.name
        self.listCurrentDistric = self.listDistric.filter({ (entity) -> Bool in
          entity.provinceId == self.selectedProvince.provinceId
        })
      }else if picker == self.pickerlistDistric {
        if self.selectedDistrict == nil {
          self.selectedDistrict = self.listCurrentDistric[0]
        }
        self.lbDistric.text = self.selectedDistrict.name
        self.requestListZonesById(districtId: String(Int(self.selectedDistrict.districtId)))
      }else if picker == self.pickerlistZone {
        if self.selectedZone == nil {
          self.selectedZone = self.listZone[0]
        }
        self.lbZone.text = self.selectedZone.name
      }
    })
    
    alertView.addAction(action)
    present(alertView, animated: true, completion: nil)
  }
  
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
    let main = UIStoryboard(name: "Main", bundle: nil)
    let viewcontroller = main.instantiateViewController(withIdentifier: "FileViewController") as! FileViewController
    self.navigationController?.pushViewController(viewcontroller, animated: true)
  }
  
  
}
