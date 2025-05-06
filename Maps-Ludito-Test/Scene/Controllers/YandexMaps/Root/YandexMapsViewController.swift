//
//  YandexMapsViewController.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon on 03/05/25.
//

import UIKit
import YandexMapsMobile
import CoreLocation

final class YandexMapsViewController: UIViewController, YMKMapCameraListener {
    private let rootView = YandexMapsView()
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?
    private var searchManager: YMKSearchManager?
    private var searchSession: YMKSearchSession?
    
    private lazy var homeSearchDelegateHandler: LuditoSearchBarDelegateHandler = {
        return LuditoSearchBarDelegateHandler { [weak self] text in
            self?.performSearch(with: text)
        }
    }()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupSearch()
        requestLocationPermission()
    }
    
    func onCameraPositionChanged(
        with map: YMKMap,
        cameraPosition: YMKCameraPosition,
        cameraUpdateReason: YMKCameraUpdateReason,
        finished: Bool
    ) {
        if finished {
            UIView.animate(withDuration: 0.2) {
                self.rootView.pinImageView.transform = .identity
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.rootView.pinImageView.transform = CGAffineTransform(translationX: 0, y: -20)
            }
        }
    }
}

private extension YandexMapsViewController {
    func setupViewController() {
        rootView.setupSearchDelegate(delegate: homeSearchDelegateHandler)
        rootView.setupFloatingButtonDelegate(delegate: self)
        rootView.mapView?.mapWindow.map.addCameraListener(with: self)
    }
    
    func setupSearch() {
        searchManager = YMKSearchFactory.instance().createSearchManager(with: YMKSearchManagerType.combined)
    }
    
    func requestLocationPermission() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func performSearch(with query: String) {
        guard let userLocation else { return }
        
        let yandexPoint = YMKPoint(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude
        )
        
        searchSession = searchManager?.submit(
            withText: query,
            geometry: YMKGeometry(point: yandexPoint),
            searchOptions: YMKSearchOptions(),
            responseHandler: { [weak self] response, error in
                self?.handleSearchResponse(response, error: error)
            }
        )
    }
    
    func handleSearchResponse(_ response: YMKSearchResponse?, error: Error?) {
        if let error {
            showErrorAlert(message: error.localizedDescription)
            return
        }
        
        guard let response else {
            debugPrint("No search results found.")
            return
        }
        
        presentSearchSheet(results: response.collection.children)
    }
    
    func updateMapWithUserLocation() {
        guard let userLocation else { return }
        
        let target = YMKPoint(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude
        )
        
        rootView.mapView?.mapWindow.map.move(
            with: YMKCameraPosition(target: target, zoom: 12.0, azimuth: 0.0, tilt: 0.0),
            animation: YMKAnimation(type: .linear, duration: 1),
            cameraCallback: nil
        )
    }
    
    func moveToLocation(latitude: Double, longitude: Double, zoom: Float = 14.0) {
        let point = YMKPoint(latitude: latitude, longitude: longitude)
        
        rootView.mapView?.mapWindow.map.move(
            with: YMKCameraPosition(target: point, zoom: zoom, azimuth: 0.0, tilt: 0.0),
            animation: YMKAnimation(type: .linear, duration: 1),
            cameraCallback: nil
        )
    }
    
    func presentSearchSheet(results: [YMKGeoObjectCollectionItem]) {
        guard let userLocation else { return }
        
        let userPoint = YMKPoint(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude
        )
        
        let vc = BottomSheetSearchViewController(
            results: results,
            searchResult: rootView.getSearchResult(),
            userLocation: userPoint
        ) { [weak self] place in
            guard let self, let geometry = place.obj?.geometry.first?.point else { return }
            
            moveToLocation(latitude: geometry.latitude, longitude: geometry.longitude)
            dismiss(animated: true)
        }

        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        present(vc, animated: true)
    }
}

extension YandexMapsViewController: LuditoFloatingButtonDelegate {
    func floatingButtonClicked() {
        guard let userLocation else {
            showErrorAlert(message: "Местоположение пользователя недоступно.")
            return
        }

        moveToLocation(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude,
            zoom: 14.0
        )
    }
}

extension YandexMapsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        userLocation = location
        updateMapWithUserLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showErrorAlert(message: "Не удалось определить местоположение. Пожалуйста, попробуйте позже")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        locationManager.startUpdatingLocation()
    }
}
