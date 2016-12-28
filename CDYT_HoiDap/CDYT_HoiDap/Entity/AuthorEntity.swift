//
//  AuthorEntity.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class AuthorEntity: NSObject {
  var id = ""
  var email = ""
  var nickname = ""
  var fullname = ""
  var job = ""
  var company = ""
  var dob : Double = 0
  var address = ""
  var gender = 0
  var thumbnailAvatarUrl = ""
  var avatarUrl = ""
  var phone = ""
  var socialId = ""
  var socialType = 0
  var role = 1
  var reputationRate = 1
  var isVerified = false
  var updatedDate : Double = 0
  var createdDate : Double = 0
  override init(){
    super.init()
  }
  init(dictionary:NSDictionary) {
    if let value = dictionary["Id"] as? String{
      id = value
    }
    if let value = dictionary["Email"] as? String {
      email = value
    }
    if let value = dictionary["Nickname"] as? String {
      nickname = value
    }
    if let value = dictionary["FullName"] as? String {
      fullname = value
    }
    if let value = dictionary["Job"] as? String {
      job = value
    }
    if let value = dictionary["Company"] as? String {
      company = value
    }
    if let value = dictionary["DOB"] as? Double {
      dob = value
    }
    if let value = dictionary["Address"] as? String {
      address = value
    }
    if let value = dictionary["Gender"] as? Int {
      gender = value
    }
    if let value = dictionary["ThumbnailAvatarUrl"] as? String {
      thumbnailAvatarUrl = value
    }
    if let value = dictionary["AvatarUrl"] as? String {
      avatarUrl = value
    }
    if let value = dictionary["Phone"] as? String {
      phone = value
    }
    if let value = dictionary["SocialId"] as? String {
      socialId = value
    }
    if let value = dictionary["SocialType"] as? Int {
      socialType = value
    }
    if let value = dictionary["Role"] as? Int {
      role = value
    }
    if let value = dictionary["ReputationRate"] as? Int {
      reputationRate = value
    }
    if let value = dictionary["IsVerified"] as? Bool {
      isVerified = value
    }
    if let value = dictionary["UpdatedDate"] as? Double {
      updatedDate = value
    }
    if let value = dictionary["CreatedDate"] as? Double {
      createdDate = value
    }

  }
}