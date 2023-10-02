//
//  AlertType.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 2.10.23.
//

import Foundation

enum AlertType {
    case hasNoInternet
    case fetchingDataError
    
    var title: String {
        switch self {
            case .hasNoInternet:
                return "App has no internet connection"
            case .fetchingDataError:
                return "Error while fetching data"
        }
    }
    
    var message: String {
        switch self {
            case .hasNoInternet:
                return "Please, turn on mobile internet or connect to Wi-Fi"
            case .fetchingDataError:
                return ""
        }
    }
}
