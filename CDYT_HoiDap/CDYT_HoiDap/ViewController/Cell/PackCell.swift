//
//  PackCell.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 4/24/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class PackCell: UITableViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setDataPac(entity: PackEntity){
        lbName.text = entity.name
        lbPrice.text = "\(String().replaceNSnumber(doublePrice: entity.pricePackage))đ"
    }
    
    func setDataSer(entity: ServicesEntity){
        lbPrice.text = "\(String().replaceNSnumber(doublePrice: entity.priceService))đ"
        lbName.text = entity.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
