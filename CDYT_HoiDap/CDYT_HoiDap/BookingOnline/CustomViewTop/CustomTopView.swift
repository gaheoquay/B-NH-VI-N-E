//
//  CustomTopView.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 7/24/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTopView: UIView {

    @IBOutlet weak var btnPopView: UIButton!
    @IBOutlet weak var lbTitTopView: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    var popView : (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        
        // Auto-layout stuff.
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        // Show the view.
        addSubview(view)
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    @IBAction func btnPopView(_ sender: Any) {
        self.popView?()
    }
    
    @IBAction func btnDone(_ sender: Any) {
    }
    
}
