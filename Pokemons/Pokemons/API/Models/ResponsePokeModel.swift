//
//  ResponsePokeInfoModel.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

final class ResponsePokeInfoModel: Decodable {
    let name: String
    let id: String
    
    enum CodingKeys: CodingKey {
        case name
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        self.name = try container.decode(String.self, forKey: .name)
        let url = try container.decode(String.self, forKey: .url)
        self.id = String(url.split(separator: "/").last ?? "")
    }
    
    init?(from coreDataModel: LocalPokeInfo) {
        guard let name = coreDataModel.name,
              let id = coreDataModel.id
        else { return nil }
        
        self.name = name
        self.id = id
    }
}
