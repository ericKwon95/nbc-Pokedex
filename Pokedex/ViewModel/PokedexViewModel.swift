//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by 권승용 on 1/2/25.
//

import Foundation
import RxSwift

final class PokedexViewModel {
    let pokemonListSubject = BehaviorSubject<[Pokemon]>(value: [])
    
    private let networkManager = NetworkManager.shared

    private let limit = 20
    private var offset = 0
    
    private let disposeBag = DisposeBag()

    func fetchPokemonList() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokemonListSubject.onError(NetworkError.invalidURL)
            return
        }
        
        networkManager.fetch(url: url)
            .subscribe { [weak self] (response: PokemonListResponse) in
                self?.fetchPokemonDetail(from: response)
            } onFailure: { [weak self] error in
                self?.pokemonListSubject.onError(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchPokemonDetail(from pokemonList: PokemonListResponse) {
        var fetchedPokemons: [Pokemon] = []
        pokemonList.results.forEach { response in
            guard let url = URL(string: response.url) else {
                self.pokemonListSubject.onError(NetworkError.invalidURL)
                return
            }
            
            networkManager.fetch(url: url)
                .subscribe { [weak self] (response: PokemonDetailResponse) in
                    let newPokemon = Pokemon(
                        number: response.id,
                        name: response.name,
                        height: response.height,
                        weight: response.weight,
                        type: response.types.type.first!.name
                    )
                    fetchedPokemons.append(newPokemon)
                    
                    if fetchedPokemons.count == self?.limit {
                        self?.pokemonListSubject.onNext(fetchedPokemons)
                    }
                } onFailure: { [weak self] error in
                    self?.pokemonListSubject.onError(error)
                }
                .disposed(by: disposeBag)
        }
    }
}
