//
//  MapsSearchResultCell.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon Keldiboev on 06/05/25.
//

import UIKit

final class MapsSearchResultCell: UITableViewCell {
    static let identifier = "MapsSearchResultCell"
    
    private let topLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "separator")
        return view
    }()
    
    private let locationImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ic_location_filled")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Roboto-Bold", size: 16)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Roboto-Bold", size: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Roboto-Bold", size: 16)
        label.textAlignment = .right
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellContent()
    }
    
    func setupDetails(title: String, subTitle: String, distance: String) {
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
        self.distanceLabel.text = distance
        setupCellContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MapsSearchResultCell{
    func setupCellContent() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(topLineView)
        contentView.addSubview(locationImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(distanceLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topLineView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 2),
            
            locationImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            locationImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationImageView.widthAnchor.constraint(equalToConstant: 32),
            locationImageView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: locationImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: distanceLabel.leadingAnchor, constant: -8),
            
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            subTitleLabel.trailingAnchor.constraint(equalTo: distanceLabel.leadingAnchor, constant: -8),
            
            distanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}
