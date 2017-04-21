//
//  CodeFormAnalysisCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 15/04/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class CodeFormAnalysisCell: UITableViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgEditUp: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(entity: listMedicalTestsEntity){
        lbName.text = entity.medicalTest.serviceName
        imgEditUp.isHidden = true
    }
    
    func setDataResult(entity: MediCalEntity){
        imgEditUp.isHidden = false
        lbName.text = entity.medicalTestGroup.hisServiceMedicTestGroupID
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
