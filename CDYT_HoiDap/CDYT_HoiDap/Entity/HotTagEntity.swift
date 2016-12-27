//
//  HotTagEntity.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/27/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class HotTagEntity: NSObject {
    var tag = TagEntity()
    var isFollowed = false
    
    override init(){
        super.init()
    }
    
    init(dictionary:NSDictionary) {
        if let value = dictionary["Tag"] as? NSDictionary {
            tag = TagEntity.init(dictionary: value)
        }
        
        if let value = dictionary["IsFollowed"] as? Bool {
            isFollowed = value
        }
    }
}
