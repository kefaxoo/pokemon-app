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
    func viewDidAppear()
    func getPokemonName(for index: Int) -> String
    func loadMorePokemons()
    func didSelect(at index: Int)
    func refreshData()
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
        }, failure: { [weak self] in
            self?.router?.presentAlert(.fetchingDataError)
            self?.view?.stopRefreshing()
        })
    }
    
    func viewDidAppear() {
        guard !NetworkManager.shared.isReachable else { return }
        
        self.router?.presentAlert(.hasNoInternet)
    }
    
    func getPokemonName(for index: Int) -> String {
        return self.pokemons[index].name.capitalized
    }
    
    func loadMorePokemons() {
        guard canLoadMore else { return }
        
        interactor?.getPokemons(offset: self.pokemonsCount, success: { [weak self] pokemons, canLoadMore in
            self?.pokemons.append(contentsOf: pokemons)
            self?.canLoadMore = canLoadMore
            self?.view?.reloadData()
        }, failure: { [weak self] in
            self?.router?.presentAlert(.fetchingDataError)
            self?.view?.stopRefreshing()
        })
    }
    
    func didSelect(at index: Int) {
        guard NetworkManager.shared.isReachable else {
            self.router?.presentAlert(.hasNoInternet)
            return
        }
        
        self.router?.openPokemon(with: self.pokemons[index].id)
    }
    
    func refreshData() {
        guard NetworkManager.shared.isReachable else {
            self.router?.presentAlert(.hasNoInternet)
            self.view?.stopRefreshing()
            return
        }
        
        self.configureView()
    }
}
