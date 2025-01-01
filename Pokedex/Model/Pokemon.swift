//
//  Pokemon.swift
//  Pokedex
//
//  Created by 권승용 on 1/1/25.
//

import Foundation

struct Pokemon: Identifiable {
    let id = UUID()
    let number: Int
    let name: String
    let height: Int
    let weight: Int
    let type: String
}
