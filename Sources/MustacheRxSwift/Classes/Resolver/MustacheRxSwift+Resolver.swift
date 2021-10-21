//
//  File.swift
//
//
//  Created by Tommy Sadiq Hinrichsen on 28/12/2019.
//

import Foundation
import MustacheServices
import Resolver

extension Resolver {

    public static func registerMustacheRxServices() {
        self.registerMustacheServices()

        self.registerRxNetworkServices()
        self.registerRxGeoLocationServices()
        self.registerRxNotificationServices()
        self.registerRxDawaServices()
    }

    public static func registerRxNetworkServices() {
        Resolver.register(RenewTokenServiceType.self) { RenewTokenService() }.scope(.application)
        Resolver.register(RxNetworkServiceType.self) { RxNetworkService() }
    }

    public static func registerRxGeoLocationServices() {
        Resolver.register(RxGeoLocationServiceType.self) { RxGeoLocationService() }
    }

    public static func registerRxNotificationServices() {
        Resolver.register(RxNotificationServiceType.self) { RxNotificationService() }
    }

    public static func registerRxDawaServices() {
        Resolver.register(RxAddressServiceType.self) { RxAddressService() }
        Resolver.register(AddressViewModelType.self) { AddressViewModel() }
    }
}
