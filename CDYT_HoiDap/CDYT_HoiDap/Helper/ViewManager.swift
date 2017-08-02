//
//  ViewManager.swift
//  CDYT_HoiDap
//
//  Created by Quang Anh on 8/2/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import Foundation

class ViewManager {
    static let screentWidth = UIScreen.main.bounds.size.width
    static let screentHeight = UIScreen.main.bounds.size.height
    static let heightBar: CGFloat = 22
    static let heightTopView: CGFloat = 66
    static let marginTopAndBot: CGFloat = 16
}

struct CheckShowName {
    var isShow: Bool
    init(isShow: Bool) {
        self.isShow = isShow
    }
}
