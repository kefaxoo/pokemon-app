//
//  PokemonInfoView.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import UIKit

protocol PokemonInfoViewProtocol: AnyObject {
    
}

final class PokemonInfoView: UIViewController {
    var presenter: PokemonInfoPresenter?
    private let configurator: PokemonInfoConfigurator
    
    init(id: String) {
        self.configurator = PokemonInfoConfigurator(id: id)
        super.init(nibName: nil, bundle: nil)
        self.setupInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter?.configureView()
    }
}

// MARK: -
// MARK: Setup interface methods
extension PokemonInfoView {
    private func setupInterface() {
        self.view.backgroundColor = .systemBackground
        
        self.setupLayout()
        self.setupConstraints()
    }
    
    private func setupLayout() {
        
    }
    
    private func setupConstraints() {
        
    }
}

extension PokemonInfoView: PokemonInfoViewProtocol {
    
}
