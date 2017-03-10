//
//  CommentEntity.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class CommentEntity: NSObject {
    var id = ""
    var content = ""
    var imageUrls = [String]()
    var thumbnailImageUrls = [String]()
    var isSolution = false
    var updatedDate : Double = 0
    var createdDate : Double = 0
    var idSolution = ""
    override init(){
        super.init()
    }
    
    func toDictionary(entity: CommentEntity) -> [String : Any] {
        var comment : [String : Any] = [:]
        comment["Id"] = entity.id
        comment["Content"] = entity.content
        comment["ImageUrls"] = entity.imageUrls
        comment["ThumbnailImageUrls"] = entity.thumbnailImageUrls
        comment["IsSolution"] = entity.isSolution
        comment["UpdatedDate"] = entity.createdDate
        comment["CreatedDate"] = entity.createdDate
        return comment
    }
    
    init(dictionary:NSDictionary) {
        if let value = dictionary["Id"] as? String {
            id = value
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
        if let value = dictionary["IsSolution"] as? Bool {
            isSolution = value
        }
        if let value = dictionary["UpdatedDate"] as? Double {
            updatedDate = value
        }
        if let value = dictionary["CreatedDate"] as? Double {
            createdDate = value
        }
    }
    
}
