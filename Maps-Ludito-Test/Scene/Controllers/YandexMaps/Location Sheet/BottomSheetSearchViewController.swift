//
//  BottomSheetSearchViewController.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon Keldiboev on 05/05/25.
//

import UIKit
import CoreLocation
import YandexMapsMobile

final class BottomSheetSearchViewController: UIViewController {
    private let searchbar: LuditoSearchBar = {
        let view = LuditoSearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MapsSearchResultCell.self, forCellReuseIdentifier: MapsSearchResultCell.identifier)
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private var results: [YMKGeoObjectCollectionItem]
    private let userLocation: YMKPoint
    var onPlaceSelected: ((YMKGeoObjectCollectionItem) -> Void)
    
    init(
        results: [YMKGeoObjectCollectionItem],
        userLocation: YMKPoint,
        onPlaceSelected: @escaping ((YMKGeoObjectCollectionItem) -> Void)
    ) {
        self.results = results
        self.userLocation = userLocation
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

        let stack = UIStackView(arrangedSubviews: [searchbar, tableView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 18

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func calculateDistance(from userLocation: YMKPoint?, to destination: YMKPoint) -> String {
        guard let userLocation else { return "0 м" }

        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destinationCLLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let distanceInMeters = userCLLocation.distance(from: destinationCLLocation)

        if distanceInMeters >= 1000 {
            let distanceInKilometers = distanceInMeters / 1000
            let formattedDistance = String(format: "%.1f км", distanceInKilometers)
            return formattedDistance
        } else {
            let roundedMeters = Int(distanceInMeters.rounded(.down))
            return "\(roundedMeters) м"
        }
    }
}

extension BottomSheetSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MapsSearchResultCell.identifier, for: indexPath) as? MapsSearchResultCell else {
            return UITableViewCell()
        }
        
        let dataSource = results[indexPath.row]
        
        cell.setupDetails(
            title: dataSource.title,
            subTitle: dataSource.subtitle,
            distance: calculateDistance(from: dataSource.point, to: userLocation)
        )
     
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onPlaceSelected(results[indexPath.row])
        dismiss(animated: true)
    }
}
