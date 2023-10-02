//
//  ResponsePokeFullModel.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

final class ResponsePokeFullModel: Decodable {
    fileprivate let sprite: ResponsePokeSpriteModel
    fileprivate let types: [ResponsePokeTypeModel]
    
    let name: String
    let weight: Int
    let height: Int
    
    var frontImageLink: String {
        return self.sprite.frontLink
    }
    
    var typesArr: [String] {
        return self.types.map({ $0.type.name })
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
     
        self.sprite = try container.decode(ResponsePokeSpriteModel.self, forKey: .sprite)
        self.types = try container.decode([ResponsePokeTypeModel].self, forKey: .types)
        self.name = try container.decode(String.self, forKey: .name)
        self.weight = try container.decode(Int.self, forKey: .weight)
        self.height = try container.decode(Int.self, forKey: .height)
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
    let slot: Int
    let type: ResponsePokeTypeInfoModel
    
    enum CodingKeys: CodingKey {
        case slot
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        self.slot = try container.decode(Int.self, forKey: .slot)
        self.type = try container.decode(ResponsePokeTypeInfoModel.self, forKey: .type)
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
