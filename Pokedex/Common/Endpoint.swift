//
//  Endpoint.swift
//  Pokedex
//
//  Created by 권승용 on 1/6/25.
//

import Foundation

enum Endpoint {
    static func pokemonList(limit: Int, offset: Int) -> URL? {
        return URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)")
    }
    
    static func pokemonThumbnail(pokemonId: Int) -> URL? {
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonId).png")
    }
    
    static func pokemonDetail(pokemonId: Int) -> URL? {
        return URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonId)")
    }
}
