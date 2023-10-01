//
//  PokemonInfoRouter.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

protocol PokemonInfoRouterProtocol: AnyObject {
    
}

final class PokemonInfoRouter: PokemonInfoRouterProtocol {
    weak var view: PokemonInfoViewProtocol?
    
    init(view: PokemonInfoViewProtocol? = nil) {
        self.view = view
    }
}
