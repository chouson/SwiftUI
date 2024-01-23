//
//  ContentView.swift
//  CombineDemo
//
//  Created by Chouson on 2024/1/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView(content: {
            NavigationLink {
                LoginView(viewModel: .init())
            } label: {
                Text("Login")
            }
            .navigationTitle("Main View")
        })
    }
}

#Preview {
    ContentView()
}
