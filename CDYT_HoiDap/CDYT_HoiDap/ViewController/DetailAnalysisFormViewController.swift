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
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.gray

        let labelTitle = UILabel.init()
        
        labelTitle.font = UIFont.systemFont(ofSize: 14)
        labelTitle.textColor = UIColor.red
        labelTitle.text = "Sinh hoá"
        labelTitle.frame = CGRect.init(x: 8, y: 15, width: labelTitle.frame.size.width, height: labelTitle.frame.size.height)
        labelTitle.sizeToFit()
        
        viewHeader.addSubview(labelTitle)
        return viewHeader
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FormAnalysisCell") as! FormAnalysisCell
        return cell
    }
    
    @IBAction func btnBack(_ sender: Any) {
    }
    
}
