//
//  CodeFormAnalysisCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 15/04/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol CodeFormAnalysisCellDelegate {
    func reloadDataCell(indexPatch: IndexPath)
}

class CodeFormAnalysisCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var viewXN: UIView!
    @IBOutlet weak var imgEditUp: UIImageView!
    @IBOutlet weak var tbListLines: UITableView!
    @IBOutlet weak var marginBottomLine: NSLayoutConstraint!
    @IBOutlet weak var viewKQ: UIView!
    @IBOutlet weak var viewDV: UIView!
    @IBOutlet weak var viewGBT: UIView!
    @IBOutlet weak var heightLine: NSLayoutConstraint!
    @IBOutlet weak var btnShowDetail: UIButton!
    @IBOutlet weak var heightTXN: NSLayoutConstraint!
    @IBOutlet weak var heightKQ: NSLayoutConstraint!
    @IBOutlet weak var heightDV: NSLayoutConstraint!
    @IBOutlet weak var heightGTBT: NSLayoutConstraint!
    
    var mediCal = listMedicalTestsEntity()
    var indexPatch = IndexPath()
    var delegate: CodeFormAnalysisCellDelegate?
    var heightCell: CGFloat = 0
    var isLine = false

    override func awakeFromNib() {
        super.awakeFromNib()
        tbListLines.delegate = self
        tbListLines.dataSource = self
        tbListLines.estimatedRowHeight = 999
        tbListLines.rowHeight = UITableViewAutomaticDimension
        tbListLines.register(UINib.init(nibName: "FormAnalysisCell", bundle: nil), forCellReuseIdentifier: "FormAnalysisCell")
        viewDV.layer.borderWidth = 0.5
        viewDV.layer.borderColor = UIColor.black.cgColor
        viewKQ.layer.borderWidth = 0.5
        viewKQ.layer.borderColor = UIColor.black.cgColor
        viewXN.layer.borderWidth = 0.5
        viewXN.layer.borderColor = UIColor.black.cgColor
        viewGBT.layer.borderWidth = 0.5
        viewGBT.layer.borderColor = UIColor.black.cgColor
        // Initialization code
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mediCal.medicalTestLines.count > 0 {
            return mediCal.medicalTestLines.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FormAnalysisCell") as! FormAnalysisCell
        if mediCal.medicalTestLines.count > 0 {
            cell.setData(entity: mediCal.medicalTestLines[indexPath.row])
        }else {
            cell.setDataMedical(entity: mediCal.medicalTest)
        }
        return cell
    }
    
    @IBAction func btnShowDetail(_ sender: Any) {
        mediCal.isShowDetail = !mediCal.isShowDetail
        delegate?.reloadDataCell(indexPatch: indexPatch)
    }
    
    func setDataExam(entity: listMedicalTestsEntity){
        lbName.text = entity.medicalTest.serviceName
        marginBottomLine.constant = 0
        heightDV.constant = 0
        heightKQ.constant = 0
        heightTXN.constant = 0
        heightGTBT.constant = 0
        heightLine.constant = 0
        imgEditUp.isHidden = true
    }
    
    func setData(){
        lbName.text = mediCal.medicalTest.serviceName
        if isLine {
            if !mediCal.isShowDetail {
                marginBottomLine.constant = 0
                heightDV.constant = 0
                heightKQ.constant = 0
                heightTXN.constant = 0
                heightGTBT.constant = 0
            }else {
                heightDV.constant = 44
                heightKQ.constant = 44
                heightTXN.constant = 44
                heightGTBT.constant = 44
                for item in mediCal.medicalTestLines {
                    let a = item.nameLine.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width / 4 - 16 , font: .systemFont(ofSize: 11)) + 16
                    heightCell = heightCell + a
                }
                marginBottomLine.constant = heightCell + 55
            }
        }else {
            if !mediCal.isShowDetail {
                marginBottomLine.constant = 0
                heightDV.constant = 0
                heightKQ.constant = 0
                heightTXN.constant = 0
                heightGTBT.constant = 0
            }else {
                heightDV.constant = 44
                heightKQ.constant = 44
                heightTXN.constant = 44
                heightGTBT.constant = 44
                marginBottomLine.constant = mediCal.medicalTest.serviceName.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width / 4 - 16 , font: .systemFont(ofSize: 11)) + 16 + 44
            }
        }
        contentView.layoutIfNeeded()
    }
    
    func setDataResult(entity: MediCalEntity){
        marginBottomLine.constant = 0
        lbName.text = entity.medicalTestGroup.hisServiceMedicTestGroupID
        viewDV.isHidden = true
        viewKQ.isHidden = true
        viewXN.isHidden = true
        viewGBT.isHidden = true
        heightLine.constant = 0
        btnShowDetail.isHidden = true
        contentView.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
