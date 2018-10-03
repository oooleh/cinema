//
//  CodeChallengeTests.swift
//  CodeChallengeTests
//
//  Created by Oleh Kudinov on 01.10.18.
//

import XCTest
@testable import CodeChallenge

class CodeChallengeTests: XCTestCase {
    
    var moviesPages: [MoviesPage] {
        let page1 = MoviesPage(page: 1, totalPages: 2, movies: [
            Movie(id: 1, title: "title1", posterPath: "/1", overview: "overview1", releaseDate: nil),
            Movie(id: 2, title: "title2", posterPath: "/2", overview: "overview2", releaseDate: nil)])
        let page2 = MoviesPage(page: 2, totalPages: 2, movies: [
            Movie(id: 3, title: "title3", posterPath: "/3", overview: "overview3", releaseDate: nil)])
        return [page1, page2]
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - MoviesList
    
    func testMoviesList_WhenHasMorePages() {
        // given
        let pages = moviesPages
        // when
        let vm = MoviesListViewModel(moviesPage: pages[0])
        // then
        XCTAssertTrue(vm.hasMorePages)
    }
    
    func testMoviesList_WhenOnLastPage_ReturnHasNoMorePages() {
        // given
        let pages = moviesPages
        // when
        var vm = MoviesListViewModel(moviesPage: pages[0])
        vm.appendPage(moviesPage: pages[1])
        // then
        XCTAssertFalse(vm.hasMorePages)
    }
}
