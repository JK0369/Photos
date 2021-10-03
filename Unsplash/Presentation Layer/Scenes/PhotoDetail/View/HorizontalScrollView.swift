//
//  HorizontalScrollView.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import UIKit

class HorizontalScrollView: BaseScrollView<HorizontalScrollModel> {

    private let horizontalWidth: CGFloat
    private let horizontalHeight: CGFloat
    private var imageViews = [UIImageView]()

    init(horizontalWidth: CGFloat, horizontalHeight: CGFloat) {
        self.horizontalWidth = horizontalWidth
        self.horizontalHeight = horizontalHeight
        super.init(frame: .zero)

        configure()
    }

    override func configure() {
        super.configure()

        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
    }

    override func bind(_ model: HorizontalScrollModel) {
        super.bind(model)

        setImages()
        updateScrollViewContentWidth()
    }

    private func setImages() {
        guard let horizontalScrollModel = model else { return }
        horizontalScrollModel.images
            .enumerated()
            .forEach {
                let imageView = UIImageView(image: $0.element)
                imageView.contentMode = .scaleAspectFit
                let xOffset = horizontalWidth * CGFloat($0.offset)

                imageView.frame = CGRect(x: xOffset, y: 0, width: horizontalWidth, height: horizontalHeight)
                self.imageViews.append(imageView)

                DispatchQueue.main.async { [weak self] in
                    self?.addSubview(imageView)
                }
            }

        DispatchQueue.main.async { [weak self] in
            guard let targetImageview = self?.imageViews[horizontalScrollModel.selectedIndex] else { return }
            self?.scrollToView(view: targetImageview)
        }
    }

    private func updateScrollViewContentWidth() {
        contentSize.width = horizontalWidth * CGFloat(model?.images.count ?? 1)
    }
}
