//
//  PokemonThumbnailCell.swift
//  Pokedex
//
//  Created by 권승용 on 1/2/25.
//

import UIKit
import SnapKit
import Kingfisher

final class PokemonThumbnailCell: UICollectionViewCell {
    static let identifier = "PokemonThumbnailCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    private func configureUI() {
        backgroundColor = .cellBackground
        layer.cornerRadius = 8
        clipsToBounds = true
        
        [
            imageView
        ].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureCell(with url: URL) {
        imageView.kf.setImage(
            with: url,
            options: [.cacheMemoryOnly]
        )
    }
}
