//
//  QuestionTagTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/27/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

protocol QuestionTagTableViewCellDelegate {
  func checkLogin()
}

class QuestionTagTableViewCell: UITableViewCell {

    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var borderView: UIView!
  var delegate : QuestionTagTableViewCellDelegate?
    var hotTag = HotTagEntity()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.cornerRadius = 5
        borderView.clipsToBounds = true
    }

    func setData() {
        tagName.text = hotTag.tag.tagName
        if hotTag.isFollowed {
            followBtn.setTitle("Bỏ theo dõi", for: UIControlState.normal)
            followBtn.setTitleColor(UIColor().hexStringToUIColor(hex: "9e9e9e"), for: UIControlState.normal)
        }else{
            followBtn.setTitle("Theo dõi", for: UIControlState.normal)
            followBtn.setTitleColor(UIColor().hexStringToUIColor(hex: "7ed321"), for: UIControlState.normal)

        }
    }
    
    @IBAction func followBtnAction(_ sender: Any) {
      if Until.getCurrentId() != "" {
        followTag()
      }else{
        delegate?.checkLogin()
      }
    }
    
    func followTag(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let followParam : [String : Any] = [
                "RequestedUserId": Until.getCurrentId(),
                "Tag": hotTag.tag.id
            ]
            
            
            Until.showLoading()
            Alamofire.request(FOLLOW_TAG, method: .post, parameters: followParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! NSDictionary
                            let isFollowed = jsonData["IsFollowed"] as! Bool
                            
                            self.hotTag.isFollowed = isFollowed
                            
                            self.setData()
                            
                        }
                    }else{
                        //                    UIAlertController().showAlertWith(title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    //                UIAlertController().showAlertWith(title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                Until.hideLoading()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
