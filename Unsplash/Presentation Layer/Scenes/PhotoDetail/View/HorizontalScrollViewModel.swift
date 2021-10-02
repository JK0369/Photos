//
//  HorizontalScrollViewModel.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation
import UIKit

struct HorizontalScrollViewModel {
    var images: [UIImage]
    var selectedIndex: Int

    init(images: [UIImage], selectedIndex: Int) {
        self.images = images
        self.selectedIndex = selectedIndex
    }
}
