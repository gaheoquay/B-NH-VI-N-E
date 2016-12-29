//
//  PostEntity.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class PostEntity: NSObject {
  var id = ""
  var title = ""
  var content = ""
  var imageUrls = [String]()
  var thumbnailImageUrls = [String]()
  var status = 0 //0: Not resolve - 1 : Resolved
  var rating:Double = 0
  var updatedDate:Double = 0
  var createdDate:Double = 0
  override init() {
    super.init()
  }
  init(dictionary:NSDictionary) {
    if let value = dictionary["Id"] as? String{
      id = value
    }
    if let value = dictionary["Title"] as? String {
      title = value
    }
    if let value = dictionary["Content"] as? String {
      content = value
    }
    if let value = dictionary["ImageUrls"] as? [String] {
      imageUrls = value
    }
    if let value = dictionary["ThumbnailImageUrls"] as? [String] {
      thumbnailImageUrls = value
    }
    if let value = dictionary["Status"] as? Int {
      status = value
    }
    if let value = dictionary["Rating"] as? Double {
      rating = value
    }
    if let value = dictionary["UpdatedDate"] as? Double {
      updatedDate = value
    }
    if let value = dictionary["CreatedDate"] as? Double {
      createdDate = value
    }
  }
}
