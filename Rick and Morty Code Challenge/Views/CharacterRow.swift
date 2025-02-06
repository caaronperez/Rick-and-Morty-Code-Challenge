//
//  CharacterRow.swift
//  Rick and Morty Code Challenge
//
//  Created by Cristian Perez on 2/6/25.
//
import SwiftUI

struct CharacterRow: View {
    let character: Character
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: character.image)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .accessibilityAddTraits(.isImage)
            
            VStack(alignment: .leading) {
                Text(character.name).font(.headline)
                Text(character.species).foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
