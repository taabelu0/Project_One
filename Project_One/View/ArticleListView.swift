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
                            AsyncImage(url: viewController.makeImageURL(from: article)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.primary.opacity(0.1))
                                    .frame(width: 100, height: 100)
                            }
                    
                            VStack(alignment: .leading, spacing: 5) {
                                Text(article.title)
                                    .font(.headline)
                                    .lineLimit(2)
                                    .frame(maxHeight: .infinity, alignment: .top)
                        
                                Text("By \(article.author?.isEmpty == false ? article.author! : "Unknown Author")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(maxHeight: .infinity, alignment: .top)
                        
                                Text(article.publishedAt, style: .date)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .frame(maxHeight: .infinity, alignment: .top)
                            }
                            .frame(height: 100)
                        }
                        .frame(height: 100)
                        .padding(.trailing, 5)
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
        .navigationViewStyle(StackNavigationViewStyle())
        if (viewController.articles.isEmpty) {
            ProgressView()
                .controlSize(.large)
        }
    }
}

#Preview {
    ContentView()
}
