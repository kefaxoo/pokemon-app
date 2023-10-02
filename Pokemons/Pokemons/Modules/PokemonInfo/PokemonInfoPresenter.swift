//
//  PokemonInfoPresenter.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation

protocol PokemonInfoPresenterProtocol: AnyObject {
    var router: PokemonInfoRouterProtocol? { get set }
    func configureView()
    
    func getPokemon() -> PokeFullInfo?
    func getText(for position: Int) -> String
    func getTypes() -> String
}

final class PokemonInfoPresenter: PokemonInfoPresenterProtocol {
    weak var view: PokemonInfoViewProtocol?
    weak var interactor: PokemonInfoInteractorProtocol?
    weak var router: PokemonInfoRouterProtocol?
    
    private let id: String
    
    private var pokemon: PokeFullInfo?
    
    required init(view: PokemonInfoViewProtocol, id: String) {
        self.view = view
        self.id = id
    }
    
    func configureView() {
        PokeProvider.shared.getPokemonInfo(id: self.id) { [weak self] pokeInfo in
            self?.pokemon = pokeInfo
            self?.view?.reloadData()
            let pokemon = CoreDataManager.shared.create(LocalPokeFullInfo.self)
            pokemon.name = pokeInfo.name
            pokemon.weight = Int32(pokeInfo.weight)
            pokemon.height = Int32(pokeInfo.height)
            pokemon.types = pokeInfo.types
            pokemon.id = self?.id
            CoreDataManager.shared.save()
        } failure: { [weak self] in
            self?.router?.presentAlert(.fetchingDataError)
            self?.view?.reloadData()
        }
    }
    
    func getPokemon() -> PokeFullInfo? {
        return self.pokemon
    }
    
    func getText(for position: Int) -> String {
        return position == 0 ? "Height: \(self.pokemon?.height ?? 0)" : "Weight: \(self.pokemon?.weight ?? 0)"
    }
    
    func getTypes() -> String {
        return self.pokemon?.types.map({ $0.capitalized }).joined(separator: ", ") ?? ""
    }
}
