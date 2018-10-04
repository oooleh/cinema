//
//  CodeChallengeTests.swift
//  CodeChallengeTests
//
//  Created by Oleh Kudinov on 01.10.18.
//

import XCTest
@testable import CodeChallenge

class CodeChallengeTests: XCTestCase {
    
    static var moviesPages: [MoviesPage] {
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
        let pages = CodeChallengeTests.moviesPages
        // when
        let vm = MoviesListViewModel(moviesPage: pages[0])
        // then
        XCTAssertTrue(vm.hasMorePages)
    }
    
    func testMoviesList_WhenOnLastPage_ReturnHasNoMorePages() {
        // given
        let pages = CodeChallengeTests.moviesPages
        // when
        var vm = MoviesListViewModel(moviesPage: pages[0])
        vm.appendPage(moviesPage: pages[1])
        // then
        XCTAssertFalse(vm.hasMorePages)
    }
    
    func testMoviesList_OnSuccessfulQuerySearch_QuerySavedInRecents() {
        // given
        let expectation = self.expectation(description: "Recent query saved")
        class MoviesListViewMock: MoviesListViewInterface {
            var viewModel = MoviesListViewModel()
            var eventHandler: iMoviesListEventHandler?
            func showError(_ error: String) { }
        }
        class ImageDataSourceMock: ImageDataSourceInterface {
            func image(with endpoint: Requestable, result: @escaping (Result<UIImage, Error>) -> Void) -> CancelableTask? {
                result(.success(UIImage()))
                return nil
            }
        }
        class MoviesDataSourceMock: MoviesDataSourceInterface {
            var recentQueries: [MovieQuery] = []
            var expectation: XCTestExpectation?
            func moviesList(query: String, page: Int, with result: @escaping (Result<MoviesPage, Error>) -> Void) -> CancelableTask? {
                result(.success(CodeChallengeTests.moviesPages[0]))
                return nil
            }
            func recentsQueries(number: Int) -> [MovieQuery] {
                return recentQueries
            }
            func saveRecentQuery(query: MovieQuery) {
                recentQueries.append(query)
                expectation?.fulfill()
            }
        }
        struct MoviesListDependenciesMock: MoviesListDependencies {
            var imageDataSource: ImageDataSourceInterface = ImageDataSourceMock()
            var moviesDataSource: MoviesDataSourceInterface = MoviesDataSourceMock()
        }
        let moviesDataSource = MoviesDataSourceMock()
        moviesDataSource.expectation = expectation
        let dependencies = MoviesListDependenciesMock.init(imageDataSource: ImageDataSourceMock(),
                                                           moviesDataSource: moviesDataSource)
        let view = MoviesListViewMock()
        MoviesListWireframe.assemble(dependencies: dependencies,
                                     forView: view)
        // when
        view.eventHandler?.searchBarSearchButtonClicked(text: "title1")
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(moviesDataSource.recentsQueries(number: 1).contains(MovieQuery(query: "title1")))
    }
}
