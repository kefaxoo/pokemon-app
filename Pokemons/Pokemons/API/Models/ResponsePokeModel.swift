//
//  ResponsePokeInfoModel.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

final class ResponsePokeInfoModel: Decodable {
    fileprivate let url: String
    
    let name: String
    
    var id: String {
        return String(self.url.split(separator: "/").last ?? "")
    }
    
    enum CodingKeys: CodingKey {
        case name
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
    }
}
