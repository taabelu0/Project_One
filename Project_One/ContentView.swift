//
//  ContentView.swift
//  Project_One
//
//  Created by Luca Bertonazzi on 13.10.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var articles = [Article]()
    
    var body: some View {
        NavigationView {
            List(articles) { article in
                NavigationLink(
                    destination: ArticleDetailView(article: article)) {
                    HStack(spacing: 10) { // Spacing für Abstand zwischen Bild und Text
                        AsyncImage(url: makeImageURL(from: article)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 150)
                                .clipped()
                        } placeholder: {
                            Rectangle()
                                .fill(Color.primary.opacity(0.1))
                                .frame(width: 100, height: 150)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(article.title)
                                .font(.headline)
                                .lineLimit(2)
                            
                            Text("By \(article.author ?? "Unknown")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(article.publishedAt, style: .date)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }.padding(.init(
                        top: 0,
                        leading: 0,
                        bottom: 0,
                        trailing: 10))
                }
                .listRowInsets(.init(
                    top:0,
                    leading: 0,
                    bottom: 0,
                    trailing: 5))
            }
            .listRowSpacing(5)
            .navigationTitle("Articles")
            .refreshable {
                await refresh()
            }
            .task {
                await refresh()
            }
            .animation(.default, value: articles)
        }
        .padding(0)
       
    }
    
    func refresh() async {
        do {
            articles = try await downloadArticles()
        } catch let urlError as URLError {
            print("URL Error: \(urlError)")
        } catch let decodingError as DecodingError {
            print("Decoding Error: \(decodingError.localizedDescription): \(decodingError)")
        } catch {
            print("An unexpected error occurred: " + error.localizedDescription)
        }
    }
}


struct ArticleDetailView: View {
    var article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: makeImageURL(from: article)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(Color.primary.opacity(0.1))
                        .frame(height: 200)
                }
                
                Text(article.title)
                    .font(.title)
                    .bold()
                
                // Optional Binding für den Autor
                Text("By \(article.author ?? "Unknown")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(article.publishedAt, style: .date)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Text(article.description ?? "Unknown") // Assuming 'content' is a field in your Article model
                    .font(.body)
                
                if let url = URL(string: article.url) {
                            Link("Visit Apple", destination: url)
                        } else {
                            Text("Invalid URL")
                        }
            }
            .padding()
        }
    }
}



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

func makeImageURL(from article: Article) -> URL? {
    guard let urlToImage = article.urlToImage else { return nil }
    return URL(string: urlToImage)
}

struct NewsAPIResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Identifiable, Equatable, Decodable {
    var id: UUID { UUID() }
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
    
    struct Source: Decodable, Equatable {
        let id: String?
        let name: String
    }
}



#Preview {
    ContentView()
}
