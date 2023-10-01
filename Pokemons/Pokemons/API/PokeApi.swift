//
//  PokeApi.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation
import FriendlyURLSession

enum PokeApi {
    case getPokemons(offset: Int)
    case getPokemonInfo(id: Int)
}

extension PokeApi: BaseRestApiEnum {
    var baseUrl: String {
        return "https://pokeapi.co/api/v2"
    }
    
    var path: String {
        switch self {
            case .getPokemons:
                return "/pokemon"
            case .getPokemonInfo(let id):
                return "/pokemon/\(id)"
        }
    }
    
    var method: FriendlyURLSession.HTTPMethod {
        return .get
    }
    
    var headers: FriendlyURLSession.Headers? {
        return nil
    }
    
    var parameters: FriendlyURLSession.Parameters? {
        var parameters = Parameters()
        switch self {
            case .getPokemons(let offset):
                parameters["offset"] = offset
            default:
                break
        }
        return parameters
    }
}
