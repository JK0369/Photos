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
        case .requiredQuery: return "검색창에서 키워드로\n사진을 검색해주세요."
        case .emptyResult: return "해당 키워드에 대한 정보가 없습니다.\n다른 키워드로 다시 검색해주세요"
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

