import Foundation
import RxSwift
import MustacheServices

public protocol RxNetworkServiceType: Service {
    func send<T: Decodable>(endpoint: Endpoint) -> Single<T>
    func send<T: Decodable>(endpoint: Endpoint, using decoder: JSONDecoder) -> Single<T>
}

public class RxNetworkService: NSObject, RxNetworkServiceType {

    fileprivate let services: Services
    fileprivate lazy var networkService: NetworkServiceType = { return try! self.services.get() }()
    fileprivate lazy var renewTokenService: RenewTokenServiceType  = { return try! self.services.get() }()

    public required init(services: Services) throws {
        self.services = services
    }

    public func send<T: Decodable>(endpoint: Endpoint) -> Single<T> {
        return self.send(endpoint: endpoint, using: JSONDecoder())
    }

    public func send<T: Decodable>(endpoint: Endpoint, using decoder: JSONDecoder) -> Single<T> {

        if endpoint.authentication == .bearer {
            return Observable
                    .deferred { self.renewTokenService.token.take(1) }
                    .flatMap { _ in self.observable(endpoint: endpoint, using: decoder).asObservable() }
                    .catchError { error in
                        guard let networkError = error as? NetworkServiceTypeError else { throw error }
                        switch networkError {
                            case .unSuccessful(let code, _):
                                if code == 403 || code == 401 {
                                    throw RenewTokenError.unauthorized
                                } else {
                                    throw error
                                }
                            default: throw error
                        }
                    }
                    .retryWhen { $0.renewToken(with: self.renewTokenService) }
                    .asSingle()

        } else {
            return self.observable(endpoint: endpoint, using: decoder)
        }

    }

    fileprivate func observable<T: Decodable>(endpoint: Endpoint, using decoder: JSONDecoder) -> Single<T> {

        if let demoData = endpoint.demoData as? T { return Single<T>.just(demoData) }

        return Single<T>.create { [weak self] observer in
                    guard let self = self else {
                        observer(.error(MustacheRxSwiftError.deallocated))
                        return Disposables.create()
                    }

                    let task = self.networkService.send(endpoint: endpoint, using: decoder, completionHandler: { (result: Result<T, Error>) in

                        switch result {
                            case .success(let model):
                                observer(.success(model))
                            case .failure(let error):
                                observer(.error(error))
                        }

                    })

                    return Disposables.create {
                        task.cancel()
                    }
                }
                .observeOn(MainScheduler.instance)
    }

    public func clearState() {}
}



