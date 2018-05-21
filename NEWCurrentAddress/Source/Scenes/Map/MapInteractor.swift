import UIKit
import MapKit

protocol MapBusinessLogic {
    func doSomething(request: Map.Something.Request)
    func requestForCurrentLocation(request: Map.RequestForCurrentLocation.Request)
    func getCurrentLocation(request: Map.GetCurrentLocation.Request)
    func centerMap(request: Map.CenterMap.Request)
}

protocol MapDataStore {
    //var name: String { get set }
}

class MapInteractor: NSObject, MapBusinessLogic, MapDataStore, CLLocationManagerDelegate, MKMapViewDelegate {

    var presenter: MapPresentationLogic?
    var worker: MapWorker?
    //var name: String = ""
    let locationManager = CLLocationManager()
    var currentLocation: MKUserLocation?
    var centerMapFirstTime = false

    // MARK: Do something

    func doSomething(request: Map.Something.Request) {
        worker = MapWorker()
        worker?.doSomeWork()

        let response = Map.Something.Response()
        presenter?.presentSomething(response: response)
    }

    // MARK: Request for current location

    func requestForCurrentLocation(request: Map.RequestForCurrentLocation.Request) {

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        var response = Map.RequestForCurrentLocation.Response(success: false)

        switch status {
        case .authorizedWhenInUse:
            response = Map.RequestForCurrentLocation.Response(success: true)
        case .restricted:
            response = Map.RequestForCurrentLocation.Response(success: false)
        case .denied:
            response = Map.RequestForCurrentLocation.Response(success: false)
        default:
            response = Map.RequestForCurrentLocation.Response(success: false)
        }
        presenter?.presentRequestForCurrentLocation(response: response)
    }

    func getCurrentLocation(request: Map.GetCurrentLocation.Request) {
        request.mapView.delegate = self
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {

        currentLocation = userLocation
        let response = Map.GetCurrentLocation.Response(success: true, error: nil)
        presenter?.presentGetCurrentLocation(response: response)
    }

    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {

        currentLocation = nil
        let response = Map.GetCurrentLocation.Response(success: false, error: error as NSError)
        presenter?.presentGetCurrentLocation(response: response)
    }

    func centerMap(request: Map.CenterMap.Request) {
        if !centerMapFirstTime, let currentLocation = currentLocation {
            let response = Map.CenterMap.Response(coordinate: currentLocation.coordinate)
            presenter?.presentCenterMap(response: response)
            centerMapFirstTime = true

        }
    }

}
