//
//  PokemonTextTableViewCell.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 2.10.23.
//

import UIKit

final class PokemonTextTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupInterface()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupInterface()
    }
    
    private func setupInterface() {
        self.setupLayout()
        self.setupConstraints()
    }
    
    private func setupLayout() {
        self.contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints({ $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)) })
    }
    
    func setupCell(with text: String?) {
        self.titleLabel.text = text
    }
}
