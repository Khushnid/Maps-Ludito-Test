//
//  AddPlaceCustomAlert.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon Keldiboev on 07/05/25.
//

import UIKit

final class AddPlaceCustomAlert: UIViewController {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = alertTitle
        label.font = UIFont(name: "Roboto-Bold", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.text = initialText
        textField.font = UIFont(name: "Roboto-Bold", size: 16)
        textField.isUserInteractionEnabled = false
        textField.borderStyle = .none
        return textField
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_symbols_edit"), for: .normal)
        button.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отмена", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 20)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подтвердить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 20)
        button.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        return button
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let alertTitle: String
    private let initialText: String
    private let completion: (String) -> Void
    
    init(title: String, text: String, completion: @escaping (String) -> Void) {
        self.alertTitle = title
        self.initialText = text
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8)
        ])
        
        let addressStack = UIStackView(arrangedSubviews: [addressTextField, editButton])
        addressStack.axis = .horizontal
        addressStack.spacing = 8
        addressStack.alignment = .center
        
        NSLayoutConstraint.activate([
            editButton.widthAnchor.constraint(equalToConstant: 24),
            editButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let buttonsStack = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 20
        buttonsStack.distribution = .fillEqually
        
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, addressStack, separatorLine, buttonsStack])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc private func handleEdit() {
        addressTextField.isUserInteractionEnabled = true
        addressTextField.becomeFirstResponder()
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleConfirm() {
        let text = addressTextField.text ?? ""
        dismiss(animated: true) { [weak self] in
            self?.completion(text)
        }
    }
}
