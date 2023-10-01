//
//  PokemonInfoInteractor.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

protocol PokemonInfoInteractorProtocol: AnyObject {
    
}

final class PokemonInfoInteractor: PokemonInfoInteractorProtocol {
    private weak var presenter: PokemonInfoPresenterProtocol?
    
    required init(presenter: PokemonInfoPresenterProtocol) {
        self.presenter = presenter
    }
}
