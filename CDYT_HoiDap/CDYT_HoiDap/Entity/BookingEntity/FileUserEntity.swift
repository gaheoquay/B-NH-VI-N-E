//
//  FileUserEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 27/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class FileUserEntity: NSObject {
  
  var id = ""
  var patientName = ""
  var gender = 0
  var dOB:Double = 0
  var passportId = ""
  var phoneNumber = ""
  var jobId = ""
  var jobName  = ""
  var countryId = ""
  var countryName = ""
  var provinceId = ""
  var provinceName = ""
  var dictrictId = ""
  var dictrictName = ""
  var zoneId = ""
  var zoneName = ""
  var address = ""
  var bailsmanName = ""
  var bailsmanPhoneNumber = ""
  var bailsmanPassportId = ""
  var updatedDate : Double = 0
  var createdDate : Double = 0
  var age = 0
  
  override init(){
    super.init()
  }
  
  init(dictionary:NSDictionary) {
    if let value = dictionary["Id"] as? String {
      id = value
    }
    if let value = dictionary["PatientName"] as? String {
      patientName = value
    }
    if let value = dictionary["Gender"] as? Int {
      gender = value
    }
    if let value = dictionary["DOB"] as? Double {
      dOB = value
      let birthDate = Date(timeIntervalSince1970: dOB)
      let calendar : Calendar = Calendar.current
      let dateComponent = calendar.dateComponents([.year], from: birthDate)
      age = (calendar.date(from: dateComponent)?.age)! + 1
    }
    if let value = dictionary["PassportId"] as? String {
      passportId = value
    }
    if let value = dictionary["PhoneNumber"] as? String {
      phoneNumber = value
    }
    if let value = dictionary["JobId"] as? String {
      jobId = value
    }
    if let value = dictionary["JobName"] as? String {
      jobName = value
    }
    if let value = dictionary["CountryId"] as? String {
      countryId = value
    }
    if let value = dictionary["CountryName"] as? String {
      countryName = value
    }
    if let value = dictionary["ProvinceId"] as? String {
      provinceId = value
    }
    if let value = dictionary["ProvinceName"] as? String {
      provinceName = value
    }
    if let value = dictionary["DictrictId"] as? String {
      dictrictId = value
    }
    if let value = dictionary["DictrictName"] as? String {
      dictrictName = value
    }
    if let value = dictionary["ZoneId"] as? String {
      zoneId = value
    }
    if let value = dictionary["ZoneName"] as? String {
      zoneName = value
    }
    if let value = dictionary["Address"] as? String {
      address = value
    }
    if let value = dictionary["BailsmanName"] as? String {
      bailsmanName = value
    }
    if let value = dictionary["BailsmanPhoneNumber"] as? String {
      bailsmanPhoneNumber = value
    }
    if let value = dictionary["BailsmanPassportId"] as? String {
      bailsmanPassportId = value
    }
    if let value = dictionary["UpdatedDate"] as? Double {
      updatedDate = value
    }
    if let value = dictionary["CreatedDate"] as? Double {
      createdDate = value
    }
  }
  func toDictionary(entity:FileUserEntity) -> [String:Any]{
    var param = [String:Any]()
    param["Id"] = entity.id
    param["PatientName"] = entity.patientName
    param["Gender"] = entity.gender
    param["DOB"] = String(format : "%.0f",entity.dOB)
    param["PassportId"] = entity.passportId
    param["PhoneNumber"] = entity.phoneNumber
    param["JobId"] = entity.jobId
    param["JobName"] = entity.jobName
    param["CountryId"] = entity.countryId
    param["CountryName"] = entity.countryName
    param["ProvinceId"] = entity.provinceId
    param["ProvinceName"] = entity.provinceName
    param["DictrictId"] = entity.dictrictId
    param["DictrictName"] = entity.dictrictName
    param["ZoneId"] = entity.zoneId
    param["ZoneName"] = entity.zoneName
    param["Address"] = entity.address
    param["BailsmanName"] = entity.bailsmanName
    param["BailsmanPhoneNumber"] = entity.bailsmanPhoneNumber
    param["BailsmanPassportId"] = entity.bailsmanPassportId
    param["UpdatedDate"] = entity.updatedDate
    param["CreatedDate"] = entity.createdDate
    return param
  }
}
