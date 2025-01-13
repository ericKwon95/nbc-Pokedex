//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by 권승용 on 1/4/25.
//

import Foundation
import RxSwift
import RxRelay

final class DetailViewModel: ObservableObject {
    @Published var pokemonDetail: PokemonDetail = .dummy
    @Published var errorDescription: String?
    
    private let disposeBag = DisposeBag()
    
    func onAppear(with number: Int) {
        fetchPokemonDetail(from: number)
    }
    
    func fetchPokemonDetail(from number: Int) {
        guard let url = Endpoint.pokemonDetail(pokemonId: number) else {
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe { [weak self] (response: PokemonDetailResponse) in
                let newPokemonDetail = PokemonDetail(
                    number: response.id,
                    name: PokemonTranslator.getKoreanName(for: response.name),
                    height: Measurement(value: Double(response.height), unit: .meters),
                    weight: Measurement(value: Double(response.weight), unit: .kilograms),
                    type: PokemonTypeName(rawValue: response.types.first!.type.name)?.displayName ?? "미정"
                )
                self?.pokemonDetail = newPokemonDetail
            } onFailure: { [weak self] error in
                self?.errorDescription = error.localizedDescription
            }
            .disposed(by: disposeBag)
    }
}

