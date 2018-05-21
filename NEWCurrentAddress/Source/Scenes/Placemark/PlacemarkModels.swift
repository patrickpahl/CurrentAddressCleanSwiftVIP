import UIKit
import MapKit

enum Placemark {
  // MARK: Use cases
  
  enum Something{
    struct Request{
    }
    struct Response{
    }
    struct ViewModel{
    }
  }

    enum ShowPhysicalAddress {

        struct Request {

        }
        struct Response {
            var placemark: MKPlacemark!
        }
        struct ViewModel {
            var placemark: MKPlacemark!
        }
    }

}
