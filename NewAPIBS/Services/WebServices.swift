//
//  WebServices.swift
//  NewAPIBS
//
//  Created by Humayun Kabir on 11/3/25.
//

import Foundation

// MARK: - WebService Protocol
protocol WebServiceProtocol {
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void)
}

// MARK: - WebService Implementation
class WebService: WebServiceProtocol {
    private let urlString = "https://newsapi.org/v2/everything?q=apple&from=2025-02-19&to=2025-02-19&sortBy=popularity&apiKey=abf87ad1f7714eaab23219ba55cf199f"
    
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(Welcome.self, from: data)
                completion(.success(response.articles))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

// MARK: - Network Errors
enum NetworkError: Error {
    case invalidURL
    case noData
}
