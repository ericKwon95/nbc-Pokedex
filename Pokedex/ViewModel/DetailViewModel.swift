//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by 권승용 on 1/4/25.
//

import Foundation
import RxSwift

final class DetailViewModel {
    let pokemonDetailSubject = PublishSubject<PokemonDetail>()
    
    private let disposeBag = DisposeBag()
    
    func fetchPokemonDetail(from number: Int) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(number)/") else {
            pokemonDetailSubject.onError(NetworkError.invalidURL)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe { [weak self] (response: PokemonDetailResponse) in
                let newPokemonDetail = PokemonDetail(
                    number: response.id,
                    name: response.name,
                    height: response.height,
                    weight: response.weight,
                    type: response.types.first!.type.name
                )
                self?.pokemonDetailSubject.onNext(newPokemonDetail)
            } onFailure: { [weak self] error in
                self?.pokemonDetailSubject.onError(error)
            }
            .disposed(by: disposeBag)
    }
}
