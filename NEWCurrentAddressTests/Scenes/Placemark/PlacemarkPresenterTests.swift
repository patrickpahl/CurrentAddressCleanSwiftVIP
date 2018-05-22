
@testable import NEWCurrentAddress
import XCTest

class PlacemarkPresenterTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: PlacemarkPresenter!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupPlacemarkPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupPlacemarkPresenter()
  {
    sut = PlacemarkPresenter()
  }
  
  // MARK: Test doubles

  // MARK: Tests


}
