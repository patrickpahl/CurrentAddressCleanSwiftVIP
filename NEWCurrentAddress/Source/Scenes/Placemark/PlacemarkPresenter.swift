import UIKit

protocol PlacemarkPresentationLogic {
    func presentSomething(response: Placemark.Something.Response)
    func presentShowPhysicalAddress(response: Placemark.ShowPhysicalAddress.Response)
}

class PlacemarkPresenter: PlacemarkPresentationLogic {
    weak var viewController: PlacemarkDisplayLogic?

    // MARK: Do something

    func presentSomething(response: Placemark.Something.Response) {
        let viewModel = Placemark.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }

    func presentShowPhysicalAddress(response: Placemark.ShowPhysicalAddress.Response) {

        let viewModel = Placemark.ShowPhysicalAddress.ViewModel(placemark: response.placemark)
        viewController?.displayShowPhysicalAddress(viewModel: viewModel)
    }

}
