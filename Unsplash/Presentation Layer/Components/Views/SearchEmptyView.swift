//
//  SearchEmptyView.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import UIKit

enum SearchMessageType {
    case requiredQuery
    case emptyResult

    var message: String {
        switch self {
        case .requiredQuery: return "Search for keyword photos in the search bar."
        case .emptyResult: return "There is no information about that keyword. Please search again with a different keyword"
        }
    }
}

class SearchEmptyView: BaseView<SearchMessageType> {

    private lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = SearchMessageType.requiredQuery.message
        label.textColor = .lightGray
        label.font = .title1Regular
        label.textAlignment = .center

        return label
    }()

    override func configure() {
        super.configure()

        setupViews()
        addSubviews()
        makeConstraints()
    }

    private func setupViews() {
        backgroundColor = .black
    }

    private func addSubviews() {
        addSubview(informationLabel)
    }

    private func makeConstraints() {
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            informationLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            informationLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            informationLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            informationLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
    }

    override func bind(_ model: SearchMessageType) {
        super.bind(model)

        informationLabel.text = model.message
    }
}

