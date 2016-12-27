//
//  QuestionTagTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/27/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class QuestionTagTableViewCell: UITableViewCell {

    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var borderView: UIView!
    
    var hotTag = HotTagEntity()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.cornerRadius = 5
        borderView.clipsToBounds = true
    }

    func setData() {
        tagName.text = hotTag.tag.id
        if hotTag.isFollowed {
            followBtn.setTitle("Bỏ theo dõi", for: UIControlState.normal)
            followBtn.setTitleColor(UIColor().hexStringToUIColor(hex: "7ed321"), for: UIControlState.normal)
        }else{
            followBtn.setTitle("Theo dõi", for: UIControlState.normal)
            followBtn.setTitleColor(UIColor().hexStringToUIColor(hex: "9e9e9e"), for: UIControlState.normal)

        }
    }
    
    @IBAction func followBtnAction(_ sender: Any) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
