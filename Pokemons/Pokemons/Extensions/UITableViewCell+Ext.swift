//
//  UITableViewCell+Ext.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import UIKit

extension UITableViewCell {
    static var id: String {
        return String(describing: self.self)
    }
}
