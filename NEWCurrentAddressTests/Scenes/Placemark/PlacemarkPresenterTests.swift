
@testable import NEWCurrentAddress
import XCTest

class PlacemarkDisplayLogicSpy: PlacemarkDisplayLogic {
    func displaySomething(viewModel: Placemark.Something.ViewModel) {
    }

    var displayShowPhysicalAddressCalled = false
    func displayShowPhysicalAddress(viewModel: Placemark.ShowPhysicalAddress.ViewModel) {
        displayShowPhysicalAddressCalled = true
    }
}

class PlacemarkPresenterTests: XCTestCase {
  // MARK: Subject under test
  
  var sut: PlacemarkPresenter!
  
  // MARK: Test lifecycle
  
  override func setUp() {
    super.setUp()
    setupPlacemarkPresenter()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupPlacemarkPresenter() {
    sut = PlacemarkPresenter()
  }
  
  // MARK: Test doubles

  // MARK: Tests

    func testPresentShowPhysicalAddress() {
        // Given
        let spy = PlacemarkDisplayLogicSpy()
        sut.viewController = spy
        let placemark = CurrentAddressTestHelpers.placemark
        let response = Placemark.ShowPhysicalAddress.Response(placemark: placemark)

        // When
        sut.presentShowPhysicalAddress(response: response)

        // Then
        XCTAssertTrue(spy.displayShowPhysicalAddressCalled, "displayShowPhysicalAddressCalled() should ask VC to diplay the result")
    }

}
