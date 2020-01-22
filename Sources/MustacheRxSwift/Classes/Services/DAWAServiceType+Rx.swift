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

    func choices(searchText: String, type: AutoCompleteType) -> Observable<[AutoCompleteModel]> {

        return Single<[AutoCompleteModel]>.create { [weak self] observer in
                    guard let self = self else {
                        observer(.error(MustacheRxSwiftError.deallocated))
                        return Disposables.create()
                    }

            let task = self.choices(searchText: searchText, type: type, completionHandler: { (result: Result<[AutoCompleteModel], Error>) in

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

    func address(href: String, type: AutoCompleteType) -> Observable<DAWAAddressProtol> {

        return Single<DAWAAddressProtol>.create { [weak self] observer in
                    guard let self = self else {
                        observer(.error(MustacheRxSwiftError.deallocated))
                        return Disposables.create()
                    }

                    let task = self.address(href: href, type: type, completionHandler: { (result: Result<DAWAAddressProtol, Error>) in

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

    func nearest(latitude: Double, longitude: Double, type: AutoCompleteType) -> Observable<DAWAAddressProtol> {
        return Single<DAWAAddressProtol>.create { [weak self] observer in
                    guard let self = self else {
                        observer(.error(MustacheRxSwiftError.deallocated))
                        return Disposables.create()
                    }

                    let task = self.nearest(latitude: latitude, longitude: longitude, type: type, completionHandler: { (result: Result<DAWAAddressProtol, Error>) in

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

    func zip(searchText: String) -> Observable<[ZipAutoCompleteModel]> {
        return Single<[ZipAutoCompleteModel]>.create { [weak self] observer in
                    guard let self = self else {
                        observer(.error(MustacheRxSwiftError.deallocated))
                        return Disposables.create()
                    }

                    let task = self.zip(searchText: searchText, completionHandler: { (result: Result<[ZipAutoCompleteModel], Error>) in

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
