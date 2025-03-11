//
//  ViewController.swift
//  NewAPIBS
//
//  Created by Humayun Kabir on 11/3/25.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Initializers
    private let titleLabel = UILabel()
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let viewModel = NewsViewModel(webService: WebService())
    private let tableViewCellIdentifier = "NewsExplorerCell"
    
    // MARK: - View Update
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        checkInternetConnection { isConnected in
            if isConnected {
                self.setupBindings()
                self.viewModel.fetchArticles()
            }else{
                self.showNoInternetAlert()
            }
        }
    }
    
    // MARK: - Setup UI
    private func setupSubViews() {
        view.backgroundColor = .darkGray
        
        //Configure title label
        titleLabel.text = "News Explorer"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure Search Bar
        searchBar.placeholder = "search by– author:"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        showActivityIndicator()
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableView DataSource & Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! NewsTableViewCell
        let article = viewModel.filteredArticles[indexPath.row]
        cell.configure(with: article)
        return cell
    }
}

// MARK: - UISearchBar Delegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchArticles(by: searchText)
    }
}

