//
//  AddQuestionViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class AddQuestionViewController: UIViewController {

    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var contentTxt: UITextView!
    @IBOutlet weak var tagTxt: UITextView!
    @IBOutlet weak var imgClv: UICollectionView!
    @IBOutlet weak var imgClvheight: NSLayoutConstraint!
    
    @IBOutlet weak var titleTxtBorderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }

    func configUI(){
        titleTxtBorderView.layer.cornerRadius = 2
        titleTxtBorderView.layer.borderWidth = 1
        titleTxtBorderView.layer.borderColor = UIColor().hexStringToUIColor(hex: "D8D8D8").cgColor
        
        contentTxt.layer.cornerRadius = 2
        contentTxt.layer.borderWidth = 1
        contentTxt.layer.borderColor = UIColor().hexStringToUIColor(hex: "D8D8D8").cgColor
        
        tagTxt.layer.cornerRadius = 2
        tagTxt.layer.borderWidth = 1
        tagTxt.layer.borderColor = UIColor().hexStringToUIColor(hex: "D8D8D8").cgColor
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backTapAction(_ sender: Any) {
    }

    @IBAction func postTapAction(_ sender: Any) {
    }
    
    @IBAction func addImageTapAction(_ sender: Any) {
    
    }

}
