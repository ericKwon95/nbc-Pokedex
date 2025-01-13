//
//  MainViewModel.swift
//  Pokedex
//
//  Created by 권승용 on 1/2/25.
//

import Foundation
import RxSwift
import RxRelay

final class MainViewModel {
    let pokemonListRelay = PublishRelay<[PokemonThumbnail]>()
    let errorStringRelay = PublishRelay<String>()
    var isFetching = false
    
    private var pokemonList = [PokemonThumbnail]()
    private let limit = 20
    private var offset = 0
    
    private let disposeBag = DisposeBag()
    
    func viewDidLoad() {
        fetchPokemonList()
    }
    
    func scrollEndReached() {
        if !isFetching {
            fetchPokemonList()
        }
    }
    
    private func fetchPokemonList() {
        isFetching = true
        
        guard let url = Endpoint.pokemonList(limit: limit, offset: offset) else {
            errorStringRelay.accept(NetworkError.invalidURL.localizedDescription)
            return
        }
        offset += limit

        NetworkManager.shared.fetch(url: url)
            .subscribe { [weak self] (response: PokemonListResponse) in
                let thumbnails = self?.makePokemonThumbnails(from: response)
                self?.pokemonList.append(contentsOf: thumbnails ?? [])
                self?.pokemonListRelay.accept(self?.pokemonList ?? [])
                self?.isFetching = false
            } onFailure: { [weak self] error in
                self?.errorStringRelay.accept(error.localizedDescription)
                self?.isFetching = false
            }
            .disposed(by: disposeBag)
    }
    
    private func makePokemonThumbnails(from response: PokemonListResponse) -> [PokemonThumbnail] {
        response.results.compactMap {
            let url = $0.url
            let components = url.components(separatedBy: "/")
            guard components.count > 1,
                  let number = Int(components[components.count - 2]),
                  let thumbnailUrl = Endpoint.pokemonThumbnail(pokemonId: number) else {
                return nil
            }
            
            return PokemonThumbnail(
                number: number,
                thumbnailUrl: thumbnailUrl)
        }
    }
}
