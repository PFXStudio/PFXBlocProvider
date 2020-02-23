//
//  fetching_true_search_event_01.swift
//  PFXBlocProviderTests
//
//  Created by succorer on 23/02/2020.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import XCTest
import RxSwift

class fetching_true_search_event_01: XCTestCase {
    let searchBloc = SearchBloc()
    let timeout = TimeInterval(10)
    var disposeBag = DisposeBag()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expt = expectation(description: "Waiting done unit tests...")
        
        // When
        self.searchBloc.stateRelay
            .subscribe(onNext: { state in
                guard let state = state as? FetchedSearchState else {
                    return
                }
                
                guard let items = state.searchResponseModel.items else {
                    XCTAssertFalse(false)
                    return
                }
                
                // Then
                XCTAssertTrue(items.count > 0)
                expt.fulfill()

            }, onError: { error in
                expt.fulfill()
            })
            .disposed(by: self.disposeBag)

        // Given
        let event = FetchingSearchEvent(parameterDict: ["q" : "tom", "page" : "1"])
        self.searchBloc.dispatch(event: event)
        waitForExpectations(timeout: self.timeout, handler: { (error) in
            if error == nil {
                return
            }
            
            XCTFail("Fail timeout")
        })
        
        withExtendedLifetime(event) {}
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
