import UIKit
import MapKit

protocol MapBusinessLogic {
    func doSomething(request: Map.Something.Request)
    func requestForCurrentLocation(request: Map.RequestForCurrentLocation.Request)
    func getCurrentLocation(request: Map.GetCurrentLocation.Request)
    func centerMap(request: Map.CenterMap.Request)
    func getCurrentAddress(request: Map.getCurrentAddress.Request)
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
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?

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

    func getCurrentAddress(request: Map.getCurrentAddress.Request) {

        if let location = currentLocation?.location {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                var response: Map.getCurrentAddress.Response
                if let placemark = placemarks?.first {
                    self.placemark = placemark
                    response = Map.getCurrentAddress.Response(success: true)
                } else {
                    response = Map.getCurrentAddress.Response(success: false)
                }
                self.presenter?.presentCurrentAddress(response: response)
            }
        }
    }

}
