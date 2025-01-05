//
//  PokemonDetailResponse.swift
//  Pokedex
//
//  Created by 권승용 on 1/1/25.
//

import Foundation

struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonTypeListResponse]
}

struct PokemonTypeListResponse: Codable {
    let slot: Int
    let type: PokemonTypeResponse
}

struct PokemonTypeResponse: Codable {
    let name: String
    let url: String
}
