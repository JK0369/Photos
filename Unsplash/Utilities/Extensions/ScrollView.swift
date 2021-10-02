//
//  ScrollView.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation
import UIKit

enum ScrollDirectionType {
    case horizontal
    case vertical
}

extension UIScrollView {
    func scrollToView(view: UIView, scrollDirection: ScrollDirectionType) {
        switch scrollDirection {
        case .horizontal:
            if let origin = view.superview {
                let childStartPoint = origin.convert(view.frame.origin, to: self)
                let rightOffset = scrollRightOffset
                if (childStartPoint.x > rightOffset.x) {
                    setContentOffset(rightOffset, animated: false)
                } else {
                    setContentOffset(CGPoint(x: childStartPoint.x, y: 0.0), animated: false)
                }
            }
        case .vertical:
            if let origin = view.superview {
                let childStartPoint = origin.convert(view.frame.origin, to: self)
                let bottomOffset = scrollBottomOffset
                if (childStartPoint.y > bottomOffset.y) {
                    setContentOffset(bottomOffset, animated: false)
                } else {
                    setContentOffset(CGPoint(x: 0.0, y: childStartPoint.x), animated: false)
                }
            }
        }
    }

    private var scrollRightOffset: CGPoint {
        return CGPoint(x: contentSize.width - bounds.size.width, y: 0.0)
    }

    private var scrollBottomOffset: CGPoint {
        return CGPoint(x: 0.0, y: contentSize.height - bounds.size.height)
    }
}
