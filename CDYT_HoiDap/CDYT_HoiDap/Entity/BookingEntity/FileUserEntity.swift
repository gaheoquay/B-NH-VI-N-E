//
//  FileUserEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 27/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class FileUserEntity: NSObject {
    var nameId:Double = 0
    var name = ""
    var age  = 0
    override init(){
        super.init()
    }
    func initListUser() -> [FileUserEntity] {
        var listJob = [FileUserEntity]()
        for i in 0..<10 {
            let entity = FileUserEntity.init()
            entity.nameId = Double(i)
            entity.name = "Name \(i)"
            listJob.append(entity)
        }
        return listJob
    }
    init(dictionary:NSDictionary) {
        if let value = dictionary["HIS_Job_ID"] as? Double {
            nameId = value
        }
        if let value = dictionary["Name"] as? String {
            name = value
        }
        if let value = dictionary["Updated"] as? Int {
            age = value
        }
    }

}
