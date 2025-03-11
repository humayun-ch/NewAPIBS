//
//  Model.swift
//  NewAPIBS
//
//  Created by Humayun Kabir on 11/3/25.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title, description: String
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String
}

// MARK: - Source
struct Source: Codable {
    let id: ID?
    let name: String
}

enum ID: String, Codable {
    case espn = "espn"
    case theVerge = "the-verge"
    case wired = "wired"
}


