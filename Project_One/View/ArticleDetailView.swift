//
//  ArticleDetailView.swift
//  Project_One
//
//  Created by Marco Worni on 18.11.2024.
//
import SwiftUI

struct ArticleDetailView: View {
    var article: Article
    @ObservedObject var viewController: ArticleViewController  // Verwende @ObservedObject, um auf das gleiche ViewModel zuzugreifen
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                Text(article.title)
                    .font(.title)
                    .bold()
                
                Text("By \(article.author ?? "Unknown")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                AsyncImage(url: viewController.makeImageURL(from: article)) { image in
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
                .cornerRadius(10)
                
                HStack {
                    Text(article.source.name)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(article.publishedAt, style: .date)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Text(article.description ?? "Unknown")
                    .font(.body)
                
            }
            .padding()
        }
        .navigationTitle("Article")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewController.openWebsite(articleURL: article.url)
                }) {
                    Image(systemName: "safari")
                }
            }
        }
    }
}
