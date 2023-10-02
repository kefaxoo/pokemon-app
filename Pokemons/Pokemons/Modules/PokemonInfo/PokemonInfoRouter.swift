//
//  PokemonInfoRouter.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import UIKit

protocol PokemonInfoRouterProtocol: AnyObject {
    func presentAlert(_ type: AlertType)
}

final class PokemonInfoRouter: PokemonInfoRouterProtocol {
    weak var view: PokemonInfoViewProtocol?
    
    init(view: PokemonInfoViewProtocol? = nil) {
        self.view = view
    }
    
    func presentAlert(_ type: AlertType) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.view?.present(alert)
    }
}
