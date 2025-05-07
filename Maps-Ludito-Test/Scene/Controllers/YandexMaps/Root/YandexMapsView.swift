//
//  YandexMapsView.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon Keldiboev on 05/05/25.
//

import UIKit
import YandexMapsMobile

final class YandexMapsView: UIView {
    private(set) var floatingButtonBottomConstraint: NSLayoutConstraint!
    
    lazy var mapView: YMKMapView? = {
        guard let view = YMKMapView(frame: bounds) else { return nil }
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    let searchbar: LuditoSearchBar = {
        let view = LuditoSearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let floatingButton: LuditoFloatingButton = {
        let view = LuditoFloatingButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let pinImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ic_map_pin")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let localCameraPosition = YMKCameraPosition(
        target: YMKPoint(latitude: 41.2995, longitude: 69.2401),
        zoom: 12,
        azimuth: 0,
        tilt: 0
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMapViewIfPossible()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupSearchDelegate(delegate: LuditoSearchBarDelegate) {
        searchbar.delegate = delegate
    }
    
    func setupFloatingButtonDelegate(delegate: LuditoFloatingButtonDelegate) {
        floatingButton.delegate = delegate
    }
    
    func getSearchResult() -> String {
        return searchbar.getSearchResult()
    }
    
    func updateFloatingButtonPosition(offsetFromBottom: CGFloat, animated: Bool) {
        floatingButtonBottomConstraint.constant = -offsetFromBottom
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }
}

private extension YandexMapsView {
    func setupMapViewIfPossible() {
        guard let mapView else { return }
        
        addSubview(mapView)
        mapView.addSubview(pinImageView)
        mapView.mapWindow.map.move(with: localCameraPosition)
        
        NSLayoutConstraint.activate([
            pinImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            pinImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -36),
            pinImageView.widthAnchor.constraint(equalToConstant: 72),
            pinImageView.heightAnchor.constraint(equalToConstant: 72),
        ])
    }
    
    func setupView() {
        addSubview(searchbar)
        addSubview(floatingButton)
        
        floatingButtonBottomConstraint = floatingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        
        NSLayoutConstraint.activate([
            searchbar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchbar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchbar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            floatingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            floatingButtonBottomConstraint
        ])
    }
}
