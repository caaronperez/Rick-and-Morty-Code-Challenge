//
//  NetworkManager.swift
//  Rick and Morty Code Challenge
//
//  Created by Cristian Perez on 2/5/25.
//
import Foundation

protocol NetworkService {
    func fetchCharacters(name: String) async throws -> [Character]
}

class NetworkManager: NetworkService {
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

class MockNetworkService: NetworkService {
    var result: Result<[Character], Error> = .success([])
    
    func fetchCharacters(name: String) async throws -> [Character] {
        try result.get()
    }
}

#if DEBUG
extension URLError {
    static let mock = URLError(.notConnectedToInternet)
}
#endif
