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

  override init(){
    super.init()
  }
  
  func initListUser() -> [FileUserEntity] {
    var listJob = [FileUserEntity]()
    for i in 0..<10 {
      let entity = FileUserEntity.init()
      //            entity.id = Double(i)
      //            entity.name = "Name \(i)"
      //            listJob.append(entity)
    }
    return listJob
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
  
}
