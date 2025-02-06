//
//  NetworkManager.swift
//  Rick and Morty Code Challenge
//
//  Created by Cristian Tejeda on 2/5/25.
//
import Foundation

// NetworkManager.swift
class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchCharacters(name: String) async throws -> [Character] {
        let query = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://rickandmortyapi.com/api/character/?name=\(query)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            let decodedResponse = try JSONDecoder().decode(CharacterResponse.self, from: data)
            return decodedResponse.results
        case 404:
            return []
        default:
            throw URLError(.badServerResponse)
        }
    }
}

