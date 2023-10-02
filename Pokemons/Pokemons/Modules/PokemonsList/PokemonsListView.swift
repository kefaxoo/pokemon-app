//
//  PokemonsListView.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import UIKit

protocol PokemonsListViewProtocol: AnyObject {
    func reloadData()
    func pushViewController(vc: UIViewController)
    func present(_ vc: UIAlertController)
    func stopRefreshing()
}

final class PokemonsListView: UIViewController {
    private lazy var spinnerView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()
    
    private lazy var pokemonsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.register(PokemonTableViewCell.self)
        tableView.delegate = self
        tableView.refreshControl = self.refreshControl
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    var presenter: PokemonsListPresenterProtocol?
    private var configurator = PokemonsListConfigurator()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter?.viewDidAppear()
    }
}

// MARK: -
// MARK: Setup interface methods
extension PokemonsListView {
    private func setupInterface() {
        self.view.backgroundColor = .systemBackground
        self.setupLayout()
        self.setupConstraints()
        self.spinnerView.show(true)
    }
    
    private func setupLayout() {
        self.view.addSubview(pokemonsTableView)
        self.view.addSubview(spinnerView)
    }
    
    private func setupConstraints() {
        spinnerView.snp.makeConstraints({ $0.edges.equalToSuperview() })
        pokemonsTableView.snp.makeConstraints({ $0.edges.equalToSuperview() })
    }
}

extension PokemonsListView: PokemonsListViewProtocol {
    func reloadData() {
        self.stopRefreshing()
        pokemonsTableView.reloadData()
    }
    
    func pushViewController(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func present(_ vc: UIAlertController) {
        self.present(vc, animated: true)
    }
    
    func stopRefreshing() {
        self.refreshControl.endRefreshing()
        self.spinnerView.show(false)
    }
}

extension PokemonsListView {
    @objc private func refreshData() {
        self.presenter?.refreshData()
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
        self.presenter?.didSelect(at: indexPath.item)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.item == (self.presenter?.pokemonsCount ?? 0) - 1 else { return }
        
        self.presenter?.loadMorePokemons()
    }
}
