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

    private var sut: CharactersViewModel!
    private var dependencies: IDependencies!
    private var input: PassthroughSubject<CharactersViewModel.Input, Never>!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let dependencies = DependenciesMock()
        sut = CharactersViewModel(dependencies)
        input = PassthroughSubject<CharactersViewModel.Input, Never>.init()
    }

    override func tearDownWithError() throws {
        sut = nil
        dependencies = nil
        try super.tearDownWithError()
    }

    func testFetchBaseCharactersOnViewDidLoad() throws {
        // Given
        let output = sut.transform(input: input.eraseToAnyPublisher())
        var outputFlow = [CharactersViewModel.Output]()
        var expectedOutputFlow = [CharactersViewModel.Output]()
        let expectation = expectation(description: "Fetch base characters called")
        
        output
            .sink { output in
                outputFlow.append(output)
                if outputFlow.count == 3 {
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
        var outputFlow = [CharactersViewModel.Output]()
        var expectedOutputFlow = [CharactersViewModel.Output]()
        let expectation = expectation(description: "Pagination request called")
        
        // When
        output
            .sink { output in
                outputFlow.append(output)
                if outputFlow.count == 3 {
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
        var outputFlow = [CharactersViewModel.Output]()
        var expectedOutputFlow = [CharactersViewModel.Output]()
        let expectation = expectation(description: "Pagination request called")
        
        // When
        output
            .sink { output in
                outputFlow.append(output)
                if outputFlow.count == 1 {
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
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
