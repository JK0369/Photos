//
//  UIImage.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/04.
//

import UIKit

extension UIImage {
    static func placeholderImage(with size: CGSize = CGSize(width: 10.0, height: 10.0)) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
