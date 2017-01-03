//
//  SearchTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 1/3/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func setData(result:String,isAsk:Bool){
    if isAsk {
      lbSearch.text = "Đặt câu hỏi với từ khóa đang nhập"
      lbSearch.font = UIFont.boldSystemFont(ofSize: 14)
      lbSearch.textColor = UIColor.init(netHex: 0x01a7fa)
    }else{
      lbSearch.text = result
      lbSearch.font = UIFont.boldSystemFont(ofSize: 14)
      lbSearch.textColor = UIColor.black
    }
  }
  
//    MARK: Outlet
  @IBOutlet weak var lbSearch: UILabel!
}
