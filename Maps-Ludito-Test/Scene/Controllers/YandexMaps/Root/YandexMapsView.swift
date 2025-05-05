//
//  YandexMapsView.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon Keldiboev on 05/05/25.
//

import UIKit
import YandexMapsMobile

final class YandexMapsView: UIView {
    lazy var mapView: YMKMapView? = {
        guard let view = YMKMapView(frame: bounds) else { return nil }
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    private let searchbar: LuditoSearchBar = {
        let view = LuditoSearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let floatingButton: LuditoFloatingButton = {
        let view = LuditoFloatingButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
}

private extension YandexMapsView {
    func setupMapViewIfPossible() {
        guard let mapView else { return }
        
        addSubview(mapView)
        mapView.mapWindow.map.move(with: localCameraPosition)
    }
    
    func setupView() {
        addSubview(searchbar)
        addSubview(floatingButton)
        
        NSLayoutConstraint.activate([
            searchbar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchbar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchbar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            floatingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            floatingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -64),
        ])
    }
}
