//
//  LuditoSearchBar.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon Keldiboev on 05/05/25.
//

import UIKit

protocol LuditoSearchBarDelegate: AnyObject {
    func searchBarView(text: String)
}

class LuditoSearchBar: UIView, UITextFieldDelegate {
    weak var delegate: LuditoSearchBarDelegate?

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ic_search")
        imageView.tintColor = .black
        return imageView
    }()

    private let textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont(name: "Roboto-Bold", size: 16)!
            ]
        )
        field.font = UIFont(name: "Roboto-Bold", size: 16)
        field.borderStyle = .none
        field.returnKeyType = .search
        field.textColor = .black
        return field
    }()
    
    private var debounceTimer: Timer?

    init() {
        super.init(frame: .zero)
       
        setupView()
        setupTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LuditoSearchBar {
    func setupView() {
        backgroundColor = UIColor(named: "background_search_field")
        layer.borderColor = UIColor(named: "border_search")?.cgColor
        layer.cornerRadius = 16
        layer.borderWidth = 4
        clipsToBounds = true

        addSubview(iconImageView)
        addSubview(textField)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 48),

            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),

            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ])
    }
    
    func setupTargets() {
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textDidChange(_ sender: UITextField) {
        debounceTimer?.invalidate()
        
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            guard let self, let text = sender.text else { return }
            delegate?.searchBarView(text: text)
        }
    }
}
