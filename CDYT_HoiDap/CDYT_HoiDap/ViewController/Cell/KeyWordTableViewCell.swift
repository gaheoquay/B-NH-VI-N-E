//
//  KeyWordTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

protocol KeyWordTableViewCellDelegate {
  func gotoListQuestionByTag(hotTag : TagEntity)
}

class KeyWordTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegateLeftAlignedLayout,UICollectionViewDelegate {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Initialization code
    clvKeyword.dataSource = self
    clvKeyword.delegate = self
    clvKeyword.register(UINib.init(nibName: "KeywordCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "KeywordCollectionViewCell")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }

//  MARK:UICollectionViewDataSource
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return listTag.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordCollectionViewCell", for: indexPath) as! KeywordCollectionViewCell
    cell.setData(tagName: listTag[indexPath.row].tag.tagName)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.gotoListQuestionByTag(hotTag: listTag[indexPath.row].tag)
  }
  
// MARK: UICollectionViewDelegateLeftAlignedLayout
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if listTag.count > 0 {
    let entity = listTag[indexPath.row]
      let tagName = "  " + entity.tag.tagName + "  "
      let width = tagName.widthWithConstrainedHeight(height: 24, font: UIFont.systemFont(ofSize: 14))
      return CGSize.init(width: width, height: 24)
    }
    return CGSize.init(width: 0, height: 0)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
  //MARK: Outlet
  @IBOutlet weak var clvKeyword: UICollectionView!
  var listTag = [HotTagEntity]()
  var delegate : KeyWordTableViewCellDelegate?
}
