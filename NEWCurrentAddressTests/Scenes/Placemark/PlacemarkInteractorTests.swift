@testable import NEWCurrentAddress
import XCTest

class PlacemarkPresentationLogicSpy: PlacemarkPresentationLogic {
    func presentSomething(response: Placemark.Something.Response) {
    }

    var presentShowPhysicalAddressCalled = false
    func presentShowPhysicalAddress(response: Placemark.ShowPhysicalAddress.Response) {
        presentShowPhysicalAddressCalled = true
    }
}

class PlacemarkInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: PlacemarkInteractor!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupPlacemarkInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setupPlacemarkInteractor() {
        sut = PlacemarkInteractor()
    }

    // MARK: Test doubles

    // MARK: Tests

    func testShowPhysicalAddress() {
        // Given
        let placemarkPresentationLogicSpy = PlacemarkPresentationLogicSpy()
        sut.presenter = placemarkPresentationLogicSpy
        sut.placemark = CurrentAddressTestHelpers.placemark
        let request = Placemark.ShowPhysicalAddress.Request()

        // When
        sut.showPhysicalAddress(request: request)

        // Then
        XCTAssertTrue(placemarkPresentationLogicSpy.presentShowPhysicalAddressCalled, "ShowPhysicalAddress() should ask the presenter to format the result")
    }

}
