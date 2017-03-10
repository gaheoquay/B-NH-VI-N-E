//
//  CheckInvoiceEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 01/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class CheckInvoiceEntity: NSObject {
    
    var patientHistory = 0
    var invoiceNo = ""
    var amount:Double = 0
    
    override init() {
        super.init()
    }
    
    init(dictionary: [String: Any]) {
        if let value = dictionary["PatientHistory"] as? Int {
            patientHistory = value
        }
        if let value = dictionary["InvoiceNo"] as? String {
            invoiceNo = value
        }
        if let value = dictionary["Amount"] as? Double {
            amount = value
        }
        
    }
    
}
