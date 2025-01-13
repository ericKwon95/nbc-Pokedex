//
//  PokemonDetailHostingController.swift
//  Pokedex
//
//  Created by 권승용 on 1/13/25.
//

import SwiftUI
import RxSwift

final class PokemonDetailHostingController: UIHostingController<PokemonDetailView> {
    init(pokemonNumber: Int) {
        super.init(
            rootView: PokemonDetailView(pokemonNumber: pokemonNumber)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
