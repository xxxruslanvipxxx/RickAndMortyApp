//
//  FavoritesViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Руслан Забиран on 1.09.24.
//

import XCTest
import Combine
@testable import RickAndMortyApp

final class FavoritesViewModelTests: XCTestCase {

    private var sut: FavoritesViewModel!
    private var input: PassthroughSubject<FavoritesViewModel.Input, Never>!
    private var outputFlow: [FavoritesViewModel.Output]!
    private var expectedOutputFlow: [FavoritesViewModel.Output]!
    private var cancellables = Set<AnyCancellable>()
    
    let character = Character(id: 1,
                              name: "Test character",
                              status: Status.unknown,
                              species: "Test species",
                              type: "Test type",
                              gender: Gender.unknown,
                              origin: Location(name: "test", url: "test"),
                              location: Location(name: "test", url: "test"),
                              image: "test image",
                              episode: ["some url"],
                              url: "test url",
                              created: "test")
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let dependencies = DependenciesMock()
        sut = FavoritesViewModel(dependencies)
        input = .init()
        outputFlow = [FavoritesViewModel.Output]()
        expectedOutputFlow = [FavoritesViewModel.Output]()
    }

    override func tearDownWithError() throws {
        sut = nil
        input = nil
        outputFlow = nil
        expectedOutputFlow = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }


    func testFetchFavorites() throws {
        // Given
        let output = sut.transform(input: (input.eraseToAnyPublisher()))
        let expectation = expectation(description: "FetchFavorites")
        
        output
            .sink { [weak self] output in
                self?.outputFlow.append(output)
                if self?.outputFlow.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        // When
        input.send(.fetchFavorites)
        
        // Then
        expectedOutputFlow.append(.fetchCompleted(isCompleted: false))
        expectedOutputFlow.append(.fetchCompleted(isCompleted: true))
        expectedOutputFlow.append(.favoritesFetched(characters: [character]))
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(expectedOutputFlow.count, outputFlow.count)
    }

}
