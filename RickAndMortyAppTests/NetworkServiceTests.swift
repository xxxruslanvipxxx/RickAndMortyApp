//
//  RickAndMortyAppTests.swift
//  RickAndMortyAppTests
//
//  Created by Руслан Забиран on 27.08.24.
//

import XCTest
import Combine
@testable import RickAndMortyApp

final class NetworkServiceTests: XCTestCase {

    private var sut: NetworkServiceMock?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkServiceMock()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testSuccessCharacterRequest() throws {
        // given
        let givenValue = CharactersResult(info: Info(count: 1, pages: 1, next: nil, prev: nil), results: [])
        sut?.character = givenValue
        var result: CharactersResult?
        let expectation = self.expectation(description: "Awaiting publisher")
        // when
        let _ = sut?.request(for: CharactersResult.self, url: "Some URL")
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { value in
                result = value
            })
        // then
        waitForExpectations(timeout: 0.2)
        XCTAssertNotNil(result)
        XCTAssertEqual(givenValue.info.count, result?.info.count)
    }
    
    func testSuccessEpisodeRequest() throws {
        // given
        let givenValue = Episode(id: 1, name: "Test", airDate: "", episode: "", characters: [], url: "", created: "")
        sut?.episode = givenValue
        var result: Episode?
        let expectation = self.expectation(description: "Awaiting publisher")
        // when
        let _ = sut?.request(for: Episode.self, url: "Some URL")
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { value in
                result = value
            })
        // then
        waitForExpectations(timeout: 0.2)
        XCTAssertNotNil(result)
        XCTAssertEqual(givenValue.name, result?.name)
    }
    
    func testFailureCharacterRequest() throws {
        // given
        let givenValue: CharactersResult? = nil
        sut?.character = givenValue
        var result: CharactersResult?
        let expectation = self.expectation(description: "Awaiting publisher")
        // when
        let _ = sut?.request(for: CharactersResult.self, url: "Some URL")
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { value in
                result = value
            })
        // then
        waitForExpectations(timeout: 0.2)
        XCTAssertNil(result)
    }
    
    func testFailureEpisodeRequest() throws {
        // given
        let givenValue: Episode? = nil
        sut?.episode = givenValue
        var result: Episode?
        let expectation = self.expectation(description: "Awaiting publisher")
        // when
        let _ = sut?.request(for: Episode.self, url: "Some URL")
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { value in
                result = value
            })
        // then
        waitForExpectations(timeout: 0.2)
        XCTAssertNil(result)
    }
    
    func testSuccessLoadImageData() {
        // given
        let character = Character(id: 1, name: "Test", status: .unknown, species: "", type: "", gender: .unknown, origin: .init(name: "", url: ""), location: .init(name: "", url: ""), image: "https://thispersondoesnotexist.com", episode: [], url: "", created: "")
        var result: Data?
        let expectation = self.expectation(description: "Awaiting publisher")
        // when
        let _ = sut?.loadImageData(for: character)
            .sink(receiveValue: { data in
                result = data
                expectation.fulfill()
            })
        //then
        waitForExpectations(timeout: 0.2)
        XCTAssertNotNil(result)
    }
    
    func testFailureLoadImageData() {
        // given
        let character = Character(id: 1, name: "Test", status: .unknown, species: "", type: "", gender: .unknown, origin: .init(name: "", url: ""), location: .init(name: "", url: ""), image: "", episode: [], url: "", created: "")
        var result: Data?
        let expectation = self.expectation(description: "Awaiting publisher")
        // when
        let _ = sut?.loadImageData(for: character)
            .sink(receiveValue: { data in
                result = data
                expectation.fulfill()
            })
        //then
        waitForExpectations(timeout: 0.2)
        XCTAssertNil(result)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
