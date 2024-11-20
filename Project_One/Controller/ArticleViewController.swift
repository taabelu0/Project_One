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
    
    func loadArticles() async {
        do {
            let newArticles = try await downloadArticles()
            DispatchQueue.main.async {
                self.articles = newArticles
            }
        } catch let urlError as URLError {
            print("URL Error: \(urlError)")
        } catch let decodingError as DecodingError {
            print("Decoding Error: \(decodingError.localizedDescription): \(decodingError)")
        } catch {
            print("An unexpected error occurred: " + error.localizedDescription)
        }
    }
    
    func refreshArticles() async {
        await loadArticles()
    }
    
    /*
    func refresh() async {
        do {
            viewController = try await downloadArticles()
        } catch let urlError as URLError {
            print("URL Error: \(urlError)")
        } catch let decodingError as DecodingError {
            print("Decoding Error: \(decodingError.localizedDescription): \(decodingError)")
        } catch {
            print("An unexpected error occurred: " + error.localizedDescription)
        }
    }
     */
    
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
