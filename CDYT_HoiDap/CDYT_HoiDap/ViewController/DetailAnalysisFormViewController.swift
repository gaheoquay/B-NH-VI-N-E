//
//  DetailAnalysisFormViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DetailAnalysisFormViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var lbFormCode: UILabel!
    @IBOutlet weak var imgBarCode: UIImageView!
    @IBOutlet weak var lbValueNormal: UILabel!
    @IBOutlet weak var lbAnalysis: UILabel!
    @IBOutlet weak var tbListResult: UITableView!
    @IBOutlet weak var viewAnalysis: UIView!
    @IBOutlet weak var viewResult: UIView!
    @IBOutlet weak var viewValue: UIView!
    @IBOutlet weak var viewUnit: UIView!
    @IBOutlet weak var heightTbResult: NSLayoutConstraint!
    @IBOutlet weak var lbTitle: UILabel!
    
    var medicalGroups = MediCalEntity()
    var heightTb: CGFloat = 0
    var b : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        tbListResult.delegate = self
        tbListResult.dataSource = self
        tbListResult.register(UINib.init(nibName: "FormAnalysisCell", bundle: nil), forCellReuseIdentifier: "FormAnalysisCell")
        tbListResult.estimatedRowHeight = 999
        tbListResult.rowHeight = UITableViewAutomaticDimension
        viewUnit.layer.borderWidth = 0.5
        viewUnit.layer.borderColor = UIColor.gray.cgColor
        viewAnalysis.layer.borderWidth = 0.5
        viewAnalysis.layer.borderColor = UIColor.gray.cgColor
        viewResult.layer.borderWidth = 0.5
        viewResult.layer.borderColor = UIColor.gray.cgColor
        viewValue.layer.borderWidth = 0.5
        viewValue.layer.borderColor = UIColor.gray.cgColor
        tbListResult.layer.borderWidth = 0.5
        tbListResult.layer.borderColor = UIColor.gray.cgColor
        lbAnalysis.text = " TÊN XÉT \n NGHIỆM"
        lbValueNormal.text = " GIÁ TRỊ \n BÌNH \n THƯỜNG"
        let image = Until.generateBarcode(from: "\(medicalGroups.medicalTestGroup.hisServiceMedicTestGroupID)")
        imgBarCode.image = image
        for item in medicalGroups.listMedicalTests {
            for a in item.medicalTestLines {
                let height = a.nameLine.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width / 4 - 24, font: .systemFont(ofSize: 11)) + 16
                heightTb = heightTb + height
            }
            
            if item.medicalTest.unit != "" {
                heightTbResult.constant = heightTb + CGFloat(medicalGroups.listMedicalTests.count * 30) + item.medicalTest.serviceName.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width / 4 - 24, font: .systemFont(ofSize: 11)) + 16
            }else {
                heightTbResult.constant = heightTb + CGFloat(medicalGroups.listMedicalTests.count * 30)
            }
        }
        lbFormCode.text = medicalGroups.medicalTestGroup.hisServiceMedicTestGroupID
        lbTitle.text = "Kết quả xét nghiệm"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return medicalGroups.listMedicalTests.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.gray
        
        let labelTitle = UILabel.init()
        
        labelTitle.font = UIFont.systemFont(ofSize: 11)
        labelTitle.textColor = UIColor.black
        labelTitle.text = "\(medicalGroups.medicalTestGroup.hisServiceMedicTestGroupID)"
        labelTitle.frame = CGRect.init(x: 8, y: 15, width: labelTitle.frame.size.width, height: labelTitle.frame.size.height)
       
        labelTitle.sizeToFit()
        
        viewHeader.addSubview(labelTitle)
        return viewHeader

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if medicalGroups.listMedicalTests[section].medicalTest.unit != "" {
            if medicalGroups.listMedicalTests[section].medicalTestLines.count > 0 {
                return medicalGroups.listMedicalTests[section].medicalTestLines.count + medicalGroups.listMedicalTests.count
            }else {
                return medicalGroups.listMedicalTests.count
            }
        }else {
            return medicalGroups.listMedicalTests[section].medicalTestLines.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FormAnalysisCell") as! FormAnalysisCell
        if medicalGroups.listMedicalTests[indexPath.section].medicalTest.unit != "" {
            if indexPath.row < medicalGroups.listMedicalTests.count {
                cell.setDataMedical(entity: medicalGroups.listMedicalTests[indexPath.section].medicalTest)
            }else {
                if medicalGroups.listMedicalTests[indexPath.section].medicalTestLines.count > 0 {
                cell.setData(entity: medicalGroups.listMedicalTests[indexPath.section].medicalTestLines[indexPath.row - medicalGroups.listMedicalTests.count])
                }
            }
        }else {
            cell.setData(entity: medicalGroups.listMedicalTests[indexPath.section].medicalTestLines[indexPath.row])
        }
        return cell
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
