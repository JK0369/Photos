//
//  BaseTableViewCell.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import UIKit

class BaseTableViewCell<Model>: UITableViewCell {

    var model: Model? {
        didSet {
            if let model = model {
                bind(model)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        selectionStyle = .none
    }

    func bind(_ model: Model) {}
}
