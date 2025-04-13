//
//  SearchViewModelTests
//
//  Created by Hans Heidmann on 4/12/25.
//

import XCTest
@testable import GolfCourseFinder

final class SearchViewModelTests: XCTestCase {
    
    var viewModel: SearchViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SearchViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    

    func testInitialValues() {
        XCTAssertTrue(viewModel.results.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testSearchTextTriggersDebounce() {
        let expectation = XCTestExpectation(description: "Debounced search is triggered")

        viewModel.searchText = "torrey"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.viewModel.searchText == "torrey")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testEmptySearchReturnsNoResults() async {
        viewModel.searchText = ""
        await viewModel.performSearch()
        XCTAssertTrue(viewModel.results.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Enter some search terms..")
    }
    
    func testPerformSearchHitsAPI() async throws {
        viewModel.searchText = "torrey"

        await viewModel.performSearch()

        XCTAssertFalse(viewModel.results.isEmpty, "There should be results for torrey (south and north)")
        XCTAssertNil(viewModel.errorMessage, "No error was expected")
    }

}
