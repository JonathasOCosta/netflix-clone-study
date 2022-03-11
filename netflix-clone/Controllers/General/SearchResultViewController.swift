//
//  SearchResultViewController.swift
//  netflix-clone
//
//  Created by user210401 on 3/10/22.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {

    public var titles: [Titles] = [Titles]()
    
    public weak var delegate: SearchResultViewControllerDelegate?
    
    public let searchResultsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.indentifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }

}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.indentifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        let titleName = title.original_title ?? ""
        
        APICaller.shared.getMovie(with: titleName){ [weak self] result in
            switch result {
            case .success(let videoElement):
                
                self?.delegate?.searchResultViewControllerDidTapItem(TitlePreviewViewModel(title: title.original_title ?? "", youtubeView: videoElement, titleOverView: title.overview ?? ""))
                
            case .failure(let error):
                print(error)
            }
        }
        
        
        
    }
}
