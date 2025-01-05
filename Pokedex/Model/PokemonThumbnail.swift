//
//  PokemonThumbnail.swift
//  Pokedex
//
//  Created by 권승용 on 1/4/25.
//

import Foundation

struct PokemonThumbnail: Identifiable {
    let id = UUID().uuidString
    let number: Int
    let thumbnailUrl: URL
}
