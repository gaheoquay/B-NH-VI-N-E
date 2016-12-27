//
//  KeyWordTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class KeyWordTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegateLeftAlignedLayout {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    clvKeyword.dataSource = self
    clvKeyword.delegate = self
    clvKeyword.register(UINib.init(nibName: "KeywordCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "KeywordCollectionViewCell")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
//  MARK:UICollectionViewDataSource
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 50
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordCollectionViewCell", for: indexPath) as! KeywordCollectionViewCell
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize.init(width: 100, height: 24)
  }
// MARK: UICollectionViewDelegateLeftAlignedLayout

  //MARK: Outlet
  @IBOutlet weak var clvKeyword: UICollectionView!
}
