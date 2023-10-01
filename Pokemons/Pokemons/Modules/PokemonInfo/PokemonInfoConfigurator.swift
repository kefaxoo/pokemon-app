//
//  PokemonInfoConfigurator.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

protocol PokemonInfoConfiguratorProtocol: AnyObject {
    func configure(with view: PokemonInfoView)
}

final class PokemonInfoConfigurator: PokemonInfoConfiguratorProtocol {
    private let id: String
    
    init(id: String) {
        self.id = id
    }
    
    func configure(with view: PokemonInfoView) {
        let presenter = PokemonInfoPresenter(view: view, id: self.id)
        let interactor = PokemonInfoInteractor(presenter: presenter)
        let router = PokemonInfoRouter(view: view)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
