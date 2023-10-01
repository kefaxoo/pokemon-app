//
//  PokemonsListView.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import UIKit

protocol PokemonsListViewProtocol: AnyObject {
    func reloadData()
}

final class PokemonsListView: UIViewController {
    private lazy var pokemonsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.register(PokemonTableViewCell.self)
        tableView.delegate = self
        return tableView
    }()
    
    var presenter: PokemonsListPresenter?
    private var configurator: PokemonsListConfigurator = PokemonsListConfigurator()
    
    init() {
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
extension PokemonsListView {
    private func setupInterface() {
        self.view.backgroundColor = .systemBackground
        
        self.setupLayout()
        self.setupConstraints()
    }
    
    private func setupLayout() {
        self.view.addSubview(pokemonsTableView)
    }
    
    private func setupConstraints() {
        pokemonsTableView.snp.makeConstraints({ $0.edges.equalToSuperview() })
    }
}

extension PokemonsListView: PokemonsListViewProtocol {
    func reloadData() {
        pokemonsTableView.reloadData()
    }
}

extension PokemonsListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.pokemonsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.id, for: indexPath)
        (cell as? PokemonTableViewCell)?.setupCell(name: self.presenter?.getPokemonName(for: indexPath.item) ?? "")
        return cell
    }
}

extension PokemonsListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
