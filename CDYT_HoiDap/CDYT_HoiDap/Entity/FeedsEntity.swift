//
//  FeedsEntity.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class FeedsEntity: NSObject {
  var authorEntity = AuthorEntity()
  var postEntity = PostEntity()
  var likeCount = 0
  var commentCount = 0
  var isLiked = false
    var isFollowed = false
  var tags = [TagEntity]()
  
  override init(){
    super.init()
  }
  init(dictionary:NSDictionary) {
    if let value = dictionary["Author"] as? NSDictionary {
      authorEntity = AuthorEntity.init(dictionary: value)
    }
    if let value = dictionary["Post"] as? NSDictionary {
      postEntity = PostEntity.init(dictionary: value)
    }
    if let value = dictionary["LikeCount"] as? Int {
      likeCount = value
    }
    if let value = dictionary["CommentCount"] as? Int {
      commentCount = value
    }
    if let value = dictionary["IsLiked"] as? Bool {
      isLiked = value
    }
    if let value = dictionary["IsFollowed"] as? Bool {
        isFollowed = value
    }
    if let value = dictionary["Tags"] as? [NSDictionary] {
      for element in value {
        let entity = TagEntity.init(dictionary: element)
        tags.insert(entity, at: 0)
      }
    }
    
  }
}
