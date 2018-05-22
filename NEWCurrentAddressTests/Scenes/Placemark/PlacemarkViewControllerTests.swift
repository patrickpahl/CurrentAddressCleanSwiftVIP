
@testable import NEWCurrentAddress
import XCTest

class PlacemarkBusinessLogicSpy: PlacemarkBusinessLogic {
    func doSomething(request: Placemark.Something.Request) {
        }

    var showPhysicalAddressCalled = false
    func showPhysicalAddress(request: Placemark.ShowPhysicalAddress.Request) {
        showPhysicalAddressCalled = true
    }
}

class PlacemarkViewControllerTests: XCTestCase {
  // MARK: Subject under test
  
  var sut: PlacemarkViewController!
  var window: UIWindow!
  
  // MARK: Test lifecycle
  
  override func setUp() {
    super.setUp()
    window = UIWindow()
    setupPlacemarkViewController()
  }
  
  override func tearDown() {
    window = nil
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupPlacemarkViewController() {
    let bundle = Bundle.main
    /// *** Change the storyboard here if necessary
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "PlacemarkViewController") as! PlacemarkViewController
  }
  
  func loadView() {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: Test doubles


  // MARK: Tests

    func testShowPhysicalAddressWhenViewWillAppear() {
        // Given
        let spy = PlacemarkBusinessLogicSpy()
        sut.interactor = spy
        loadView()
        // When
        sut.viewWillAppear(true)
        //Then
        XCTAssertTrue(spy.showPhysicalAddressCalled, "ViewWillAppear() should ask the interactor to show the physical address")
    }

}
