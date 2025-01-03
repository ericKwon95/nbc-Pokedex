//
//  Monsterballheader.swift
//  Pokedex
//
//  Created by 권승용 on 1/3/25.
//

import UIKit
import SnapKit

final class PokeBallHeader: UICollectionReusableView {
    static let identifier = "PokeBallHeader"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .pokeBall)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [
            imageView
        ].forEach { addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
}
