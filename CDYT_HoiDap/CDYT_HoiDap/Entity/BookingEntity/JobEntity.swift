//
//  JobEntity.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/27/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class JobEntity: NSObject {
  var jobId:Double = 0
  var name = ""
  var updated : Double = 0
  override init(){
    super.init()
  }
  func initListJob() -> [JobEntity] {
  var listJob = [JobEntity]()
    for i in 0..<10 {
      let entity = JobEntity.init()
      entity.jobId = Double(i)
      entity.name = "Job \(i)"
      listJob.append(entity)
    }
    return listJob
  }
  init(dictionary:NSDictionary) {
    if let value = dictionary["HIS_Job_ID"] as? Double {
      jobId = value
    }
    if let value = dictionary["Name"] as? String {
      name = value
    }
    if let value = dictionary["Updated"] as? Double {
      updated = value
    }
  }
}
