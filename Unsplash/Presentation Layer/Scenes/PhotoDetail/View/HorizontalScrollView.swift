//
//  HorizontalScrollView.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import UIKit

class HorizontalScrollView: BaseScrollView<[Photo]> {

    let horizontalWidth: CGFloat

    init(horizontalWidth: CGFloat) {
        self.horizontalWidth = horizontalWidth
        super.init(frame: .zero)

        configure()
    }

    override func configure() {
        super.configure()

        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
    }

    override func bind(_ model: [Photo]) {
        super.bind(model)

        setImages()
        updateScrollViewContentWidth()
    }

    private func setImages() {
        guard let photos = model else { return }
        photos
            .enumerated()
            .forEach {
                let imageView = UIImageView(image: $0.element.image)
                imageView.contentMode = .scaleToFill
                let xOffset = horizontalWidth * CGFloat($0.offset)
                imageView.frame.origin = CGPoint(x: xOffset, y: 0)
                imageView.frame.size = $0.element.image.size
                addSubview(imageView)
            }
    }

    private func updateScrollViewContentWidth() {
        contentSize.width = horizontalWidth * CGFloat(model?.count ?? 1)
    }
}
