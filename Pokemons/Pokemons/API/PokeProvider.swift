//
//  PokeProvider.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 1.10.23.
//

import Foundation
import FriendlyURLSession

final class PokeProvider: BaseRestApiProvider {
    static let shared = PokeProvider()
    
    fileprivate init() {
        let shouldPrintLog: Bool
#if DEBUG
        shouldPrintLog = true
#else
        shouldPrintLog = false
#endif
        
        super.init(shouldPrintLog: shouldPrintLog)
    }
    
    func getPokemons(offset: Int = 0, success: @escaping(([PokeInfo], Bool) -> ()), failure: @escaping(() -> ())) {
        self.urlSession.dataTask(with: URLRequest(type: PokeApi.getPokemons(offset: offset), shouldPrintLog: self.shouldPrintLog)) { response in
            switch response {
                case .success(let response):
                    guard let pokeResults = response.data?.map(to: PokeMain<PokeInfo>.self) else {
                        failure()
                        return
                    }
                    
                    success(pokeResults.results, pokeResults.canLoadMore)
                case .failure:
                    failure()
            }
        }
    }
}
