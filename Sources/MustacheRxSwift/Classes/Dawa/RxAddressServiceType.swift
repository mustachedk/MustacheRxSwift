//
//  DAWAServiceType+Rx.swift
//  MustacheRxSwift
//
//  Created by Tommy Hinrichsen on 18/04/2019.
//

import Foundation
import MustacheServices
import RxSwift
import Resolver

public protocol RxAddressServiceType {

    func choices(searchText: String) -> Observable<[AutoCompleteContainer]>

    func find(addresse: String) -> Observable<[AutoCompleteAdresseContainer]>

    func zipCodes(searchText: String) -> Observable<[AutoCompletePostnummerContainer]>

    func nearest(latitude: Double, longitude: Double) -> Observable<AdgangsAdresse>

}

public class RxAddressService: NSObject, RxAddressServiceType {

    @Injected
    fileprivate var networkService: RxNetworkServiceType

    public func choices(searchText: String) -> Observable<[AutoCompleteContainer]> {
        let endpoint = AddressEndpoint.get(searchText: searchText)
        return self.networkService.send(endpoint: endpoint).asObservable()
    }

    public func find(addresse: String) -> Observable<[AutoCompleteAdresseContainer]> {
        let endpoint = AddressEndpoint.find(searchText: addresse)
        return self.networkService.send(endpoint: endpoint).asObservable()
    }

    public func zipCodes(searchText: String) -> Observable<[AutoCompletePostnummerContainer]> {
        let endpoint = AddressEndpoint.zip(searchText: searchText)
        return self.networkService.send(endpoint: endpoint).asObservable()
    }

    public func nearest(latitude: Double, longitude: Double) -> Observable<AdgangsAdresse> {
        let endpoint = AddressEndpoint.nearest(latitude: latitude, longitude: longitude)
        return self.networkService.send(endpoint: endpoint).asObservable()
    }

    func clearState() {}

}
