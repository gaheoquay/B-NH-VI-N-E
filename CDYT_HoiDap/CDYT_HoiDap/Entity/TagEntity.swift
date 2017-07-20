//
//  TagEntity.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/27/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class TagEntity: NSObject {
    var id = ""
    var tagName = ""
    var tagNameSearch = ""
    
    override init(){
        super.init()
    }
    
    init(dictionary:NSDictionary) {
        if let value = dictionary["Id"] as? String {
            id = value
        }
        if let value = dictionary["TagName"] as? String {
            tagName = value
        }
        if let value = dictionary["TagNameSearch"] as? String {
            tagNameSearch = value
        }
    }
}
