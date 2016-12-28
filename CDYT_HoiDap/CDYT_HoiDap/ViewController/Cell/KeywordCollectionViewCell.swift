//
//  KeywordCollectionViewCell.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/27/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class KeywordCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
      lbKeyword.layer.borderWidth = 0.5
      lbKeyword.layer.borderColor = UIColor.init(netHex: 0x87baf0).cgColor
      lbKeyword.layer.cornerRadius = lbKeyword.frame.height/2
        // Initialization code
    }
  func setData(tagName:String){
    lbKeyword.text = "  " + tagName + "  "
  }
  @IBOutlet weak var lbKeyword: UILabel!
}
