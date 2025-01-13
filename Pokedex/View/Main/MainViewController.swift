//
//  MainViewController.swift
//  Pokedex
//
//  Created by 권승용 on 12/27/24.
//

import UIKit
import RxSwift
import SnapKit

enum Section: CaseIterable {
    case main
}

final class MainViewController: UIViewController {
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    private var pokemonThumbnails = [PokemonThumbnail]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, PokemonThumbnail>!
    
    // MARK: - View Property
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCompositionalLayout())
        collectionView.backgroundColor = .mainRed
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureDataSource()
        configureDelegates()
        configureUI()
        viewModel.viewDidLoad()
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
            .subscribe { [weak self] pokemonThumbnails in
                guard let self else { return }
                self.pokemonThumbnails += pokemonThumbnails
                self.applySnapshot(with: self.pokemonThumbnails)
            }
            .disposed(by: disposeBag)
        
        viewModel.errorStringRelay
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] error in
                self?.showAlert(message: error)
            }
            .disposed(by: disposeBag)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "오류가 발생했습니다!",
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "확인",
            style: .default
        )
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - Configuration & Layout

private extension MainViewController {
    func configureDelegates() {
        collectionView.delegate = self
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
    
    func createCellRegistration() -> UICollectionView.CellRegistration<PokemonThumbnailCell, PokemonThumbnail> {
        UICollectionView.CellRegistration<PokemonThumbnailCell, PokemonThumbnail> { (cell, indexPath, item) in
            cell.configureCell(with: item.thumbnailUrl)
        }
    }
    
    func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<PokeBallHeader> {
        UICollectionView.SupplementaryRegistration<PokeBallHeader>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
        }
    }
    
    func configureDataSource() {
        let cellRegistration = createCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, PokemonThumbnail>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: PokemonThumbnail) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        let headerRegistration = createHeaderRegistration()
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    func applySnapshot(with list: [PokemonThumbnail]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PokemonThumbnail>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(list)
        
        dataSource.apply(snapshot, animatingDifferences: true)
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

// MARK: - Delegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newVC = PokemonDetailHostingController(pokemonNumber: pokemonThumbnails[indexPath.row].number)
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            viewModel.scrollEndReached()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
