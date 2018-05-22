import UIKit

protocol PlacemarkDisplayLogic: class {
    func displaySomething(viewModel: Placemark.Something.ViewModel)
    func displayShowPhysicalAddress(viewModel: Placemark.ShowPhysicalAddress.ViewModel)
}

class PlacemarkViewController: UITableViewController, PlacemarkDisplayLogic {

    let cellReuseIdentifier = "placemarkCell"
    var interactor: PlacemarkBusinessLogic?
    var router: (NSObjectProtocol & PlacemarkRoutingLogic & PlacemarkDataPassing)?
    var viewModel: Placemark.ShowPhysicalAddress.ViewModel?

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
        let interactor = PlacemarkInteractor()
        let presenter = PlacemarkPresenter()
        let router = PlacemarkRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        showPhysicalAddress()
    }

    // MARK: Do something

    //@IBOutlet weak var nameTextField: UITextField!

    func doSomething() {
        let request = Placemark.Something.Request()
        interactor?.doSomething(request: request)
    }

    func displaySomething(viewModel: Placemark.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }

    func showPhysicalAddress() {
        let request = Placemark.ShowPhysicalAddress.Request()
        interactor?.showPhysicalAddress(request: request)
    }

    func displayShowPhysicalAddress(viewModel: Placemark.ShowPhysicalAddress.ViewModel) {

        self.viewModel = viewModel
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        guard let viewModel = self.viewModel else { return UITableViewCell() }

        if indexPath.row == 0 {
            cell.textLabel?.text = "Thoroughfare"
            cell.detailTextLabel?.text = viewModel.placemark.thoroughfare
        }

        if indexPath.row == 1 {
            cell.textLabel?.text = "SubThoroughfare"
            cell.detailTextLabel?.text = viewModel.placemark.subThoroughfare
        }

        if indexPath.row == 2 {
            cell.textLabel?.text = "Locality"
            cell.detailTextLabel?.text = viewModel.placemark.locality
        }

        if indexPath.row == 3 {
            cell.textLabel?.text = "SubLocality"
            cell.detailTextLabel?.text = viewModel.placemark.subLocality
        }

        if indexPath.row == 4 {
            cell.textLabel?.text = "AdministrativeArea"
            cell.detailTextLabel?.text = viewModel.placemark.administrativeArea
        }

        if indexPath.row == 5 {
            cell.textLabel?.text = "SubAdministrativeArea"
            cell.detailTextLabel?.text = viewModel.placemark.subAdministrativeArea
        }

        if indexPath.row == 6 {
            cell.textLabel?.text = "PostalCode"
            cell.detailTextLabel?.text = viewModel.placemark.postalCode
        }

        if indexPath.row == 7 {
            cell.textLabel?.text = "CountryCode"
            cell.detailTextLabel?.text = viewModel.placemark.countryCode
        }

        if indexPath.row == 8 {
            cell.textLabel?.text = "ISO CountryCode"
            cell.detailTextLabel?.text = viewModel.placemark.isoCountryCode
        }

        return cell
    }

}
