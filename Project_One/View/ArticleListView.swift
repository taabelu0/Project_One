//
//  ArticleListView.swift
//  Project_One
//
//  Created by Marco Worni on 18.11.2024.
//

import SwiftUI

struct ArticleListView: View {
    @ObservedObject var viewController: ArticleViewController
    
    var body: some View {
        NavigationView {
            List(viewController.articles) { article in
                NavigationLink(
                    destination: ArticleDetailView(article: article, viewController: viewController)) {
                        HStack(spacing: 10) {
                            AsyncImage(url: viewController.makeImageURL(from: article)) { image in image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipped()
                            }
                            placeholder: {
                                Rectangle()
                                    .fill(Color.primary.opacity(0.1))
                                    .frame(width: 150, height: 150)
                            }
                    
                            VStack(alignment: .leading, spacing: 10) {
                                Text(article.title)
                                    .font(.headline)
                                    .lineLimit(2)
                        
                                Text("By \(article.author?.isEmpty == false ? article.author! : "Unknown Author")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                        
                                Text(article.publishedAt, style: .date)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 5))
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10))
            }
            .listRowSpacing(5)
            .navigationTitle("Articles")
            .refreshable {
                await viewController.refreshArticles()
            }
            .animation(.default, value: viewController.articles)
        }
        if (viewController.articles.isEmpty) {
            ProgressView()
                .controlSize(.large)
        }
    }
}

#Preview {
    ContentView()
}
