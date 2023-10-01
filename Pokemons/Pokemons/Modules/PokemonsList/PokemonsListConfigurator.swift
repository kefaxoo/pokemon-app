//
//  PokemonsListConfigurator.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

protocol PokemonsListConfiguratorProtocol: AnyObject {
    func configure(with view: PokemonsListView)
}

final class PokemonsListConfigurator: PokemonsListConfiguratorProtocol {
    func configure(with view: PokemonsListView) {
        let presenter = PokemonsListPresenter(view: view)
        let interactor = PokemonsListInteractor(presenter: presenter)
        let router = PokemonsListRouter(view: view)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
