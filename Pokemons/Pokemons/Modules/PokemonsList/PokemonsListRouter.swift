//
//  PokemonsListRouter.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

protocol PokemonsListRouterProtocol: AnyObject {
    
}

final class PokemonsListRouter: PokemonsListRouterProtocol {
    weak var view: PokemonsListViewProtocol?
    
    init(view: PokemonsListViewProtocol) {
        self.view = view
    }
}
