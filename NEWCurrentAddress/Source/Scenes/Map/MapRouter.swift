import UIKit

@objc protocol MapRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    func routeToPlacemark(segue: UIStoryboardSegue?)
}

protocol MapDataPassing {
    var dataStore: MapDataStore? { get }
}

class MapRouter: NSObject, MapRoutingLogic, MapDataPassing {
    weak var viewController: MapViewController?
    var dataStore: MapDataStore?

    // MARK: Routing

    //func routeToSomewhere(segue: UIStoryboardSegue?) {
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}

    func routeToPlacemark(segue: UIStoryboardSegue?) {
        if let segue = segue {
            guard let placemarkVC = segue.destination as? PlacemarkViewController else { return }
            guard var placemarkDataStore = placemarkVC.router?.dataStore else { return }
            //var placemarkDataStore = placemarkVC.router!.dataStore!  // ORIG
            self.passDataToPlacemarkVC(source: dataStore!, destination: &placemarkDataStore)
        }
    }
    /// *** Must change the segue identifier in the story board to name of the scene, i.e. Placemark

    // MARK: Navigation

    //func navigateToSomewhere(source: MapViewController, destination: SomewhereViewController) {
    //  source.show(destination, sender: nil)
    //}

    // MARK: Passing data

    //func passDataToSomewhere(source: MapDataStore, destination: inout SomewhereDataStore) {
    //  destination.name = source.name
    //}

    func passDataToPlacemarkVC(source: MapDataStore, destination: inout PlacemarkDataStore) {
        /// ***Needs to be inout bc we're going to set something on the datastore,
        /// it's why we have the placemark in the dataStore protocol as a { get set }
      destination.placemark = source.placemark
    }
}
