//
//  ListNotificationEntity.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 1/9/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ListNotificationEntity: NSObject {
  var linkedUser = AuthorEntity()
  var notificaiton = NotificationEntity()
  var postTitle = ""
  var content = ""
		
  override init(){
    super.init()
  }
  
  init(dictionary:NSDictionary) {
    if let value = dictionary["LinkedUser"] as? NSDictionary {
      linkedUser = AuthorEntity.init(dictionary: value)
    }
    if let value = dictionary["Notification"] as? NSDictionary {
      notificaiton = NotificationEntity.init(dictionary: value)
    }
    if let value = dictionary["PostTitle"] as? String {
      postTitle = value
    }
    if let value = dictionary["Content"] as? String {
      content = value
    }
  }
}
