//
//  PhotoListViewController.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import UIKit

class PhotoListViewController: BaseViewController {
    static func create(with viewModel: PhotoListViewModel) -> PhotoListViewController {
        let photoListViewController = PhotoListViewController()
        photoListViewController.viewModel = viewModel

        return photoListViewController
    }

    private var viewModel: PhotoListViewModel!

    // UI

    lazy var photoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PhotoListTableViewCell.self, forCellReuseIdentifier: PhotoListTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    // View Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.viewDidLoad()
    }

    // Private

    private func setupViews() {

    }

    private func bindOutput() {

    }

    private func updateitems() {

    }
}

extension PhotoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoListTableViewCell.identifier, for: indexPath) as? PhotoListTableViewCell else {
            fatalError("Cannot dequeue reusable cell \(PhotoListTableViewCell.self) with reuseIdentifier: \(PhotoListTableViewCell.identifier)")
        }
        cell.model = viewModel.photos.value[indexPath.row]

        if indexPath.row == viewModel.photos.value.count - 1 {
            viewModel
        }

        return cell
    }
}
