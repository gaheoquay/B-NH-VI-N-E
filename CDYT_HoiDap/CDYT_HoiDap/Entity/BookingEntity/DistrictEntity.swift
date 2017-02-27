//
//  DistrictEntity.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/27/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DistrictEntity: NSObject {
  var provinceId:Double = 0
  var districtId:Double = 0
  var name = ""
  var updated : Double = 0
  override init(){
    super.init()
  }
  func initListCountry() -> [DistrictEntity] {
    var listCountry = [DistrictEntity]()
    for i in 0..<10 {
      let entity = DistrictEntity.init()
      entity.districtId = Double(i)
      entity.provinceId = Double(i)
      entity.name = "District \(i)"
      listCountry.append(entity)
    }
    return listCountry
  }
  init(dictionary:NSDictionary) {
    if let value = dictionary["HIS_Province_ID"] as? Double {
      provinceId = value
    }
    if let value = dictionary["HIS_District_ID"] as? Double {
      districtId = value
    }
    if let value = dictionary["Name"] as? String {
      name = value
    }
    if let value = dictionary["Updated"] as? Double {
      updated = value
    }
  }
}
