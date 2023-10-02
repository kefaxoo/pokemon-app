//
//  PokemonsListRouter.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import UIKit

protocol PokemonsListRouterProtocol: AnyObject {
    func openPokemon(with id: String)
    func presentAlert(_ type: AlertType)
}

final class PokemonsListRouter: PokemonsListRouterProtocol {
    weak var view: PokemonsListViewProtocol?
    
    init(view: PokemonsListViewProtocol) {
        self.view = view
    }
    
    func openPokemon(with id: String) {
        self.view?.pushViewController(vc: PokemonInfoView(id: id))
    }
    
    func presentAlert(_ type: AlertType) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.view?.present(alert)
    }
}
