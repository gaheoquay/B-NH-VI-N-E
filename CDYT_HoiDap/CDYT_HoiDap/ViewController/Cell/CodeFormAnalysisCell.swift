//
//  CodeFormAnalysisCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 15/04/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class CodeFormAnalysisCell: UITableViewCell {
    
    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var marginBottomLbId: NSLayoutConstraint! // 34,5
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(entity: listMedicalTestsEntity){
        lbId.text = entity.hisServiceMedicalTestID
        lbName.text = entity.serviceName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
