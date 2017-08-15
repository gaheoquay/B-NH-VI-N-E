//
//  DetailAnalysisFormViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DetailAnalysisFormViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CodeFormAnalysisCellDelegate {

    @IBOutlet weak var lbFormCode: UILabel!
    @IBOutlet weak var imgBarCode: UIImageView!
    @IBOutlet weak var tbListResult: UITableView!
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
        tbListResult.register(UINib.init(nibName: "CodeFormAnalysisCell", bundle: nil), forCellReuseIdentifier: "CodeFormAnalysisCell")
        tbListResult.estimatedRowHeight = 999
        tbListResult.rowHeight = UITableViewAutomaticDimension
        let image = Until.generateBarcode(from: "\(medicalGroups.medicalTestGroup.hisServiceMedicTestGroupID)")
        imgBarCode.image = image
        lbFormCode.text = medicalGroups.medicalTestGroup.hisServiceMedicTestGroupID
        lbTitle.text = "Kết quả xét nghiệm"
      
        for item in medicalGroups.listMedicalTests {
            if item.medicalTestLines.count > 0 {
                for a in item.medicalTestLines {
                    let heightlb =  a.nameLine.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width / 4 - 16, font: .systemFont(ofSize: 11)) + 16
                    b = b + heightlb
                }
                heightTb = b
            }else {
                let a = item.medicalTest.serviceName.heightWithConstrainedWidth(width: UIScreen.main.bounds.size.width / 4 - 16, font: .systemFont(ofSize: 11)) + 16
                heightTb = heightTb + a
            }
        }
      
        heightTbResult.constant = heightTb + CGFloat(81 * medicalGroups.listMedicalTests.count) + 11
        view.layoutIfNeeded()
      
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicalGroups.listMedicalTests.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodeFormAnalysisCell") as! CodeFormAnalysisCell
        cell.delegate = self
        cell.indexPatch = indexPath
        if medicalGroups.listMedicalTests[indexPath.row].medicalTestLines.count > 0 {
            cell.isLine = true
        }else {
            cell.isLine = false
        }
        cell.mediCal = self.medicalGroups.listMedicalTests[indexPath.row]
        cell.setData()
        return cell
    }
    func reloadDataCell(indexPatch: IndexPath) {
        tbListResult.reloadRows(at: [indexPatch], with: .automatic)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
