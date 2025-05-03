//
//  CustomTabBarDelegate.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon on 03/05/25.
//


import UIKit

protocol LuditoCustomTabBarDelegate: AnyObject {
    func tabSelected(index: Int)
}

final class LuditoCustomTabBar: UIView {
    weak var delegate: LuditoCustomTabBarDelegate?

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        return stack
    }()
    
    private var buttons: [UIButton] = []
    private let icons = ["ic_bookmark", "ic_location_filled", "ic_profile_fill"]

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupButtons()
        selectTab(index: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LuditoCustomTabBar {
    func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 5
        
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupButtons() {
        for (index, icon) in icons.enumerated() {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: icon), for: .normal)
            button.tintColor = .gray
            button.tag = index
            
            button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            button.imageView?.contentMode = .scaleAspectFit

            let container = UIView()
            container.addSubview(button)
          
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                button.topAnchor.constraint(equalTo: container.topAnchor),
                button.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
            
            if let imageView = button.imageView {
                imageView.translatesAutoresizingMaskIntoConstraints = false
              
                NSLayoutConstraint.activate([
                    imageView.heightAnchor.constraint(equalToConstant: 32),
                    imageView.widthAnchor.constraint(equalToConstant: 32),
                    imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                    imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: -8)
                ])
            }

            stackView.addArrangedSubview(container)
            buttons.append(button)
        }
    }

    @objc func tabTapped(_ sender: UIButton) {
        selectTab(index: sender.tag)
        delegate?.tabSelected(index: sender.tag)
    }

    func selectTab(index: Int) {
        for (buttonIndex, button) in buttons.enumerated() {
            button.tintColor = (buttonIndex == index) ? .black : .lightGray
        }
    }
}
