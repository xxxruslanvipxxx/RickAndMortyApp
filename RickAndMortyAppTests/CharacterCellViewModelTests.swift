//
//  CharacterCellViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Руслан Забиран on 30.08.24.
//

import XCTest
import Combine
@testable import RickAndMortyApp

final class CharacterCellViewModelTests: XCTestCase {

    private var sut: CharacterCellViewModel!
    private var input: PassthroughSubject<CharacterCellViewModel.Input, Never>!
    private var outputFlow: [CharacterCellViewModel.Output]!
    private var expectedOutputFlow: [CharacterCellViewModel.Output]!
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
        sut = CharacterCellViewModel(character: character, dependencies: dependencies)
        input = .init()
        outputFlow = [CharacterCellViewModel.Output]()
        expectedOutputFlow = [CharacterCellViewModel.Output]()
    }

    override func tearDownWithError() throws {
        sut = nil
        input = nil
        outputFlow = nil
        expectedOutputFlow = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }

    func testConfigureCell() throws {
        // Given
        let output = sut.transform(input: (input.eraseToAnyPublisher()))
        let expectation = expectation(description: "Configure cell")
        
        output
            .sink { [weak self] output in
                self?.outputFlow.append(output)
                if self?.outputFlow.count == 4 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        // When
        input.send(.configureCell)
        
        // Then
        expectedOutputFlow.append(.configureImage(with: Data()))
        expectedOutputFlow.append(.configureName(with: "Test Name"))
        expectedOutputFlow.append(.configureEpisode(with: "Test Episode"))
        expectedOutputFlow.append(.configureIsFavorite(with: true))
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(expectedOutputFlow.count, outputFlow.count)
    }
    
    func testFavoriteButtonPressedWithTrue() {
        // Given
        let output = sut.transform(input: (input.eraseToAnyPublisher()))
        let expectation = expectation(description: "FavoriteButtonPressedWithTrue")
        let isFavourite = true
        
        output
            .sink { [weak self] output in
                self?.outputFlow.append(output)
            }
            .store(in: &cancellables)
        
        if outputFlow.count == 0 {
            expectation.fulfill()
        }
        // When
        input.send(.favoriteButtonPressed(isFavorite: isFavourite))
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertEqual(expectedOutputFlow.count, outputFlow.count)
    }
    
    func testFavoriteButtonPressedWithFalse() {
        // Given
        let output = sut.transform(input: (input.eraseToAnyPublisher()))
        let expectation = expectation(description: "FavoriteButtonPressedWithFalse")
        let isFavourite = false
        
        output
            .sink { [weak self] output in
                self?.outputFlow.append(output)
            }
            .store(in: &cancellables)
        
        if outputFlow.count == 0 {
            expectation.fulfill()
        }
        // When
        input.send(.favoriteButtonPressed(isFavorite: isFavourite))
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertEqual(expectedOutputFlow.count, outputFlow.count)
    }
    
    func testUpdateInFavoriteStatus() {
        // Given
        let output = sut.transform(input: (input.eraseToAnyPublisher()))
        let expectation = expectation(description: "UpdateInFavoriteStatus")
        let isFavourite = true
        
        output
            .sink { [weak self] output in
                self?.outputFlow.append(output)
                if self?.outputFlow.count == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        input.send(.updateInFavoriteStatus)
        
        // Then
        
        expectedOutputFlow.append(.configureIsFavorite(with: isFavourite))
        waitForExpectations(timeout: 1)
        XCTAssertEqual(expectedOutputFlow.count, outputFlow.count)
    }

}
