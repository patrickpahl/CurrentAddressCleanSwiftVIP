import UIKit
import MapKit

protocol MapDisplayLogic: class {
    func displaySomething(viewModel: Map.Something.ViewModel)
    func displayRequestForCurrentLocation(viewModel: Map.RequestForCurrentLocation.ViewModel)
    func displayGetCurrentLocation(viewModel: Map.GetCurrentLocation.ViewModel)
    func displayCenterMap(viewModel: Map.CenterMap.ViewModel)
    func displayCurrentAddress(viewModel: Map.getCurrentAddress.ViewModel)
}

class MapViewController: UIViewController, MapDisplayLogic {

    @IBOutlet weak var getCurrentAddressButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!

    var interactor: MapBusinessLogic?
    var router: (NSObjectProtocol & MapRoutingLogic & MapDataPassing)?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = MapInteractor()
        let presenter = MapPresenter()
        let router = MapRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    /// *** Must change the segue identifier in the story board to name of the scene, i.e. Placemark for this to work automatically
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
        doSomething()
        requestForCurrentLocation()
    }

    // MARK: Do something

    //@IBOutlet weak var nameTextField: UITextField!

    func doSomething() {
        let request = Map.Something.Request()
        interactor?.doSomething(request: request)
    }

    func displaySomething(viewModel: Map.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }

    // MARK: Request for current location

    func requestForCurrentLocation() {

        let request = Map.RequestForCurrentLocation.Request()
        interactor?.requestForCurrentLocation(request: request)
    }

    func displayRequestForCurrentLocation(viewModel: Map.RequestForCurrentLocation.ViewModel) {

        if viewModel.success {
            mapView.showsUserLocation = true
            getCurrentLocation()
        } else {
            showAlert(title: viewModel.errorTitle!, message: viewModel.errorMessage!)
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func getCurrentLocation() {
        let request = Map.GetCurrentLocation.Request(mapView: mapView)
        interactor?.getCurrentLocation(request: request)
    }

    func displayGetCurrentLocation(viewModel: Map.GetCurrentLocation.ViewModel) {

        if viewModel.success {
            centerMap()
            getCurrentAddress()
        } else {
            showAlert(title: viewModel.errorTitle ?? "", message: viewModel.errorMessage ?? "")
        }
    }

    func centerMap() {
        let request = Map.CenterMap.Request()
        interactor?.centerMap(request: request)
    }

    func displayCenterMap(viewModel: Map.CenterMap.ViewModel) {
        mapView.setCenter(viewModel.coordinate, animated: true)
    }

    func getCurrentAddress() {
        let request = Map.getCurrentAddress.Request()
        interactor?.getCurrentAddress(request: request)
    }

    func displayCurrentAddress(viewModel: Map.getCurrentAddress.ViewModel) {

        getCurrentAddressButton.isEnabled = viewModel.success
    }

}
