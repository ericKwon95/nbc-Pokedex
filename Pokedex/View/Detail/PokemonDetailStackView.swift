//
//  PokemonDetailStackView.swift
//  Pokedex
//
//  Created by 권승용 on 1/4/25.
//

import UIKit
import SnapKit

final class PokemonDetailStackView: UIStackView {
    // MARK: - View Property
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            nameLabel,
            typeLabel,
            heightLabel,
            weightLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.backgroundColor = .darkRed
        stackView.layer.cornerRadius = 12
        stackView.clipsToBounds = true
        return stackView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configureUI() {
        [
            stackView
        ].forEach { addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 200, height: 200))
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.layoutMargins = .init(top: 32, left: 0, bottom: 32, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    func setup(with detail: PokemonDetail) {
        guard let thumbnailUrl = Endpoint.pokemonThumbnail(pokemonId: detail.number) else {
            print("url 생성 실패")
            return
        }
        imageView.kf.setImage(
            with: thumbnailUrl,
            options: [.cacheMemoryOnly]
        )
        nameLabel.text = "No.\(detail.number) \(detail.name)"
        typeLabel.text = "타입: \(detail.type)"
        heightLabel.text = "키: \(detail.height) m"
        weightLabel.text = "몸무게: \(detail.weight) kg"
    }
}
