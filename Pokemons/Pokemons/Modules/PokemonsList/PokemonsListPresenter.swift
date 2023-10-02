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
    var pokemonsIsEmpty: Bool { get }
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
        return self.pokemons.count
    }
    
    var pokemonsIsEmpty: Bool {
        return self.pokemons.isEmpty
    }
    
    required init(view: PokemonsListViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        if !NetworkManager.shared.isReachable {
            self.pokemons.append(contentsOf: self.interactor?.getLocalPokemons() ?? [])
            self.canLoadMore = false
            self.view?.reloadData()
            return
        }
        
        interactor?.getPokemons(offset: self.pokemonsCount, success: { [weak self] pokemons, canLoadMore in
            self?.pokemons.append(contentsOf: pokemons)
            self?.canLoadMore = canLoadMore
            self?.view?.reloadData()
            if !CoreDataManager.shared.fetch(LocalPokeInfo.self).isEmpty {
                CoreDataManager.shared.clearEntities(of: LocalPokeInfo.self)
            }
            
            if !CoreDataManager.shared.fetch(LocalPokeFullInfo.self).isEmpty {
                CoreDataManager.shared.clearEntities(of: LocalPokeFullInfo.self)
            }
            
            pokemons.forEach { pokemon in
                let pokeInfo = CoreDataManager.shared.create(LocalPokeInfo.self)
                pokeInfo.id = pokemon.id
                pokeInfo.name = pokemon.name
                CoreDataManager.shared.save()
            }
        }, failure: { [weak self] in
            self?.router?.presentAlert(.fetchingDataError)
            self?.view?.stopRefreshing()
        })
    }
    
    func viewDidAppear() {
        guard !NetworkManager.shared.isReachable,
              CoreDataManager.shared.fetch(LocalPokeInfo.self).isEmpty
        else { return }
        
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
            pokemons.forEach { pokemon in
                let pokeInfo = CoreDataManager.shared.create(LocalPokeInfo.self)
                pokeInfo.id = pokemon.id
                pokeInfo.name = pokemon.name
                CoreDataManager.shared.save()
            }
        }, failure: { [weak self] in
            self?.router?.presentAlert(.fetchingDataError)
            self?.view?.stopRefreshing()
        })
    }
    
    func didSelect(at index: Int) {
        if NetworkManager.shared.isReachable || CoreDataManager.shared.fetch(LocalPokeFullInfo.self, using: NSPredicate(format: "id==%@", self.pokemons[index].id)).first != nil {
            self.router?.openPokemon(with: self.pokemons[index].id)
        } else {
            self.router?.presentAlert(.hasNoInternet)
        }
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
