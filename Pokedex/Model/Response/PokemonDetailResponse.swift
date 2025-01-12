//
//  PokemonDetailResponse.swift
//  Pokedex
//
//  Created by 권승용 on 1/1/25.
//

import Foundation

struct PokemonDetailResponse: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonTypeListResponse]
}

struct PokemonTypeListResponse: Decodable {
    let slot: Int
    let type: PokemonTypeResponse
}

struct PokemonTypeResponse: Decodable {
    let name: String
    let url: String
}
