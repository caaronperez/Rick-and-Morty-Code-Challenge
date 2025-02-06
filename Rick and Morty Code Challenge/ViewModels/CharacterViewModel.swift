//
//  CharacterViewModel.swift
//  Rick and Morty Code Challenge
//
//  Created by Cristian Tejeda on 2/5/25.
//
import Foundation
import Combine

@MainActor
class CharacterViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var searchTask: Task<Void, Never>?
    
    init() {
        $searchText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.searchCharacters()
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func searchCharacters() {
            searchTask?.cancel()
            searchTask = Task {
                
//                Instructions didn't mention, but in case we want to show only characters when user types in search field the next
//                validation shows empty view at the beggining, otherwise the API returns the main characters when nothing is sent
//
//                guard !searchText.isEmpty else {
//                    await MainActor.run {
//                        characters = []
//                        isLoading = false
//                        errorMessage = nil
//                    }
//                    return
//                }
                
                isLoading = true
                errorMessage = nil
                defer { isLoading = false }
                
                do {
                    characters = try await NetworkManager.shared.fetchCharacters(name: searchText)
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }
}
