import Foundation
import RxSwift
import MustacheServices

public extension NetworkServiceType {

    func send<T: Decodable>(endpoint: Endpoint) -> Single<T> {
        return self.send(endpoint: endpoint, using: JSONDecoder())
    }

    func send<T: Decodable>(endpoint: Endpoint, using decoder: JSONDecoder) -> Single<T> {

        if let demoData = endpoint.demoData as? T { return Single<T>.just(demoData) }

        return Single<T>.create { [weak self] observer in
                    guard let self = self else {
                        observer(.error(MustacheRxSwiftError.deallocated))
                        return Disposables.create()
                    }

                    let task = self.send(endpoint: endpoint, using: decoder, completionHandler: { (result: Result<T, Error>) in

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
}



