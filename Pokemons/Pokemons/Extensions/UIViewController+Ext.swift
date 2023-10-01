//
//  UIViewController+Ext.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import UIKit

extension UIViewController {
    func configureNavigationController(title: String? = nil, preferesLargeTitles: Bool = true) -> UINavigationController {
        self.navigationItem.title = title
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.navigationBar.prefersLargeTitles = preferesLargeTitles
        return navigationController
    }
}
