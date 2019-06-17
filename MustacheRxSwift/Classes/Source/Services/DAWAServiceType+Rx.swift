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

    func choices(searchText: String) -> Observable<[AutoCompleteModel]> {

        return Single<[AutoCompleteModel]>.create { [weak self] observer in
                    guard let self = self else {
                        observer(.error(MustacheRxSwiftError.deallocated))
                        return Disposables.create()
                    }

                    let task = self.choices(searchText: searchText, completionHandler: { (result: Result<[AutoCompleteModel], Error>) in

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

    func address(href: String) -> Observable<AutoCompleteAddress> {

        return Single<AutoCompleteAddress>.create { [weak self] observer in
                    guard let self = self else {
                        observer(.error(MustacheRxSwiftError.deallocated))
                        return Disposables.create()
                    }

                    let task = self.address(href: href, completionHandler: { (result: Result<AutoCompleteAddress, Error>) in

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

    func nearest(latitude: Double, longitude: Double) -> Observable<AutoCompleteAddress> {
        return Single<AutoCompleteAddress>.create { [weak self] observer in
                    guard let self = self else {
                        observer(.error(MustacheRxSwiftError.deallocated))
                        return Disposables.create()
                    }

                    let task = self.nearest(latitude: latitude, longitude: longitude, completionHandler: { (result: Result<AutoCompleteAddress, Error>) in

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
            
            let task = self.zip(searchText: searchText, completion: { (result: Result<[ZipAutoCompleteModel], Error>) in
                
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
}
