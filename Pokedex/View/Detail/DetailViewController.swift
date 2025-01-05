//
//  DetailViewController.swift
//  Pokedex
//
//  Created by 권승용 on 1/3/25.
//

import UIKit
import SnapKit
import RxSwift

final class DetailViewController: UIViewController {
    private let viewModel = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    private let pokemonNumber: Int

    // MARK: - View Property
    
    private let pokemonDetailView = PokemonDetailStackView()
    
    // MARK: - Initializer

    init(pokemonNumber: Int) {
        self.pokemonNumber = pokemonNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        viewModel.fetchPokemonDetail(from: pokemonNumber)
    }
    
    // MARK: - Configuration
    
    private func configureUI() {
        view.backgroundColor = .mainRed
        [
            pokemonDetailView
        ].forEach { view.addSubview($0) }
        
        pokemonDetailView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.height.lessThanOrEqualTo(400)
        }
    }
    
    // MARK: - Binding
    
    private func bind() {
        viewModel.pokemonDetailRelay
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] pokemonDetail in
                self?.pokemonDetailView.setup(with: pokemonDetail)
            }
            .disposed(by: disposeBag)
        
        viewModel.errorRelay
            .observe(on: MainScheduler.instance)
            .subscribe { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
}

@available(iOS 17.0, *)
#Preview {
    DetailViewController(pokemonNumber: 1)
}
