//
//  NotificationEntity.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 1/9/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class NotificationEntity: NSObject {
  var id = ""
  var type = 0
  var detailId = ""
  var parentId = ""
  var isRead = false
  var createdDate : Double = 0
  
  override init() {
    super.init()
  }
  init(dictionary:NSDictionary) {
    if let value = dictionary["Id"] as? String {
      id = value
    }
    if let value = dictionary["Type"] as? Int {
      type = value
    }
    if let value = dictionary["DetailId"] as? String {
      detailId = value
    }
    if let value = dictionary["ParentId"] as? String {
      parentId = value
    }
    if let value = dictionary["IsRead"] as? Bool {
      isRead = value
    }
    if let value = dictionary["CreatedDate"] as? Double {
      createdDate = value
    }
  }
}
