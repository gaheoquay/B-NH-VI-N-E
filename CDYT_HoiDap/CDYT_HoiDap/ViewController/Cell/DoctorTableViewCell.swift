//
//  DoctorTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/20/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol DoctorTableViewCellDelegate {
    func blockUser(author: AuthorEntity, admin: ListAdminEntity)
    func gotoUpdateProfile(author: AuthorEntity, admin: ListAdminEntity, indexPatchAdmin: IndexPath)
}

class DoctorTableViewCell: UITableViewCell {
  @IBOutlet weak var imgProfile: UIImageView!
  @IBOutlet weak var lbName: UILabel!
  @IBOutlet weak var lbJob: UILabel!
    @IBOutlet weak var imgBlock: UIImageView!
    @IBOutlet weak var marginLeftLbName: NSLayoutConstraint!
    @IBOutlet weak var imgVerified: UIImageView!
   
    var delegate: DoctorTableViewCellDelegate?
    var author = AuthorEntity()
    var admin = ListAdminEntity()
    var indexPatch = IndexPath()
    var isBlock = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.blockUser))
        let tapUpdate = UITapGestureRecognizer.init(target: self, action: #selector(self.gotoUpdate))
        tapUpdate.numberOfTapsRequired = 1
        tap.numberOfTapsRequired = 1
        lbJob.addGestureRecognizer(tap)
        lbName.addGestureRecognizer(tapUpdate)
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
                // Configure the view for the selected state
    }
    
    func blockUser(){
        delegate?.blockUser(author: author, admin: admin)
    }
    
    func gotoUpdate(){
        delegate?.gotoUpdateProfile(author: author, admin: admin, indexPatchAdmin: indexPatch)
    }
    
  func setData(){
    imgProfile.sd_setImage(with: URL.init(string: author.avatarUrl), placeholderImage: #imageLiteral(resourceName: "AvaDefaut.png"))
    lbName.text = author.fullname
    lbName.isUserInteractionEnabled = true
    if isBlock {
        lbJob.text = author.jobTitle + " - Bệnh Viện E"
        marginLeftLbName.constant = 8
        imgBlock.isHidden = true
        imgVerified.isHidden = false
    }else {
        imgBlock.isHidden = false
        marginLeftLbName.constant = 30
        imgVerified.isHidden = true
        lbJob.isUserInteractionEnabled = true
        if !author.isBlocked {
            lbJob.text = "Khoá tài khoản"
            imgBlock.image = UIImage(named: "Khoa.png")
        }else {
            lbJob.text = "Mở khoá tài khoản"
            imgBlock.image = UIImage(named: "MoKhoa.png")
        }
       
    }
    
  }
    func setDataAdmin(){
        lbName.isUserInteractionEnabled = true
        imgBlock.isHidden = false
        marginLeftLbName.constant = 30
        imgVerified.isHidden = true
        lbJob.isUserInteractionEnabled = true
        lbName.text = admin.nickName
        imgProfile.sd_setImage(with: URL.init(string: admin.avatar), placeholderImage: #imageLiteral(resourceName: "AvaDefaut.png"))
        if !admin.isBlocked {
            lbJob.text = "Khoá tài khoản"
            imgBlock.image = UIImage(named: "Khoa.png")
        }else {
            lbJob.text = "Mở khoá tài khoản"
            imgBlock.image = UIImage(named: "MoKhoa.png")
        }
        

    }
}
