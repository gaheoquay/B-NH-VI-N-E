//
//  MedicalCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 15/04/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class MedicalCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tbListMedical: UITableView!
    @IBOutlet weak var heightTbList: NSLayoutConstraint!
    
    var indexPatchs = IndexPath()
    var listMedical = [MediCalEntity]()


    override func awakeFromNib() {
        super.awakeFromNib()
        tbListMedical.delegate = self
        tbListMedical.dataSource = self
        tbListMedical.register(UINib.init(nibName: "CodeFormAnalysisCell", bundle: nil), forCellReuseIdentifier: "CodeFormAnalysisCell")
//        heightTbList.constant = CGFloat(listMedical.count * 55)
        
        // Initialization code
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listMedical.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listMedical[section].medicalTestGroup.hisServiceMedicTestGroupID
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMedical[section].listMedicalTests.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodeFormAnalysisCell") as! CodeFormAnalysisCell
        cell.setData(entity: listMedical[indexPath.section].listMedicalTests[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
