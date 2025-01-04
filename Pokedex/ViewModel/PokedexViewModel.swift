//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by 권승용 on 1/2/25.
//

import Foundation
import RxSwift

final class PokedexViewModel {
    let pokemonListSubject = BehaviorSubject<[PokemonThumbnail]>(value: [])
    
    private let limit = 20
    private var offset = 0
    
    private let disposeBag = DisposeBag()
    
    func fetchPokemonList() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokemonListSubject.onError(NetworkError.invalidURL)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe { [weak self] (response: PokemonListResponse) in
                let thumbnails = self?.makePokemonThumbnails(from: response)
                self?.pokemonListSubject.onNext(thumbnails ?? [])
            } onFailure: { [weak self] error in
                self?.pokemonListSubject.onError(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func makePokemonThumbnails(from response: PokemonListResponse) -> [PokemonThumbnail] {
        response.results.compactMap {
            let url = $0.url
            let components = url.components(separatedBy: "/")
            guard let last = components.last,
               let number = Int(last) else {
                return nil
            }
            return PokemonThumbnail(number: number)
        }
    }
}
