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
    
    var listMedical = [listMedicalTestsEntity]()

    override func awakeFromNib() {
        super.awakeFromNib()
        tbListMedical.delegate = self
        tbListMedical.dataSource = self
        tbListMedical.register(UINib.init(nibName: "CodeFormAnalysisCell", bundle: nil), forCellReuseIdentifier: "CodeFormAnalysisCell")
        tbListMedical.estimatedRowHeight = 999
        tbListMedical.rowHeight = UITableViewAutomaticDimension
        heightTbList.constant = CGFloat(listMedical.count * 55)
        // Initialization code
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMedical.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodeFormAnalysisCell") as! CodeFormAnalysisCell
        cell.setData(entity: listMedical[indexPath.row])
        return cell
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
