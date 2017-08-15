//
//  DoctorEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 14/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DoctorEntity: NSObject {
    
    var doctorEntity = AuthorEntity()
    var answerPostCount = 0
    var unanswerPostCount = 0
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
      
        if let value = dictionary["Doctor"] as? NSDictionary {
            doctorEntity = AuthorEntity.init(dictionary: value)
        }
        if let value = dictionary["AnsweredPostCount"] as? Int {
            answerPostCount = value
        }
        if let value = dictionary["UnansweredPostCount"] as? Int {
            unanswerPostCount = value
        }
      
    }

}
