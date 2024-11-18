//
//  NewsAPIResponse.swift
//  Project_One
//
//  Created by Marco Worni on 18.11.2024.
//

struct NewsAPIResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
