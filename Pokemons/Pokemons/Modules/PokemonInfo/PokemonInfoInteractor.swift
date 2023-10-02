//
//  PokemonInfoInteractor.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

protocol PokemonInfoInteractorProtocol: AnyObject {
    func getPokemonInfo(id: String, success: @escaping((PokeFullInfo) -> ()), failure: @escaping(() -> ()))
    func localPokemonInfo(id: String) -> PokeFullInfo?
}

final class PokemonInfoInteractor: PokemonInfoInteractorProtocol {
    private weak var presenter: PokemonInfoPresenterProtocol?
    
    required init(presenter: PokemonInfoPresenterProtocol) {
        self.presenter = presenter
    }
    
    func getPokemonInfo(id: String, success: @escaping ((PokeFullInfo) -> ()), failure: @escaping (() -> ())) {
        PokeProvider.shared.getPokemonInfo(id: id, success: success, failure: failure)
    }
    
    func localPokemonInfo(id: String) -> PokeFullInfo? {
        return PokeFullInfo(from: CoreDataManager.shared.fetch(LocalPokeFullInfo.self, using: NSPredicate(format: "id==%@", id)).first)
    }
}
