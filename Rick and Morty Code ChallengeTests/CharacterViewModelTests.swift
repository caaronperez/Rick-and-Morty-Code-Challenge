//
//  CharacterViewModelTests.swift
//  Rick and Morty Code Challenge
//
//  Created by Cristian Perez on 2/6/25.
//


import XCTest
import Combine
@testable import Rick_and_Morty_Code_Challenge

@MainActor
final class CharacterViewModelTests: XCTestCase {
    var viewModel: CharacterViewModel!
    var mockService: MockNetworkService!
    
    override func setUp() async throws {
            mockService = MockNetworkService()
            viewModel = CharacterViewModel(networkService: mockService)
        }
    
    func testCharacterEquality() {
        let character1 = Character.mock
        let character2 = Character.mock
        XCTAssertEqual(character1, character2)
    }
        
    func testSuccessfulSearch() async {
        // GIVEN
        let expectedCharacters = [Character.mock]
        mockService.result = .success(expectedCharacters)
        
        // WHEN
        viewModel.searchText = "Rick"
        await viewModel.performSearch() // No delay needed
        
        // THEN
        XCTAssertEqual(viewModel.characters, expectedCharacters)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testErrorHandling() async {
        // GIVEN
        let expectedError = URLError(.notConnectedToInternet)
        mockService.result = .failure(expectedError) // Now affects ViewModel's service
        
        // WHEN
        viewModel.searchText = "Invalid"
        await viewModel.performSearch()
        
        // THEN
        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, expectedError.localizedDescription)
        XCTAssertFalse(viewModel.isLoading)
    }


    func testEmptySearchCancellation() async {
        // GIVEN
        viewModel.searchText = ""
        mockService.result = .success([])
        
        // WHEN
        await viewModel.performSearch()
        
        // THEN
        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }
}
