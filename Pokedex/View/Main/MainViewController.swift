//
//  MainViewController.swift
//  Pokedex
//
//  Created by 권승용 on 12/27/24.
//

import UIKit
import RxSwift
import SnapKit

final class MainViewController: UIViewController {
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    private var pokemonThumbnails = [PokemonThumbnail]()
    
    private var isFetching = false
    
    // MARK: - View Property
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCompositionalLayout())
        collectionView.register(
            PokemonThumbnailCell.self,
            forCellWithReuseIdentifier: PokemonThumbnailCell.identifier
        )
        collectionView.register(
            PokeBallHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PokeBallHeader.identifier
        )
        collectionView.backgroundColor = .mainRed
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureDelegates()
        configureUI()
        viewModel.fetchPokemonList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Binding
    
    private func bind() {
        viewModel.pokemonListRelay
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] pokenmonThumbnails in
                self?.pokemonThumbnails = pokenmonThumbnails
                self?.collectionView.reloadData()
                self?.isFetching = false
            }
            .disposed(by: disposeBag)
        
        viewModel.errorRelay
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] error in
                print(error)
                self?.isFetching = false
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Configuration & Layout

private extension MainViewController {
    func configureDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureUI() {
        view.backgroundColor = .mainRed
        [
            collectionView
        ].forEach { view.addSubview($0) }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func makeCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.333),
            heightDimension: .fractionalWidth(0.333)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(60)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(120)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - DataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonThumbnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PokeBallHeader.identifier, for: indexPath) as? PokeBallHeader else {
                return UICollectionReusableView()
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonThumbnailCell.identifier, for: indexPath) as? PokemonThumbnailCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(with: pokemonThumbnails[indexPath.row].thumbnailUrl)
        return cell
    }
}

// MARK: - Delegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newVC = DetailViewController(pokemonNumber: pokemonThumbnails[indexPath.row].number)
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            if !isFetching {
                viewModel.fetchPokemonList()
                isFetching = true
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
