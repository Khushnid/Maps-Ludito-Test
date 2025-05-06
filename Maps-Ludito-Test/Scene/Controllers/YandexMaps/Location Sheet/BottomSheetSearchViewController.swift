//
//  BottomSheetSearchViewController.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon Keldiboev on 05/05/25.
//

import UIKit
import YandexMapsMobile

final class BottomSheetSearchViewController: UIViewController {
    private let searchbar: LuditoSearchBar = {
        let view = LuditoSearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .singleLine
        return view
    }()
    
    private var results: [YMKGeoObjectCollectionItem]
    var onPlaceSelected: ((YMKGeoObjectCollectionItem) -> Void)
    
    init(
        results: [YMKGeoObjectCollectionItem],
        onPlaceSelected: @escaping ((YMKGeoObjectCollectionItem) -> Void)
    ) {
        self.results = results
        self.onPlaceSelected = onPlaceSelected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
//        searchView.onTextChanged = { [weak self] text in
//            self?.performSearch(query: text)
//        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self

        let stack = UIStackView(arrangedSubviews: [searchbar, tableView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func performSearch(query: String) {
        // Mock results
//        results = Array(repeating: "Le Grande Plaza Hotel", count: 4)
        tableView.reloadData()
    }
}

extension BottomSheetSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { results.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = results[indexPath.row].description
        config.secondaryText = "Ташкент, ул. Узбекистон Овози, 2"
        config.image = UIImage(systemName: "mappin.circle")
        config.secondaryTextProperties.color = .gray
        cell.contentConfiguration = config
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onPlaceSelected(results[indexPath.row])
        dismiss(animated: true)
    }
}
