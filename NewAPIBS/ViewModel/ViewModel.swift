//
//  ViewModel.swift
//  NewAPIBS
//
//  Created by Humayun Kabir on 11/3/25.
//

import Foundation

// MARK: - ViewModel Protocol
protocol NewsViewModelProtocol {
    var filteredArticles: [Article] { get }
    var onDataUpdated: (() -> Void)? { get set }
    
    func fetchArticles()
    func searchArticles(by author: String)
}

// MARK: - ViewModel Implementation
class NewsViewModel: NewsViewModelProtocol {
    private let webService: WebServiceProtocol
    private var allArticles: [Article] = []
    
    var filteredArticles: [Article] = []
    var onDataUpdated: (() -> Void)?
    
    init(webService: WebServiceProtocol) {
        self.webService = webService
    }
    
    func fetchArticles() {
        webService.fetchArticles { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    guard let self = self else { return }
                    self.allArticles = articles
                    self.filteredArticles = articles
                    self.onDataUpdated?()
                case .failure(let error):
                    print("Error fetching articles: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func searchArticles(by author: String) {
        if author.isEmpty {
            filteredArticles = allArticles
        } else {
            filteredArticles = allArticles.filter { $0.author?.lowercased().contains(author.lowercased()) ?? false }
        }
        onDataUpdated?()
    }
}

