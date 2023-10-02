//
//  PokemonInfoView.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import UIKit

protocol PokemonInfoViewProtocol: AnyObject {
    func reloadData()
    func present(_ vc: UIAlertController)
}

final class PokemonInfoView: UIViewController {
    private lazy var spinnerView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()
    
    private lazy var pokemonInfoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.register(PokemonPictureTableViewCell.self, PokemonTextTableViewCell.self)
        tableView.isHidden = true
        return tableView
    }()
    
    var presenter: PokemonInfoPresenterProtocol?
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: -
// MARK: Setup interface methods
extension PokemonInfoView {
    private func setupInterface() {
        self.view.backgroundColor = .systemBackground
        
        self.setupLayout()
        self.setupConstraints()
        self.spinnerView.show(true)
    }
    
    private func setupLayout() {
        self.view.addSubview(pokemonInfoTableView)
        self.view.addSubview(spinnerView)
    }
    
    private func setupConstraints() {
        spinnerView.snp.makeConstraints({ $0.edges.equalToSuperview() })
        pokemonInfoTableView.snp.makeConstraints({ $0.edges.equalToSuperview() })
    }
}

extension PokemonInfoView: PokemonInfoViewProtocol {
    func reloadData() {
        self.spinnerView.show(false)
        self.pokemonInfoTableView.isHidden = false
        self.pokemonInfoTableView.reloadData()
    }
    
    func present(_ vc: UIAlertController) {
        self.present(vc, animated: true)
    }
}

extension PokemonInfoView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PokeInfoTableViewSettings.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return PokeInfoTableViewSettings.allCases[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PokeInfoTableViewSettings.allCases[section].countOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokeInfoTableViewSettings.id(for: indexPath), for: indexPath)
        if indexPath.section == 0 {
            (cell as? PokemonPictureTableViewCell)?.setupCell(self.presenter?.getPokemon())
        } else if indexPath.section == 1 {
            (cell as? PokemonTextTableViewCell)?.setupCell(with: self.presenter?.getText(for: indexPath.row))
        } else {
            (cell as? PokemonTextTableViewCell)?.setupCell(with: self.presenter?.getTypes())
        }
        
        return cell
    }
}
