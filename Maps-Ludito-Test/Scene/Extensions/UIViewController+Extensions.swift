//
//  UIViewController+Extensions.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon Keldiboev on 05/05/25.
//

import UIKit

extension UIViewController {
    func showErrorAlert(message: String, title: String = "Ошибка") {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
