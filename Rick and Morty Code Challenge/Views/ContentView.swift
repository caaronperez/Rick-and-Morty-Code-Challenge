//
//  ContentView.swift
//  Rick and Morty Code Challenge
//
//  Created by Cristian Perez on 2/5/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CharacterViewModel()
        
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                searchBar
                resultsCaption
                charactersList
            }
            .navigationTitle("Rick & Morty")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
    
    private var searchBar: some View {
        SearchBar(text: $viewModel.searchText)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
    }
    
    private var resultsCaption: some View {
        if viewModel.searchText.isEmpty { 
            Text("Displaying main characters")
                .font(.caption)
                .foregroundColor(.secondary) 
                .padding()
        } else if viewModel.isLoading { 
            Text("Loading...")
                .font(.caption)
                .foregroundColor(.secondary) 
                .padding()
        } else {
            Text("Results from your search:")
                .font(.caption)
                .foregroundColor(.secondary) 
                .padding()
        }
    }
    
    private var charactersList: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Error: \(error)")
                        .frame(maxHeight: .infinity)
                }
            } else {
                List(viewModel.characters) { character in
                    NavigationLink {
                        CharacterDetailView(character: character)
                    } label: {
                        CharacterRow(character: character)
                    }
                }
                .listStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
                .accessibilityHidden(true)
            
            TextField("Search", text: $text)
                .padding(.vertical, 8)
                .padding(.trailing, 8)
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Click to search more characters")
        .accessibilityAddTraits(.isSearchField)
    }
}

#Preview {
    ContentView(viewModel: {
        let vm = CharacterViewModel()
        vm.characters = Character.mocks
        return vm
    }())
}
