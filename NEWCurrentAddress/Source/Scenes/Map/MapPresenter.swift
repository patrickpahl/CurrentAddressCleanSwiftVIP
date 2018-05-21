
import UIKit
import MapKit

protocol MapPresentationLogic {
    func presentSomething(response: Map.Something.Response)
    func presentRequestForCurrentLocation(response: Map.RequestForCurrentLocation.Response)
    func presentGetCurrentLocation(response: Map.GetCurrentLocation.Response)
    func presentCenterMap(response: Map.CenterMap.Response)
    func presentCurrentAddress(response: Map.getCurrentAddress.Response)
}

class MapPresenter: MapPresentationLogic {
    weak var viewController: MapDisplayLogic?

    // MARK: Do something

    func presentSomething(response: Map.Something.Response) {
        let viewModel = Map.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }

    // MARK: Response for current location

    func presentRequestForCurrentLocation(response: Map.RequestForCurrentLocation.Response){

        var viewModel: Map.RequestForCurrentLocation.ViewModel
        let errorTitle = "Location Disabled"
        let errorMessage = "Please enable location services in the Settings app."

        if response.success {
            viewModel = Map.RequestForCurrentLocation.ViewModel(success: true, errorTitle: nil, errorMessage: nil)
        } else {
            viewModel = Map.RequestForCurrentLocation.ViewModel(success: false, errorTitle: errorTitle, errorMessage: errorMessage)
        }

        viewController?.displayRequestForCurrentLocation(viewModel: viewModel)
    }

    func presentGetCurrentLocation(response: Map.GetCurrentLocation.Response) {

        var viewModel: Map.GetCurrentLocation.ViewModel

        if response.success {
            viewModel = Map.GetCurrentLocation.ViewModel(success: true, errorTitle: nil, errorMessage: nil)
        } else {
            let errorMessage: String
            if response.error?.code == CLError.locationUnknown.rawValue {
                errorMessage = "Location could not be determined."
            } else {
                errorMessage = response.error?.localizedDescription ?? ""
            }

            viewModel = Map.GetCurrentLocation.ViewModel(success: false, errorTitle: "Error", errorMessage: errorMessage)
        }

        viewController?.displayGetCurrentLocation(viewModel: viewModel)
    }

    func presentCenterMap(response: Map.CenterMap.Response) {

        let viewModel = Map.CenterMap.ViewModel(coordinate: response.coordinate)
        viewController?.displayCenterMap(viewModel: viewModel)
    }

    func presentCurrentAddress(response: Map.getCurrentAddress.Response) {
        let viewModel = Map.getCurrentAddress.ViewModel(success: response.success)
        viewController?.displayCurrentAddress(viewModel: viewModel)
    }

}
