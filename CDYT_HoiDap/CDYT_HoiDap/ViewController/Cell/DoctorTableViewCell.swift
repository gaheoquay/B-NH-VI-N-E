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
    @IBOutlet weak var btnBlock: UIButton!
    
    var delegate: DoctorTableViewCellDelegate?
    var author = AuthorEntity()
    var department = DepartmentEntity()
    var admin = ListAdminEntity()
    var indexPatch = IndexPath()
    var isBlock = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func btnBlock(_ sender: Any) {
        delegate?.blockUser(author: author, admin: admin)
    }
    
    
    func setData(){
        imgProfile.sd_setImage(with: URL.init(string: author.avatarUrl), placeholderImage: #imageLiteral(resourceName: "AvaDefaut.png"))
        lbName.text = author.fullname
        lbName.isUserInteractionEnabled = true
        if isBlock {
            var jobTitle = ""
            if author.index == 0 {
                jobTitle = "Trưởng khoa"
            }else if author.index == 1 {
                jobTitle = "Phó khoa"
            } else if author.index == 2 {
                jobTitle = "Bác sĩ khoa"
            }
            lbJob.text = jobTitle + " " + department.name + " - Bệnh viện E"
            marginLeftLbName.constant = 8
            imgBlock.isHidden = true
            imgVerified.isHidden = false
            btnBlock.isHidden = true
        }else {
            imgBlock.isHidden = false
            btnBlock.isHidden = false
            marginLeftLbName.constant = 30
            imgVerified.isHidden = true
            lbJob.isUserInteractionEnabled = true
            if !author.isBlocked {
                lbJob.text = "Đang mở"
                imgBlock.image = UIImage(named: "MoKhoa.png")
                btnBlock.setTitle("Khoá", for: .normal)
                btnBlock.setTitleColor(UIColor.init(netHex: 0xd6d6d6), for: .normal)
            }else {
                lbJob.text = "Đang khoá"
                imgBlock.image = UIImage(named: "Khoa.png")
                btnBlock.setTitle("Mở", for: .normal)
                btnBlock.setTitleColor(UIColor.init(netHex: 0x77d851), for: .normal)
            }
            
        }
        
    }
    func setDataAdmin(){
        lbName.isUserInteractionEnabled = true
        imgBlock.isHidden = false
        marginLeftLbName.constant = 30
        imgVerified.isHidden = true
        lbJob.isUserInteractionEnabled = true
        lbName.text = admin.fullName
        imgProfile.sd_setImage(with: URL.init(string: admin.avatar), placeholderImage: #imageLiteral(resourceName: "AvaDefaut.png"))
        if !admin.isBlocked {
            lbJob.text = "Đang mở"
            imgBlock.image = UIImage(named: "MoKhoa.png")
            btnBlock.setTitle("Khoá", for: .normal)
            btnBlock.setTitleColor(UIColor.init(netHex: 0xd6d6d6), for: .normal)
        }else {
            lbJob.text = "Đang khoá"
            imgBlock.image = UIImage(named: "Khoa.png")
            btnBlock.setTitle("Mở", for: .normal)
            btnBlock.setTitleColor(UIColor.init(netHex: 0x77d851), for: .normal)
            
        }
        
        
    }
}
