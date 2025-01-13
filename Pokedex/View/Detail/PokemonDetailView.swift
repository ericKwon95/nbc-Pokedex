//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by 권승용 on 1/13/25.
//

import SwiftUI
import Kingfisher

struct PokemonDetailView: View {
    @StateObject private var viewModel = DetailViewModel()
    let pokemonNumber: Int
    
    var body: some View {
        ZStack {
            Color(uiColor: .mainRed)
                .ignoresSafeArea()
            
            VStack {
                VStack(spacing: 10) {
                    if viewModel.pokemonDetail.number == 0 {
                        ProgressView()
                            .frame(width: 200, height: 200)
                            .foregroundStyle(.white)
                    } else {
                        KFImage(Endpoint.pokemonThumbnail(pokemonId: viewModel.pokemonDetail.number))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        
                        Group {
                            Text("No. \(viewModel.pokemonDetail.number) \(viewModel.pokemonDetail.name)")
                                .font(.system(size: 28, weight: .bold))
                            
                            Text("타입: \(viewModel.pokemonDetail.type)")
                            
                            Text("키: \(viewModel.pokemonDetail.height.formatted())")
                            
                            Text("몸무게: \(viewModel.pokemonDetail.weight.formatted())")
                        }
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.white)
                    }
                }
                .padding(.vertical, 32)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(uiColor: .darkRed))
                        .padding(.horizontal, 32)
                }
                .padding(.top, 16)
                Spacer()
            }
        }
        .onAppear {
            viewModel.onAppear(with: pokemonNumber)
        }
    }
}

#Preview {
    PokemonDetailView(pokemonNumber: 0)
}

#Preview {
    PokemonDetailView(pokemonNumber: 54)
}
