//
//  MainCommentEntity.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class MainCommentEntity: NSObject {
    var post = PostEntity()
    var author = AuthorEntity()
    var comment = CommentEntity()
    var department = DepartmentEntity()
    var isLike = false
    var likeCount = 0
    var subComment = [SubCommentEntity]()
    var isShowMore = false
    var postAuthor = AuthorEntity()
    override init (){
        super.init()
    }
    
    init(dict : NSDictionary) {
        if let value = dict["Post"] as? NSDictionary {
            post = PostEntity.init(dictionary: value)
        }
        if let value = dict["Author"] as? NSDictionary {
            author = AuthorEntity.init(dictionary: value)
        }
        if let value = dict["Comment"] as? NSDictionary {
            comment = CommentEntity.init(dictionary: value)
        }
        if let value = dict["IsLiked"] as? Bool {
            isLike = value
        }
        if let value = dict["LikeCount"] as? Int {
            likeCount = value
        }
        if let value = dict["Department"] as? NSDictionary {
            department = DepartmentEntity.init(dictionary: value)
        }
        if let value = dict["SubComment"] as? [NSDictionary] {
            for item in value {
                let entity = SubCommentEntity.init(dict: item)
                subComment.append(entity)
            }
        }
        if let value = dict["PostAuthor"] as? NSDictionary {
            postAuthor = AuthorEntity.init(dictionary: value)
        }
    }
}
