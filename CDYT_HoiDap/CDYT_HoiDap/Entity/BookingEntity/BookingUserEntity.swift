//
//  BookingUserEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 01/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class BookingUserEntity: NSObject {
    
    var profile = FileUserEntity()
    var booking = [BookingEntity]()
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["Profile"] as? NSDictionary {
            profile = FileUserEntity.init(dictionary: value)
        }
        if let value = dictionary["Bookings"] as? [NSDictionary] {
            for item in value {
                let entity = BookingEntity.init(dictionary: item)
                booking.append(entity)
            }
            
        }
    }

}
