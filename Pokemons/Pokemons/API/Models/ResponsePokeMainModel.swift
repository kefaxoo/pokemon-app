//
//  ResponsePokeMainModel.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

final class ResponsePokeMainModel<T>: Decodable where T: Decodable {
    fileprivate let next: String?
    
    let results: [T]
    
    var canLoadMore: Bool {
        return next != nil
    }
    
    enum CodingKeys: CodingKey {
        case next
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.results = try container.decode([T].self, forKey: .results)
    }
}
