//
//  CharactersViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Руслан Забиран on 29.08.24.
//

import XCTest
import Combine
@testable import RickAndMortyApp

final class CharactersViewModelTests: XCTestCase {

    private var sut: CharactersViewModelProtocol!
    private var input: PassthroughSubject<CharactersViewModel.Input, Never>!
    private var outputFlow: [CharactersViewModel.Output]!
    private var expectedOutputFlow: [CharactersViewModel.Output]!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let dependencies = DependenciesMock()
        sut = CharactersViewModel(dependencies)
        input = PassthroughSubject<CharactersViewModel.Input, Never>.init()
        outputFlow = [CharactersViewModel.Output]()
        expectedOutputFlow = [CharactersViewModel.Output]()
    }

    override func tearDownWithError() throws {
        sut = nil
        input = nil
        outputFlow = nil
        expectedOutputFlow = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }

    func testFetchBaseCharactersOnViewDidLoad() throws {
        // Given
        let output = sut.transform(input: input.eraseToAnyPublisher())
        let expectation = expectation(description: "Fetch base characters called")
        
        output
            .sink { [weak self] output in
                self?.outputFlow.append(output)
                if self?.outputFlow.count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        // When
        input.send(.viewDidLoad)
        
        // Then
        expectedOutputFlow.append(.loadBaseCharacters(isLoading: true))
        expectedOutputFlow.append(.loadBaseCharacters(isLoading: false))
        expectedOutputFlow.append(.fetchBaseCharactersSucceed(characters: [], nextPageUrl: nil))
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(expectedOutputFlow.count, outputFlow.count)
    }

    func testPaginationRequestCalledSuccessfully() throws {
        // Given
        let output = sut.transform(input: input.eraseToAnyPublisher())
        let expectation = expectation(description: "Pagination request called successfully")
        
        // When
        output
            .sink { [weak self] output in
                self?.outputFlow.append(output)
                if self?.outputFlow.count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        input.send(.paginationRequest(nextPageUrl: "some url"))
        
        // Then
        expectedOutputFlow.append(.loadNextPage(isLoading: true))
        expectedOutputFlow.append(.loadNextPage(isLoading: false))
        expectedOutputFlow.append(.fetchNextPageDidSucceed(characters: [], nextPageUrl: nil))
        
        waitForExpectations(timeout: 0.5)
        XCTAssertEqual(expectedOutputFlow.count, outputFlow.count)
    }
    
    func testPaginationRequestCalledFailure() throws {
        // Given
        let output = sut.transform(input: input.eraseToAnyPublisher())
        let expectation = expectation(description: "Pagination request called with failure")
        
        // When
        output
            .sink { [weak self] output in
                self?.outputFlow.append(output)
                if self?.outputFlow.count == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        input.send(.paginationRequest(nextPageUrl: nil))
        
        // Then
        expectedOutputFlow.append(.loadNextPage(isLoading: false))
        
        waitForExpectations(timeout: 0.5)
        XCTAssertEqual(expectedOutputFlow.count, outputFlow.count)
        
    }
    
    func testSearchRequestSucceed() {
        // Given
        let output = sut.transform(input: input.eraseToAnyPublisher())
        let expectation = expectation(description: "Search request called sucessfully")
        
        // When
        output
            .sink { [weak self] output in
                self?.outputFlow.append(output)
                if self?.outputFlow.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        input.send(.searchRequest(searchString: "character"))
        
        // Then
        expectedOutputFlow.append(.loadCharactersByName(isLoading: false))
        expectedOutputFlow.append(.fetchCharactersByNameSucceed(characters: [], nextPageUrl: nil))
        
        waitForExpectations(timeout: 0.5)
        XCTAssertEqual(expectedOutputFlow.count, outputFlow.count)
    }
    
    func testSearchRequestWithEmptyField() {
        // Given
        let output = sut.transform(input: input.eraseToAnyPublisher())
        let expectation = expectation(description: "Search request called with empty string")
        
        // When
        output
            .sink { [weak self] output in
                self?.outputFlow.append(output)
                if self?.outputFlow.count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        input.send(.searchRequest(searchString: ""))
        
        // Then
        expectedOutputFlow.append(.loadBaseCharacters(isLoading: true))
        expectedOutputFlow.append(.loadBaseCharacters(isLoading: false))
        expectedOutputFlow.append(.fetchBaseCharactersSucceed(characters: [], nextPageUrl: nil))
        
        waitForExpectations(timeout: 0.5)
        XCTAssertEqual(expectedOutputFlow.count, outputFlow.count)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
