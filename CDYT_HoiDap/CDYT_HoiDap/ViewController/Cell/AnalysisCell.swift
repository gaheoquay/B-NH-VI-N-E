//
//  AnalysisCell.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 4/24/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class AnalysisCell: UITableViewCell {

    @IBOutlet weak var lbNameAnalsys: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(entity: listMedicalTestsEntity){
        lbNameAnalsys.text = entity.medicalTest.serviceName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
