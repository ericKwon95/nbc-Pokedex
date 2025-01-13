//
//  Pokemon.swift
//  Pokedex
//
//  Created by 권승용 on 1/1/25.
//

import Foundation

struct PokemonDetail: Identifiable {
    let id = UUID()
    let number: Int
    let name: String
    let height: Measurement<UnitLength>
    let weight: Measurement<UnitMass>
    let type: String
}
