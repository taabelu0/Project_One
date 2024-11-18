//
//  ContentView.swift
//  Project_One
//
//  Created by Luca Bertonazzi on 13.10.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewController = ArticleViewController()  // ViewModel wird hier instanziiert
    
    var body: some View {
        ArticleListView(viewController: viewController)
        .padding(0)
    }
}

#Preview {
    ContentView()
}
