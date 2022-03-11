//
//  SearchViewController.swift
//  netflix-clone
//
//  Created by user210401 on 3/8/22.
//

import UIKit

class SearchViewController: UIViewController {

    
    private var titles: [Titles] = [Titles]()
    
    private let discoverTable: UITableView = {
       
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
        
    }()
    
    private let seacrhController: UISearchController = {
        
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Procure seus Filmes e Series"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Descobrir"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = seacrhController
        
        navigationController?.navigationBar.tintColor = .white 
        fetchDiscoverMovies()
        
        seacrhController.searchResultsUpdater = self
    }
    
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { results in
            
            switch results {
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        discoverTable.frame = view.bounds
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "Unkown name", posterURL: title.poster_path ?? "Unkwon")
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        APICaller.shared.getMovie(with: titleName){ [weak self] result in
            switch result {
            case .success(let videoElement):
                
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverView: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension SearchViewController: UISearchResultsUpdating, SearchResultViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
                query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else { return }
    
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
}
