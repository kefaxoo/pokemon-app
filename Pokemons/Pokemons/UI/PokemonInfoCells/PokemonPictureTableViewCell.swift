//
//  PokemonPictureTableViewCell.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 2.10.23.
//

import UIKit
import SDWebImage

final class PokemonPictureTableViewCell: UITableViewCell {
    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var pokemonLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupInterface()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupInterface()
    }
    
    override func prepareForReuse() {
        self.pokemonImageView.image = nil
        self.pokemonLabel.text = nil
    }
    
    private func setupInterface() {
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        
        self.setupLayout()
        self.setupConstraints()
    }
    
    private func setupLayout() {
        self.contentView.addSubview(pokemonImageView)
        self.contentView.addSubview(pokemonLabel)
    }
    
    private func setupConstraints() {
        pokemonImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(20)
            make.height.width.equalTo(40)
        }
        
        pokemonLabel.snp.makeConstraints { make in
            make.leading.equalTo(pokemonImageView.snp.trailing).offset(20)
            make.centerY.equalTo(pokemonImageView.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setupCell(_ pokemon: PokeFullInfo?) {
        self.pokemonLabel.text = pokemon?.name.capitalized
        self.pokemonImageView.sd_setImage(with: URL(string: pokemon?.frontImageLink ?? ""))
    }
}

