//
//  CharacterDetailView.swift
//  Rick and Morty Code Challenge
//
//  Created by Cristian Perez on 2/5/25.
//
import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    @State private var isLandscape = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ScrollView {
                    contentLayout(for: geometry.size)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .navigationTitle(character.name)
                .onAppear { updateOrientation(geometry.size) }
                .onChange(of: geometry.size) {
                    updateOrientation(geometry.size) 
                }
            }
        }
    }
    
    private func updateOrientation(_ size: CGSize) {
        isLandscape = size.width > size.height
    }
    
    @ViewBuilder
    private func contentLayout(for size: CGSize) -> some View {
        if isLandscape {
            HStack(alignment: .top, spacing: 16) {
                imageSection
                    .frame(width: size.width * 0.45)
                detailsSection
                    .frame(width: size.width * 0.45)
            }
            .frame(maxWidth: .infinity)
        } else {
            VStack(spacing: 16) {
                imageSection
                detailsSection
            }
        }
    }
    
    private var imageSection: some View {
        GeometryReader { proxy in
            AsyncImage(url: URL(string: character.image)) { phase in
                if let image = phase.image {
                    image.resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                } else if phase.error != nil {
                    Color.gray
                        .overlay(
                            Text("Image unavailable")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        )
                        .cornerRadius(12)
                } else {
                    ProgressView()
                        .frame(height: proxy.size.height)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {            
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(title: "Species", value: character.species)
                InfoRow(title: "Status", value: character.status)
                InfoRow(title: "Origin", value: character.origin.name)
                
                if !character.type.isEmpty {
                    InfoRow(title: "Type", value: character.type)
                }
                
                InfoRow(title: "Created", value: character.formattedDate)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.body)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview("Portrait", traits: .portrait) {
    CharacterDetailView(character: Character.mock)
}

#Preview("Landscape", traits: .landscapeRight) {
    CharacterDetailView(character: Character.mock)
}
