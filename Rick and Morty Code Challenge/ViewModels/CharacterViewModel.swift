//
//  CharacterViewModel.swift
//  Rick and Morty Code Challenge
//
//  Created by Cristian Perez on 2/5/25.
//
import Foundation
import Combine

@MainActor
class CharacterViewModel: ObservableObject {
    private let networkService: NetworkService
    private var searchTask: Task<Void, Never>?
    
    @Published var searchText = ""
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // DI Initializer
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkService = networkService
        setupSearchPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func setupSearchPublisher() {
        $searchText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { [weak self] in
                    await self?.performSearch()
                }
            }
            .store(in: &cancellables)
    }
    
    func performSearch() async {
        searchTask?.cancel()
        searchTask = Task {
            await handleSearchExecution()
        }
        await searchTask?.value
    }

    private func handleSearchExecution() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let results = try await networkService.fetchCharacters(name: searchText)
            characters = results
        } catch {
            errorMessage = error.localizedDescription
            characters = []
        }
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        characters = []
    }
}
