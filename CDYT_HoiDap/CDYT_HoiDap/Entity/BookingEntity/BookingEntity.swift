//
//  BookingEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 28/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class BookingEntity: NSObject {
    
    var id = ""
    var serviceId = ""
    var bookingDate: Double = 0
    var updateDate: Double = 0
    var createDate: Double = 0
    var status = 0
    var checkInResult = CheckInResultEntity()
    var paymentResult = CheckInvoiceEntity()
    var checkupResult = ResultUserEntity()
    var jsonStringPaymentResult = ""
    override init() {
        super.init()
    }
    init(dictionary: NSDictionary) {
        if let value = dictionary["Id"] as? String {
            id = value
        }
        if let value = dictionary["ServiceId"] as? String {
            serviceId = value
        }
        if let value = dictionary["BookingDate"] as? Double {
            bookingDate = value
        }
        if let value = dictionary["UpdatedDate"] as? Double {
            updateDate = value
        }
        if let value = dictionary["CreatedDate"] as? Double {
            createDate = value
        }
        if let value = dictionary["Status"] as? Int {
            status = value
        }
        if let value = dictionary["CheckInResult"] as? String {
          if !value.isEmpty {
            let dic = value.convertStringToDictionary()
            checkInResult = CheckInResultEntity.init(dictionary: dic!)
          }
        }
        if let value = dictionary["PaymentResult"] as? String {
            if !value.isEmpty {
                jsonStringPaymentResult = value
                let dic = value.convertStringToDictionary()
                paymentResult = CheckInvoiceEntity.init(dictionary: dic!)
            }
        }
        if let value = dictionary["CheckupResult"] as? String {
            if !value.isEmpty {
                let dic = value.convertStringToDictionary()
                checkupResult = ResultUserEntity.init(dictionary: dic!)
            }
        }

    }

}
