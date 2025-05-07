//
//  MapLocationInformationSheetController.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon Keldiboev on 06/05/25.
//

import UIKit

final class MapLocationInformationSheetController: UIViewController {
    private let placeTitle: String
    private let subtitle: String
    private let rating: Double
    private let reviewCount: Int
    private let onAddToFavorites: () -> Void
    private let onDismiss: () -> Void
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Bold", size: 20)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Bold", size: 16)
        label.textColor = UIColor(named: "secondary")
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 1
        return label
    }()
    
    private let starsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 3
        return stack
    }()
    
    private let reviewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "secondary")
        label.font = UIFont(name: "Roboto-SemiBold", size: 14)
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить в избранное", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "green_base")
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        button.layer.cornerRadius = 21
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_carbon_close_filled"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    init(
        title: String,
        subtitle: String,
        rating: Double,
        reviewCount: Int,
        onAddToFavorites: @escaping () -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.placeTitle = title
        self.subtitle = subtitle
        self.rating = rating
        self.reviewCount = reviewCount
        self.onAddToFavorites = onAddToFavorites
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 160)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureSheetPresentation()
        configureActions()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        titleLabel.text = placeTitle
        subtitleLabel.text = subtitle
        reviewsLabel.text = "\(reviewCount) оценок"
        
        configureStars()
        
        let starsAndReviewsStack = UIStackView(arrangedSubviews: [starsStackView, reviewsLabel])
        starsAndReviewsStack.alignment = .center
        starsAndReviewsStack.spacing = 8
        
        let contentStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, starsAndReviewsStack, addButton])
        contentStack.alignment = .leading
        contentStack.axis = .vertical
        contentStack.spacing = 2
        
        contentStack.setCustomSpacing(14, after: subtitleLabel)
        contentStack.setCustomSpacing(10, after: starsAndReviewsStack)
        
        view.addSubview(contentStack)
        view.addSubview(closeButton)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -4),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            addButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func configureSheetPresentation() {
        guard let sheet = sheetPresentationController else { return }
        
        let customDetent = UISheetPresentationController.Detent.custom(resolver: { _ in
            return 160
        })
        
        sheet.detents = [customDetent]
        sheet.prefersGrabberVisible = true
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.prefersEdgeAttachedInCompactHeight = true
        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
    }
    
    private func configureActions() {
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    private func configureStars() {
        let fullStars = Int(rating)
        let emptyStars = max(0, 5 - fullStars)
        
        for _ in 0 ..< fullStars {
            starsStackView.addArrangedSubview(makeStarImageView(filled: true))
        }
        
        for _ in 0 ..< emptyStars {
            starsStackView.addArrangedSubview(makeStarImageView(filled: false))
        }
    }
    
    private func makeStarImageView(filled: Bool) -> UIImageView {
        let imageName = filled ? "ic_star_fill" : "ic_star"
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        return imageView
    }
    
    @objc private func addTapped() {
        onAddToFavorites()
        closeTapped()
    }
    
    @objc private func closeTapped() {
        onDismiss()
        dismiss(animated: true)
    }
}
