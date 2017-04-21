//
//  FormAnalysisCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class FormAnalysisCell: UITableViewCell {
    
    @IBOutlet weak var viewNameAnalysis: UIView!
    @IBOutlet weak var viewResult: UIView!
    @IBOutlet weak var viewUnit: UIView!
    @IBOutlet weak var viewValue: UIView!
    @IBOutlet weak var lbNameAnalysis: UILabel!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var lbUnit: UILabel!
    @IBOutlet weak var lbValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        // Initialization code
    }
    
    func setupCell(){
        viewUnit.layer.borderColor = UIColor.gray.cgColor
        viewUnit.layer.borderWidth = 0.5
        viewNameAnalysis.layer.borderColor = UIColor.gray.cgColor
        viewNameAnalysis.layer.borderWidth = 0.5
        viewResult.layer.borderColor = UIColor.gray.cgColor
        viewResult.layer.borderWidth = 0.5
        viewValue.layer.borderColor = UIColor.gray.cgColor
        viewValue.layer.borderWidth = 0.5
    }
    
    func setDataMedical(entity: MedicalTestEntity){
        lbNameAnalysis.text = entity.serviceName
        lbResult.text = entity.indicator
        lbUnit.text = entity.unit
        if entity.femaleHightIndicator != "" {
            lbValue.text = "\(entity.femaleLowIn)-\(entity.femaleHightIndicator)"
        }else {
            lbValue.text = "\(entity.maleLow)-\(entity.maleHight)"
        }
    }
    
    func setData(entity: MedicalTestLinesEntity){
        lbNameAnalysis.text = entity.nameLine
        lbResult.text = entity.indicator
        lbUnit.text = entity.unit
        if entity.femaleHightIndicator != "" {
            lbValue.text = "\(entity.femaleLowIn)-\(entity.femaleHightIndicator)"
        }else {
            lbValue.text = "\(entity.maleLow)-\(entity.maleHight)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
