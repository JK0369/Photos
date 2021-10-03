//
//  UICollectionViewLayout.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation
import UIKit

extension UICollectionViewLayout {

    static let leftThreeRightThree = UICollectionViewCompositionalLayout { section, environment in

        let margin = 2.0

        // 좌측 그룹

        /// first item
        let leadingFirstItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .fractionalHeight(0.35))
        let leadingFirstItem = NSCollectionLayoutItem(layoutSize: leadingFirstItemSize)
        leadingFirstItem.contentInsets = NSDirectionalEdgeInsets(top: margin, leading: margin, bottom: margin, trailing: margin)

        /// second item
        let leadingSecondItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalHeight(0.2))
        let leadingSecondItem = NSCollectionLayoutItem(layoutSize: leadingSecondItemSize)
        leadingSecondItem.contentInsets = NSDirectionalEdgeInsets(top: margin, leading: margin, bottom: margin, trailing: margin)

        /// third item
        let leadingThirdItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalHeight(0.45))
        let leadingThirdItem = NSCollectionLayoutItem(layoutSize: leadingThirdItemSize)
        leadingThirdItem.contentInsets = NSDirectionalEdgeInsets(top: margin, leading: margin, bottom: margin, trailing: margin)

        /// leading group
        let leadingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                      heightDimension: .fractionalHeight(1.0))
        let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: leadingGroupSize,
                                                            subitems: [leadingFirstItem, leadingSecondItem, leadingThirdItem])

        // 우측 그룹
        /// first item
        let trailingFirstItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalHeight(0.5))
        let trailingFirstItem = NSCollectionLayoutItem(layoutSize: trailingFirstItemSize)
        trailingFirstItem.contentInsets = NSDirectionalEdgeInsets(top: margin, leading: margin, bottom: margin, trailing: margin)

        /// second item
        let trailingSecondItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalHeight(0.2))
        let trailingSecondItem = NSCollectionLayoutItem(layoutSize: trailingSecondItemSize)
        trailingSecondItem.contentInsets = NSDirectionalEdgeInsets(top: margin, leading: margin, bottom: margin, trailing: margin)

        /// third item
        let trailingThirdItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalHeight(0.3))
        let trailingThirdItem = NSCollectionLayoutItem(layoutSize: trailingThirdItemSize)
        trailingThirdItem.contentInsets = NSDirectionalEdgeInsets(top: margin, leading: margin, bottom: margin, trailing: margin)

        /// trailing group
        let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                       heightDimension: .fractionalHeight(1.0))
        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize,
                                                             subitems: [trailingFirstItem, trailingSecondItem, trailingThirdItem])

        /// margin
        [trailingFirstItem, trailingSecondItem, trailingThirdItem].forEach {
            $0.contentInsets = NSDirectionalEdgeInsets(top: margin, leading: margin, bottom: margin, trailing: margin)
        }

        // 좌측 그룹과 우측 그룹을 포함하는 그룹
        let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(1.0))
        let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize,
                                                                subitems: [leadingGroup, trailingGroup])

        let section = NSCollectionLayoutSection(group: containerGroup)
        return section
    }
}
