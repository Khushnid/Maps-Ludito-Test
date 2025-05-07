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
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .green
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
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
