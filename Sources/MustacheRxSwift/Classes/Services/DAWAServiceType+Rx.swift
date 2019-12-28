//
//  DAWAServiceType+Rx.swift
//  MustacheRxSwift
//
//  Created by Tommy Hinrichsen on 18/04/2019.
//

import Foundation
import MustacheServices
import RxSwift

public extension DAWAServiceType {

    func choices(searchText: String) -> Observable<[DAWAAddressSuggestion]> {

        return Single<[DAWAAddressSuggestion]>.create { [weak self] observer in
                    guard let self = self else {
                        observer(.error(MustacheRxSwiftError.deallocated))
                        return Disposables.create()
                    }

                    let task = self.choices(searchText: searchText, completionHandler: { (result: Result<[DAWAAddressSuggestion], Error>) in

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
                .asObservable()

    }

    func address(href: String) -> Observable<DAWAAddress> {

        return Single<DAWAAddress>.create { [weak self] observer in
                    guard let self = self else {
                        observer(.error(MustacheRxSwiftError.deallocated))
                        return Disposables.create()
                    }

                    let task = self.address(href: href, completionHandler: { (result: Result<DAWAAddress, Error>) in

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
                .asObservable()
    }

    func nearest(latitude: Double, longitude: Double) -> Observable<DAWAAddress> {
        return Single<DAWAAddress>.create { [weak self] observer in
                    guard let self = self else {
                        observer(.error(MustacheRxSwiftError.deallocated))
                        return Disposables.create()
                    }

                    let task = self.nearest(latitude: latitude, longitude: longitude, completionHandler: { (result: Result<DAWAAddress, Error>) in

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
                .asObservable()
    }

    func zip(searchText: String) -> Observable<[DAWAZipSuggestion]> {
        return Single<[DAWAZipSuggestion]>.create { [weak self] observer in
                    guard let self = self else {
                        observer(.error(MustacheRxSwiftError.deallocated))
                        return Disposables.create()
                    }

                    let task = self.zip(searchText: searchText, completionHandler: { (result: Result<[DAWAZipSuggestion], Error>) in

                        switch result {
                            case .success(let models):
                                observer(.success(models))
                            case .failure(let error):
                                observer(.error(error))
                        }

                    })

                    return Disposables.create {
                        task.cancel()
                    }
                }
                .observeOn(MainScheduler.instance)
                .asObservable()
    }

}
