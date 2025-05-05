//
//  LuditoFloatingButton.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon Keldiboev on 05/05/25.
//

import UIKit

protocol LuditoFloatingButtonDelegate: AnyObject {
    func floatingButtonClicked()
}

final class LuditoFloatingButton: UIView {
    weak var delegate: LuditoFloatingButtonDelegate?
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.05
        view.layer.cornerRadius = 32
        view.layer.shadowRadius = 8
        view.backgroundColor = .white
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ic_location")
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LuditoFloatingButton {
    func setupView() {
        addSubview(container)
        container.addSubview(imageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
        container.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.widthAnchor.constraint(equalToConstant: 64),
            container.heightAnchor.constraint(equalToConstant: 64),
            
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    @objc func iconTapped() {
        delegate?.floatingButtonClicked()
    }
}
