//
//  PokemonListResponse.swift
//  Pokedex
//
//  Created by 권승용 on 1/1/25.
//

import Foundation

struct PokemonListResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonResponse]
}

struct PokemonResponse: Decodable {
    let url: String
}
