//
//  YMKGeoObjectCollectionItem+Extensions.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon Keldiboev on 06/05/25.
//

import YandexMapsMobile

extension YMKGeoObjectCollectionItem {
    var title: String {
        guard let title = obj?.name else {
            return "Unkown Place"
        }
        
        return title
    }

    var subtitle: String {
        guard let subtitle = obj?.descriptionText else {
            return "Unkown Place"
        }
        
        return subtitle
    }

    var point: YMKPoint? {
        obj?.geometry.first?.point
    }
}
