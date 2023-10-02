//
//  PokeInfoTableViewSettings.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 2.10.23.
//

import Foundation

enum PokeInfoTableViewSettings: CaseIterable {
    case info
    case specifications
    case types
    
    var countOfRows: Int {
        switch self {
            case .info:
                return 1
            case .specifications:
                return 2
            case .types:
                return 1
        }
    }
    
    var sectionTitle: String {
        switch self {
            case .info:
                return "Info"
            case .specifications:
                return "Specificatioons"
            case .types:
                return "Types"
        }
    }
    
    static func id(for indexPath: IndexPath) -> String {
        return indexPath.section == 0 ? PokemonPictureTableViewCell.id : PokemonTextTableViewCell.id
    }
}
