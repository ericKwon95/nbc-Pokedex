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
    
    static let dummy = PokemonDetail(
        number: 0,
        name: "",
        height: Measurement(value: 0, unit: .meters),
        weight: Measurement(value: 0, unit: .kilograms),
        type: ""
    )
}
