import Foundation
import UIKit
import CoreLocation
import MustacheServices

import RxSwift
import RxSwiftExt
import RxCocoa

public protocol RxGeoLocationServiceType: Service {

    var authorized: Observable<Bool> { get }

    var location: Observable<CLLocation> { get }

}

public class RxGeoLocationService: NSObject, RxGeoLocationServiceType {

    public var authorized: Observable<Bool>

    public lazy var location: Observable<CLLocation> = {
        return locationManager.rx.didUpdateLocations
                .filter({ (locations: [CLLocation]) -> Bool in
                    return locations.count > 0
                })
                .map({ (locations: [CLLocation]) -> CLLocation in
                    return locations.first!
                })
                .share(replay: 1)
                .do(onSubscribe: { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.changeObserverCount(1)
                }, onDispose: { [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.changeObserverCount(-1)
                })
    }()

    fileprivate let disposeBag = DisposeBag()

    fileprivate let locationManager = CLLocationManager()

    required public init(services: Services) throws {

        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

        authorized = locationManager.rx.didChangeAuthorizationStatus.map({ (status: CLAuthorizationStatus) -> Bool in
            switch status {
                case .authorizedWhenInUse, .authorizedAlways:
                    return true
                default:
                    return false
            }
        })

        super.init()

        self.locationManager.requestWhenInUseAuthorization()

    }

    fileprivate var observers: Int = 0

    fileprivate func changeObserverCount(_ value: Int) {
        self.observers += value
        if self.observers < 0 {
            fatalError()
        } else if self.observers == 0 {
            self.locationManager.stopUpdatingLocation()
        } else {
            self.locationManager.startUpdatingLocation()

        }
    }

    public func clearState() {}
}
