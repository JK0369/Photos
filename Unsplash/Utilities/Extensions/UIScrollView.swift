//
//  UIScrollView.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToView(view: UIView) {
        if let origin = view.superview {
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            let rightOffset = scrollRightOffset
            if (childStartPoint.x > rightOffset.x) {
                setContentOffset(rightOffset, animated: false)
            } else {
                let barYOffset = 44.0
                setContentOffset(CGPoint(x: childStartPoint.x, y: -barYOffset * 2), animated: false)
            }
        }
    }

    private var scrollRightOffset: CGPoint {
        return CGPoint(x: contentSize.width - bounds.size.width, y: 0.0)
    }
}
