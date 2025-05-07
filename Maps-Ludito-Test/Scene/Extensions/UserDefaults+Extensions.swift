//
//  UserDefaults+Extensions.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon Keldiboev on 07/05/25.
//

import Foundation

extension UserDefaults {
    func savePoints(_ points: [MyPoint], forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(points) {
            set(encoded, forKey: key)
        }
    }
    
    func getPoints(forKey key: String) -> [MyPoint] {
        if let data = data(forKey: key),
           let decoded = try? JSONDecoder().decode([MyPoint].self, from: data) {
            return decoded
        }
        return []
    }

    func appendPoint(_ point: MyPoint, forKey key: String) {
        var currentPoints = getPoints(forKey: key)
        currentPoints.append(point)
        savePoints(currentPoints, forKey: key)
    }
}
