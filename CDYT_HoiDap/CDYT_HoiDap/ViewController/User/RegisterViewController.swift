//
//  RegisterViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nicknameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var repassTxt: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var errLbl: UILabel!

    let pickerImageController = DKImagePickerController()
    var imageAssets = [DKAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()

        initDkImagePicker()
        setupUI()
    }

    func setupUI(){
        avatarImg.layer.cornerRadius = 8
        avatarImg.clipsToBounds = true
        
        registerBtn.layer.cornerRadius = 5
        registerBtn.clipsToBounds = true
    }
    
    @IBAction func chooseAvatarAction(_ sender: Any) {
        self.present(pickerImageController, animated: true, completion: nil)
    }
    
    func initDkImagePicker(){
        pickerImageController.assetType = DKImagePickerControllerAssetType.allPhotos
        pickerImageController.maxSelectableCount = 1
        pickerImageController.didSelectAssets = { [unowned self] ( assets: [DKAsset]) in
            self.imageAssets = assets
            if assets.count > 0 {
                let asset = assets[0]
                asset.fetchOriginalImage(true, completeBlock: {(image, info) -> Void in
                    self.avatarImg.image = image!
                })
                
            }else{
                self.avatarImg.image = UIImage.init(named: "AvaDefaut")
            }
        }
        
    }
    
    @IBAction func registerBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
    }
    
    func validateData() -> String{
        let nickString = nicknameTxt.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let emailString = emailTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let passString = passTxt.text
        let rePassString = repassTxt.text
        
        var errMess = ""
        if nickString == "" {
            errMess = "Vui lòng điền Tên đăng nhập"
        }else if emailString == "" {
            errMess = "Vui lòng điền email."
        }else if !isValidEmail(email: emailString!){
            errMess = "Định dạng email không đúng"
        }else if passString == "" || rePassString == "" {
            errMess = "Vui lòng nhập đầy đủ thông tin mật khẩu."
        }
        
        return errMess
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
