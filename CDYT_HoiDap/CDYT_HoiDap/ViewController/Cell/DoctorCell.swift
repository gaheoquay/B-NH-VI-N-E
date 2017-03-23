//
//  DoctorCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 14/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DoctorCell: UITableViewCell {

    @IBOutlet weak var lbNameDoctor: UILabel!
    @IBOutlet weak var lbUnAnswer: UILabel!
    @IBOutlet weak var lbApproval: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(entity: DoctorEntity){
        
        lbNameDoctor.text = entity.doctorEntity.fullname

        let fontBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
        let fontRegular = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        
        
        let myAttrString = NSMutableAttributedString(string: "Chưa trả lời : ", attributes: fontRegular)
        myAttrString.append(NSAttributedString(string: "\(entity.unanswerPostCount)", attributes: fontBold))
        lbUnAnswer.attributedText = myAttrString
        
        let myAttrStringPost = NSMutableAttributedString(string: "Đã trả lời : ", attributes: fontRegular)
        myAttrStringPost.append(NSAttributedString(string: "\(entity.answerPostCount)", attributes: fontBold))
        lbApproval.attributedText = myAttrStringPost
        
        
    }
    
}
