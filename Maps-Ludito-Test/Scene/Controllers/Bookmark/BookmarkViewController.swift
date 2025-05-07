//
//  BookmarkViewController.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon on 03/05/25.
//

import UIKit

final class BookmarkViewController: UIViewController {
    private let tabTitleView: LuditoTabBarTitleView = {
        let view = LuditoTabBarTitleView(text: "Мои адреса")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(BookmarkTableViewCell.self, forCellReuseIdentifier: BookmarkTableViewCell.identifier)
        table.backgroundColor = UIColor(named: "background_main")
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private var dataSource = [MyPoint]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource = UserDefaults.standard.getPoints(forKey: Constants.USER_FAVORITE_KEY)
    }
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkTableViewCell.identifier, for: indexPath) as? BookmarkTableViewCell else {
            return UITableViewCell()
        }
        
        let dataSource = dataSource[indexPath.row]
        
        cell.setupDetails(
            title: dataSource.key,
            subTitle: dataSource.value
        )
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSource = dataSource[indexPath.row]
     
        showAlert(
            message: "Широта: \(dataSource.latitude)\n Долгота: \(dataSource.longitude)",
            title: "Mестоположении:"
        )
    }
}

private extension BookmarkViewController {
    func setupViewController() {
        view.backgroundColor = UIColor(named: "background_main")
        
        view.addSubview(tabTitleView)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tabTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabTitleView.topAnchor.constraint(equalTo: view.topAnchor),
            tabTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabTitleView.heightAnchor.constraint(equalToConstant: 106),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: tabTitleView.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
