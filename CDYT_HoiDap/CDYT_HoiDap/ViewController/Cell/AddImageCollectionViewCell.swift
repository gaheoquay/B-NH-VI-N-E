//
//  AddImageCollectionViewCell.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit
protocol AddImageCollectionViewCellDelegate {
    func deleteImageAction(indexPath : IndexPath)
}

class AddImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var indexPath = IndexPath()
    @IBOutlet weak var deleteBtn: UIButton!
    var delegate : AddImageCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func removeImage(_ sender: Any) {
        delegate?.deleteImageAction(indexPath: indexPath)
    }
}
