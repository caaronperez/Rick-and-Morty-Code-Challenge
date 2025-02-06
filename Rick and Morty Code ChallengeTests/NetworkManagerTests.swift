//
//  NetworkManagerTests.swift
//  Rick and Morty Code Challenge
//
//  Created by Cristian Perez on 2/6/25.
//
import XCTest
@testable import Rick_and_Morty_Code_Challenge

@MainActor
final class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    var urlSession: URLSession!
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        networkManager = NetworkManager()
    }
    
    func testSuccessfulResponse() async {
        // Setup mock response
        let data = try! JSONEncoder().encode(CharacterResponse(
            info: PaginationInfo(count: 1, pages: 1, next: nil, prev: nil),
            results: Character.mocks
        ))
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        
        // Test
        do {
            let results = try await networkManager.fetchCharacters(name: "Rick")
            XCTAssertEqual(results.count, 20)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

// URLProtocol mock
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("No handler set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
