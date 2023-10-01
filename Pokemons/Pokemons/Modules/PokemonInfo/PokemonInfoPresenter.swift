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
}

final class PokemonInfoPresenter: PokemonInfoPresenterProtocol {
    weak var view: PokemonInfoViewProtocol?
    var interactor: PokemonInfoInteractorProtocol?
    var router: PokemonInfoRouterProtocol?
    
    private let id: String
    
    required init(view: PokemonInfoViewProtocol, id: String) {
        self.view = view
        self.id = id
    }
    
    func configureView() {
        
    }
}
