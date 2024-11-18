//
//  ArticleViewController.swift
//  Project_One
//
//  Created by Marco Worni on 18.11.2024.
//

import Foundation
import SwiftUI

class ArticleViewController: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Laden der Artikel
    func loadArticles() async {
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            self.articles = try await downloadArticles()
        } catch {
            self.errorMessage = "Error loading articles: \(error.localizedDescription)"
        }
        
        self.isLoading = false
    }
    
    func refreshArticles() async {
        do {
            articles = try await loadArticles()
        } catch let urlError as URLError {
            print("URL Error: \(urlError)")
        } catch let decodingError as DecodingError {
            print("Decoding Error: \(decodingError.localizedDescription): \(decodingError)")
        } catch {
            print("An unexpected error occurred: " + error.localizedDescription)
        }
    }
    
    func makeImageURL(from article: Article) -> URL? {
        guard let urlToImage = article.urlToImage else { return nil }
        return URL(string: urlToImage)
    }
    
    func openWebsite(articleURL: String) {
        if let url = URL(string: articleURL) {
                UIApplication.shared.open(url)
        }
    }

}
