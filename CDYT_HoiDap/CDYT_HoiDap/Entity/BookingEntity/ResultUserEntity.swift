//
//  ResultUserEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 02/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ResultUserEntity: NSObject {
    
    var patienHistoryId = 0
    var firt_diagnostic = ""
    var prognosis = ""
    var diseaseProgress = ""
    var diseaseDiagnostic_ID = ""
    var other_DiseaseDiagnostic_ID = ""
    var doctorAdvice_ID = ""
    
    override init() {
        super.init()
    }
    init(dictionary: [String:Any]) {
        if let value = dictionary["HIS_PatientHistory_ID"] as? Int {
            patienHistoryId = value
        }
        if let value = dictionary["First_Diagnostic"] as? String {
            firt_diagnostic = value
        }
        if let value = dictionary["Prognosis"] as? String {
            prognosis = value
        }
        if let value = dictionary["DiseaseProgress"] as? String {
            diseaseProgress = value
        }
        if let value = dictionary["DiseaseDiagnostic_ID"] as? String {
            diseaseDiagnostic_ID = value
        }
        if let value = dictionary["HIS_DoctorAdvice_ID"] as? String {
            other_DiseaseDiagnostic_ID = value
        }
        if let value = dictionary["HIS_DoctorAdvice_ID"] as? String {
            doctorAdvice_ID = value
        }
    }
}

