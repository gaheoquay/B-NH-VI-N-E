//
//  ServiceCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 27/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol ServiceCellDelegate {
    func reloadDataCell(indexPatch: IndexPath)
    func checkSelect(indexPatch: IndexPath)
}

class ServiceCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var lbCombo: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var viewShowDetail: UIView!
    @IBOutlet weak var tbListServiceDetail: UITableView!
    @IBOutlet weak var imgShowDetail: UIImageView!
    @IBOutlet weak var lbShowDetail: UILabel!
    @IBOutlet weak var marginLineBottom: NSLayoutConstraint!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    
    var pacKage = PackagesEntity()
    var serVice = ServicesEntity()
    var indexPatch = IndexPath()
    var isPackage = false
    var delegate: ServiceCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewShowDetail.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(btnShowDetail)))
        tbListServiceDetail.delegate = self
        tbListServiceDetail.dataSource = self
        tbListServiceDetail.estimatedRowHeight = 999
        tbListServiceDetail.rowHeight = UITableViewAutomaticDimension
        tbListServiceDetail.register(UINib.init(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pacKage.service.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! FileCell
        if pacKage.service.count > 0 {
            cell.setDataDetailPackage(entity: pacKage.service[indexPath.row])
        }
        return cell
    }
    
    func btnShowDetail(){
        pacKage.pack.isCheckShowDetail = !pacKage.pack.isCheckShowDetail
        delegate?.reloadDataCell(indexPatch: indexPatch)
    }
    
    func setDataPac(entity: PackEntity){
        viewShowDetail.isHidden = true
        btnSelect.isHidden = true
        lbCombo.text = entity.name
        lbPrice.text = String().replaceNSnumber(doublePrice: entity.pricePackage)
        marginLineBottom.constant = 0
    }
    
    func setDataSer(entity: ServicesEntity){
        viewShowDetail.isHidden = true
        btnSelect.isHidden = true
        lbPrice.text = String().replaceNSnumber(doublePrice: entity.priceService)
        lbCombo.text = entity.name
        marginLineBottom.constant = 0
    }
    
    func setData(){
        
        if !isPackage {
            if !serVice.isCheckSelect {
                btnSelect.setImage(UIImage.init(named: "Check0-2.png"), for: .normal)
            }else {
                btnSelect.setImage(UIImage
                    .init(named: "Check1-2.png"), for: .normal)
            }
            
            lbCombo.text = serVice.name
            lbPrice.text = String().replaceNSnumber(doublePrice: serVice.priceService)
            marginLineBottom.constant = 0
            viewShowDetail.isHidden = true
        }else {
            viewShowDetail.isHidden = false
            lbCombo.text = pacKage.pack.name
            lbPrice.text = String().replaceNSnumber(doublePrice: pacKage.pack.pricePackage)
            
            if !pacKage.pack.isCheckSelect {
                btnSelect.setImage(UIImage.init(named: "Check0-2.png"), for: .normal)
            }else {
                btnSelect.setImage(UIImage.init(named: "Check1-2.png"), for: .normal)
            }
            
            if !pacKage.pack.isCheckShowDetail {
                lbShowDetail.text = "Chi tiết"
                imgShowDetail.image = UIImage(named: "DetailEdit.png")
                marginLineBottom.constant = 0
            }else {
                lbShowDetail.text = "Thu gọn"
                imgShowDetail.image = UIImage(named: "Edit.png")
                marginLineBottom.constant = CGFloat(pacKage.service.count * 58)
                tbListServiceDetail.reloadData()
            }
        }
        contentView.layoutIfNeeded()
    }
    
    
    
    @IBAction func btnSelect(_ sender: Any) {
        delegate?.checkSelect(indexPatch: indexPatch)
        if isPackage {
            pacKage.pack.isCheckSelect = !pacKage.pack.isCheckSelect
            if !pacKage.pack.isCheckSelect {
                btnSelect.setImage(UIImage.init(named: "Check0-2.png"), for: .normal)
            }else {
                btnSelect.setImage(UIImage.init(named: "Check1-2.png"), for: .normal)
            }
        }else {
            serVice.isCheckSelect = !serVice.isCheckSelect
            if !serVice.isCheckSelect {
                btnSelect.setImage(UIImage.init(named: "Check0-2.png"), for: .normal)
            }else {
                btnSelect.setImage(UIImage.init(named: "Check1-2.png"), for: .normal)
            }
        }
    }
    
    
}
