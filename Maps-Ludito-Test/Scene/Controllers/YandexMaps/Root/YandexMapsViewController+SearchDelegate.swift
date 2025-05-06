//
//  YandexMapsViewController+SearchDelegate.swift
//  Maps-Ludito-Test
//
//  Created by Khushnidjon Keldiboev on 06/05/25.
//

import Foundation

extension YandexMapsViewController {
    class LuditoSearchBarDelegateHandler: LuditoSearchBarDelegate {
        private let search: (String) -> Void

        init(searchSelection: @escaping (String) -> Void) {
            self.search = searchSelection
        }
        
        func searchBarView(text: String) {
            self.search(text)
        }
    }
}
