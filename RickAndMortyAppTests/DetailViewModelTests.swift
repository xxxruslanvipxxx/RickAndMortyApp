//
//  DetailViewModelTests.swift
//  RickAndMortyAppTests
//
//  Created by Руслан Забиран on 30.08.24.
//

import XCTest
import Combine
@testable import RickAndMortyApp

final class DetailViewModelTests: XCTestCase {

    private var sut: DetailViewModel!
    private var input: PassthroughSubject<DetailViewModel.Input, Never>!
    private var outputFlow: [DetailViewModel.Output]!
    private var expectedOutputFlow: [DetailViewModel.Output]!
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
                              episode: [],
                              url: "test url",
                              created: "test")
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let dependencies = DependenciesMock()
        sut = DetailViewModel(dependencies, character: character)
        input = PassthroughSubject<DetailViewModel.Input, Never>.init()
        outputFlow = [DetailViewModel.Output]()
        expectedOutputFlow = [DetailViewModel.Output]()
    }

    override func tearDownWithError() throws {
        sut = nil
        input = nil
        outputFlow = nil
        expectedOutputFlow = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }

    func testViewDidLoad() throws {
        // Given
        let output = sut.transform(input: (input.eraseToAnyPublisher()))
        let stubData = Data()
        let expectation = expectation(description: "viewDidLoad called")
        
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
        expectedOutputFlow.append(.updateCharacterInfo(character: character))
        expectedOutputFlow.append(.fetchCharacterImage(isLoading: true))
        expectedOutputFlow.append(.fetchCharacterImage(isLoading: false))
        expectedOutputFlow.append(.updateImage(imageData: stubData))
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(expectedOutputFlow.count, outputFlow.count)
    }
    
    func testChangePhotoWithCamera() {
        // Given
        let output = sut.transform(input: (input.eraseToAnyPublisher()))
        let photoSourceType = DetailViewModel.PhotoSourceType.camera
        let expectation = expectation(description: "ChangePhotoWithCamer")
        
        output
            .sink { [weak self] output in
                self?.outputFlow.append(output)
                if self?.outputFlow.count == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        // When
        input.send(.changePhoto(sourceType: photoSourceType))
        
        // Then
        expectedOutputFlow.append(.showCamera)
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(expectedOutputFlow.count, outputFlow.count)
    }
    
    func testChangePhotoWithPhotoLibrary() {
        // Given
        let output = sut.transform(input: (input.eraseToAnyPublisher()))
        let photoSourceType = DetailViewModel.PhotoSourceType.photoLibrary
        let expectation = expectation(description: "ChangePhotoWithPhotoLibrary")
        
        output
            .sink { [weak self] output in
                self?.outputFlow.append(output)
                if self?.outputFlow.count == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        input.send(.changePhoto(sourceType: photoSourceType))
        
        // Then
        expectedOutputFlow.append(.showPhotoLibrary)
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(expectedOutputFlow.count, outputFlow.count)    }

}
