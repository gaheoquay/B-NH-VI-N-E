//
//  CountryEntity.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/27/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class CountryEntity: NSObject {
  var countryId:Double = 0
  var name = ""
  var updated : Double = 0
  override init(){
    super.init()
  }
  func initListCountry() -> [CountryEntity] {
    var listCountry = [CountryEntity]()
    for i in 0..<10 {
      let entity = CountryEntity.init()
      entity.countryId = Double(i)
      entity.name = "Country \(i)"
      listCountry.append(entity)
    }
    return listCountry
  }
  init(dictionary:NSDictionary) {
    if let value = dictionary["HIS_Country_ID"] as? Double {
      countryId = value
    }
    if let value = dictionary["Name"] as? String {
      name = value
    }
    if let value = dictionary["Updated"] as? Double {
      updated = value
    }
  }
}
