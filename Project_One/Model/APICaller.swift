//
//  APICaller.swift
//  Project_One
//
//  Created by Marco Worni on 18.11.2024.
//

import SwiftUI

func downloadArticles() async throws -> [Article] {
    let apiKey = "bc249c07a5434976a849acb7b9226767"
    let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)"
    
    guard let url = URL(string: urlString) else {
        print("Error: could not create URL from String \(urlString)")
        throw URLError(.badURL)
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let newsAPIResponse = try decoder.decode(NewsAPIResponse.self, from: data)
        
        return newsAPIResponse.articles
    } catch {
        throw error
    }
}
