//
//  InsertAccountCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 21/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol InsertAccountCellDelegate {
    func createAccountDoctor(indexPatchSection: IndexPath, indexPatchRow: Int)
}

class InsertAccountCell: UITableViewCell {
    
    @IBOutlet weak var viewCreateAcc: UIView!
    var delegate : InsertAccountCellDelegate?
    
    var indexPatchSection = IndexPath()
    var indexPatchRow = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        viewCreateAcc.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(createAccountDoctor)))
        // Initialization code
    }
    
    func createAccountDoctor(){
        delegate?.createAccountDoctor(indexPatchSection: indexPatchSection, indexPatchRow: indexPatchRow)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
