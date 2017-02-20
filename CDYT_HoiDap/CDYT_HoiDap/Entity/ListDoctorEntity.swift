//
//  ListDoctor.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/18/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ListDoctorEntity: NSObject {
  var category = CateEntity()
  var count = 0
  var doctors = [AuthorEntity]()
  var isExpand = false
  override init() {
    super.init()
  }
  init(dictionary:NSDictionary) {
    if let value = dictionary["Category"] as? NSDictionary {
      category = CateEntity.init(dictionary: value)
    }
    if let value = dictionary["Count"] as? Int {
      count = value
    }
    if let value = dictionary["Doctors"] as? [NSDictionary] {
      for dic in value {
        let entity = AuthorEntity.init(dictionary: dic)
        doctors.append(entity)
      }
    }
  }
}
