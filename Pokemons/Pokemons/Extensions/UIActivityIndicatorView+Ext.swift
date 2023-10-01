//
//  UIActivityIndicatorView+Ext.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import UIKit

extension UIActivityIndicatorView {
    func show(_ isShowing: Bool) {
        self.isHidden = !isShowing
        if isShowing {
            self.startAnimating()
        } else {
            self.stopAnimating()
        }
    }
}
