//
//  ListDoctor.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/18/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ListDoctor: NSObject {
  var category = CateEntity()
  var count = 0
  var doctors = [AuthorEntity]()
  override init() {
    super.init()
  }
  init(dictionary:NSDictionary) {
    
  }
}
