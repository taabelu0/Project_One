//
//  Article.swift
//  Project_One
//
//  Created by Marco Worni on 18.11.2024.
//

import SwiftUI

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
