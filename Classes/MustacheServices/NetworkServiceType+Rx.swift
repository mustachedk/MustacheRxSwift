
import Foundation
import RxSwift
import MustacheServices

public extension NetworkServiceType {

    public func send<T: Decodable>(endpoint: APIEndpoint) -> Single<T> {
        return self.send(endpoint: endpoint, using: JSONDecoder())
    }

    public func send<T: Decodable>(endpoint: APIEndpoint, using decoder: JSONDecoder) -> Single<T> {

        if let demoData = endpoint.demoData as? T { return Single<T>.just(demoData) }

        return Single<T>.create { [weak self] observer in

            let task = self.send(endpoint:endpoint, using: decoder, completion: { (result: Result<T, Error>) in

                switch result {
                    case .success(let model):
                        observer(.success(model))
                    case .error(let error):
                        observer(.error(error))
                }

            })

            return Disposables.create {
                task.cancel()
            }
            }
        .observeOn(MainScheduler.instance)

    }
}

public extension DAWAServiceType {

    func choices(searchText: String) -> Observable<[AutoCompleteModel]> {
        return self.networkService.getAutoCompleteChoices(searchText: searchText).asObservable()
    }

    func address(href: String) -> Observable<AutoCompleteAddress> {
        return self.networkService.getAddress(href: href).asObservable()
    }

    func nearest(latitude: Double, longitude: Double) -> Observable<AutoCompleteAddress> {
        return self.networkService.getNearestAddress(latitude: latitude, longitude: longitude).asObservable()
    }
    
}

public extension NetworkServiceType {

    func getAutoCompleteChoices(searchText: String) -> Single<[AutoCompleteModel]> {
        let endpoint = DAWAEndpoint.get(searchText: searchText)
        return self.send(endpoint: endpoint)
    }

    func getAddress(href: String) -> Single<AutoCompleteAddress> {
        let endpoint = DAWAEndpoint.getAddress(href: href)
        return self.send(endpoint: endpoint)
    }

    func getNearestAddress(latitude: Double, longitude: Double) -> Single<AutoCompleteAddress> {
        let endpoint = DAWAEndpoint.nearest(latitude: latitude, longitude: longitude)
        return self.send(endpoint: endpoint)
    }

}
