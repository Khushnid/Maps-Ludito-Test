//
//  ViewController.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon on 03/05/25.
//

import UIKit

final class LuditoCustomTabBarController: UITabBarController, LuditoCustomTabBarDelegate {
    private let customTabBar: LuditoCustomTabBar = {
        let tabView = LuditoCustomTabBar()
        tabView.translatesAutoresizingMaskIntoConstraints = false
        return tabView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    func tabSelected(index: Int) {
        selectedIndex = index
    }
}

private extension LuditoCustomTabBarController {
    func setupTabBar() {
        tabBar.isHidden = true
        view.addSubview(customTabBar)

        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 86)
        ])

        customTabBar.delegate = self
    }

    func setupViewControllers() {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .red

        let vc2 = UIViewController()
        vc2.view.backgroundColor = .white

        let vc3 = UIViewController()
        vc3.view.backgroundColor = .blue

        viewControllers = [vc1, vc2, vc3]
    }
}
