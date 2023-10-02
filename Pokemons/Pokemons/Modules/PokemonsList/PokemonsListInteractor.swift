//
//  PokemonsListInteractor.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

protocol PokemonsListInteractorProtocol: AnyObject {
    func getPokemons(offset: Int, success: @escaping(([PokeInfo], Bool) -> ()), failure: @escaping(() -> ()))
    func getLocalPokemons() -> [PokeInfo]
}

final class PokemonsListInteractor: PokemonsListInteractorProtocol {
    private weak var presenter: PokemonsListPresenterProtocol?
    
    required init(presenter: PokemonsListPresenterProtocol) {
        self.presenter = presenter
    }
    
    func getPokemons(offset: Int, success: @escaping (([PokeInfo], Bool) -> ()), failure: @escaping (() -> ())) {
        PokeProvider.shared.getPokemons(offset: offset, success: success, failure: failure)
    }
    
    func getLocalPokemons() -> [PokeInfo] {
        return CoreDataManager.shared.fetch(LocalPokeInfo.self).compactMap({ $0 }).map({ PokeInfo(from: $0) }).compactMap({ $0 })
    }
}
