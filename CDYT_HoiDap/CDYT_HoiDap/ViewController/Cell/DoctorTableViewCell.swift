//
//  DoctorTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/20/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DoctorTableViewCell: UITableViewCell {
  @IBOutlet weak var imgProfile: UIImageView!
  @IBOutlet weak var lbName: UILabel!
  @IBOutlet weak var lbJob: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  func setData(entity:AuthorEntity){
    imgProfile.sd_setImage(with: URL.init(string: entity.avatarUrl), placeholderImage: #imageLiteral(resourceName: "AvaDefaut.png"))
    lbName.text = entity.fullname
    lbJob.text = entity.jobTitle + " - Bệnh Viện E"
  }
}
