//
//  PokemonsListPresenter.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

protocol PokemonsListPresenterProtocol: AnyObject {
    var router: PokemonsListRouterProtocol? { get set }
    var pokemonsCount: Int { get }
    func configureView()
    func getPokemonName(for index: Int) -> String
}

final class PokemonsListPresenter: PokemonsListPresenterProtocol {
    weak var view: PokemonsListViewProtocol?
    var interactor: PokemonsListInteractorProtocol?
    var router: PokemonsListRouterProtocol?
    
    private var pokemons = [PokeInfo]()
    private var canLoadMore = true
    
    var pokemonsCount: Int {
        get {
            return self.pokemons.count
        }
    }
    
    required init(view: PokemonsListViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        interactor?.getPokemons(offset: self.pokemonsCount, success: { [weak self] pokemons, canLoadMore in
            self?.pokemons.append(contentsOf: pokemons)
            self?.canLoadMore = canLoadMore
            self?.view?.reloadData()
        }, failure: {
            
        })
    }
    
    func getPokemonName(for index: Int) -> String {
        return self.pokemons[index].name.capitalized
    }
}
