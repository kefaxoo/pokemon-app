//
//  ResponsePokeFullModel.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

final class ResponsePokeFullModel: Decodable {
    fileprivate let sprite: ResponsePokeSpriteModel?
    let name: String
    let weight: Int
    let height: Int
    let types: [String]
    
    var frontImageLink: String {
        return self.sprite?.frontLink ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case sprite = "sprites"
        case types
        case name
        case weight
        case height
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        self.sprite = try container.decodeIfPresent(ResponsePokeSpriteModel.self, forKey: .sprite)
        self.types = try container.decode([ResponsePokeTypeModel].self, forKey: .types).map({ $0.name })
        self.name = try container.decode(String.self, forKey: .name)
        self.weight = try container.decode(Int.self, forKey: .weight)
        self.height = try container.decode(Int.self, forKey: .height)
    }
    
    init?(from coreDataModel: LocalPokeFullInfo?) {
        guard let coreDataModel,
              let name = coreDataModel.name,
              let types = coreDataModel.types
        else { return nil }
        
        self.types = types
        self.name = name
        self.weight = Int(coreDataModel.weight)
        self.height = Int(coreDataModel.height)
        self.sprite = nil
    }
}

fileprivate final class ResponsePokeSpriteModel: Decodable {
    let frontLink: String
    
    enum CodingKeys: String, CodingKey {
        case frontLink = "front_default"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        self.frontLink = try container.decode(String.self, forKey: .frontLink)
    }
}

fileprivate final class ResponsePokeTypeModel: Decodable {
    let name: String
    
    enum CodingKeys: CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        let type = try container.decode(ResponsePokeTypeInfoModel.self, forKey: .type)
        self.name = type.name
    }
}

fileprivate final class ResponsePokeTypeInfoModel: Decodable {
    let name: String
    
    enum CodingKeys: CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        self.name = try container.decode(String.self, forKey: .name)
    }
}
