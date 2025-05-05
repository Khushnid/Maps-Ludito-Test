//
//  YandexMapsViewController.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon on 03/05/25.
//

import UIKit
import YandexMapsMobile
import CoreLocation

final class YandexMapsViewController: UIViewController {
    private let rootView = YandexMapsView()
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?
    private var searchManager: YMKSearchManager?
    private var searchSession: YMKSearchSession?
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupSearch()
        requestLocationPermission()
        
        presentSearchSheet()
    }
    
    private func setupViewController() {
        rootView.setupSearchDelegate(delegate: self)
        rootView.setupFloatingButtonDelegate(delegate: self)
    }
    
    private func setupSearch() {
        searchManager = YMKSearchFactory.instance().createSearchManager(with: YMKSearchManagerType.combined)
    }
    
    private func requestLocationPermission() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func performSearch(with query: String) {
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
    
    private func handleSearchResponse(_ response: YMKSearchResponse?, error: Error?) {
        if let error {
            showErrorAlert(message: error.localizedDescription)
            return
        }
        
        guard let response = response,
              let firstResult = response.collection.children.first,
              let geometry = firstResult.obj?.geometry.first?.point else {
            debugPrint("No search results found.")
            return
        }
        
        moveToLocation(latitude: geometry.latitude, longitude: geometry.longitude)
    }
    
    private func updateMapWithUserLocation() {
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
    
    private func moveToLocation(latitude: Double, longitude: Double, zoom: Float = 14.0) {
        let point = YMKPoint(latitude: latitude, longitude: longitude)
        
        rootView.mapView?.mapWindow.map.move(
            with: YMKCameraPosition(target: point, zoom: zoom, azimuth: 0.0, tilt: 0.0),
            animation: YMKAnimation(type: .linear, duration: 1),
            cameraCallback: nil
        )
    }
    
    func presentSearchSheet() {
        let vc = BottomSheetSearchViewController()
        vc.onPlaceSelected = { place in
            print("Selected: \(place)")
            // Move to location on map or show details
        }

        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        present(vc, animated: true)
    }

}

extension YandexMapsViewController: LuditoSearchBarDelegate {
    func searchBarView(text: String) {
        performSearch(with: text)
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
