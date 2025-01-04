//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by 권승용 on 1/4/25.
//

import Foundation
import RxSwift
import RxRelay

final class DetailViewModel {
    let pokemonDetailRelay = PublishRelay<PokemonDetail>()
    let errorRelay = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    
    func fetchPokemonDetail(from number: Int) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(number)/") else {
            errorRelay.accept(NetworkError.invalidURL)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe { [weak self] (response: PokemonDetailResponse) in
                let newPokemonDetail = PokemonDetail(
                    number: response.id,
                    name: PokemonTranslator.getKoreanName(for: response.name),
                    height: response.height,
                    weight: response.weight,
                    type: PokemonTypeName(rawValue: response.types.first!.type.name)?.displayName ?? "미정"
                )
                self?.pokemonDetailRelay.accept(newPokemonDetail)
            } onFailure: { [weak self] error in
                self?.errorRelay.accept(error)
            }
            .disposed(by: disposeBag)
    }
}

