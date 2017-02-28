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
    var listDistric = [DistrictEntity]()
    var listZone = [ZoneEntity]()
    var listJob = [JobEntity]()
    
    let pickerlistCountry = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
    let pickerlistProvince = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
    let pickerlistDistric = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
    let pickerlistZone = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
    let pickerlistJob = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))

    
    
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
        creatAlert(title: "Công việc", picker: pickerlistJob)
    }
    
    @IBAction func btnCitizenship(_ sender: Any) {
        creatAlert(title: "Quốc tịch", picker: pickerlistCountry)
    }
    
    @IBAction func btnCity(_ sender: Any) {
        creatAlert(title: "Thành phố", picker: pickerlistProvince)
    }
    
    @IBAction func btnCreateCv(_ sender: Any) {
        requestCreateFileUser()
        
    }
    
    @IBAction func btnDistrict(_ sender: Any) {
        creatAlert(title: "Huyện", picker: pickerlistDistric)
    }
    
    @IBAction func btnZones(_ sender: Any) {
        creatAlert(title: "Phường", picker: pickerlistZone)
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
            return listDistric.count
        }else if pickerView == pickerlistProvince {
            return listProvince.count
        }else if pickerView == pickerlistCountry {
            return listCountry.count
        }else {
            return listJob.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerlistZone {
            lbZone.text = listZone[row].name
        }else if pickerView == pickerlistDistric {
            lbDistric.text = listDistric[row].name
        }else if pickerView == pickerlistProvince {
            lbProvince.text = listProvince[row].name
        }else if pickerView == pickerlistCountry {
            lbCountry.text = listCountry[row].name
        }else {
            lbJob.text = listJob[row].name
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerlistZone {
            return listZone[row].name
        }else if pickerView == pickerlistDistric {
            return listDistric[row].name
        }else if pickerView == pickerlistProvince {
            return listProvince[row].name
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
    Alamofire.request(BOOKING_GET_LIST_DISTRICT + districtId, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
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
