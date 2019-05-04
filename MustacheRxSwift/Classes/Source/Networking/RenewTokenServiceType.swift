//
//  RenewTokenServiceType.swift
//
//  Created by Daniel Tartaglia on 16 Jan 2019.
//  Copyright © 2019 Daniel Tartaglia. MIT License.
//

import Foundation
import MustacheServices
import RxSwift

public protocol RenewTokenServiceType: Service {

    var token: Observable<String> { get }

    func trackErrors<O: ObservableConvertibleType>(for source: O) -> Observable<Void> where O.E == Error

}

public class RenewTokenService: NSObject, RenewTokenServiceType {

    public lazy var token: Observable<String> = {
        return self.relay
                .flatMapFirst { _ in self.tokenService.updateToken() }
                .startWith(self.credentialsService.bearer ?? "")
                .share(replay: 1)
    }()

    fileprivate let tokenService: TokenServiceType
    fileprivate let credentialsService: CredentialsServiceType

    public required init(services: Services) throws {
        self.tokenService = try services.get()
        self.credentialsService = try services.get()
    }

    /**
     Monitors the source for `.unauthorized` error events and passes all other errors on. When an `.unauthorized` error is seen, `self` will get a new token and emit a signal that it's safe to retry the request.

     - parameter source: An `Observable` (or like type) that emits errors.
     - returns: A trigger that will emit when it's safe to retry the request.
     */
    public func trackErrors<O: ObservableConvertibleType>(for source: O) -> Observable<Void> where O.E == Error {
        let lock = self.lock
        let relay = self.relay
        let error = source
                .asObservable()
                .map { error in
                    guard (error as? RenewTokenError) == .unauthorized else { throw error }
                }
                .flatMap { [unowned self] in self.token }
                .do(onNext: {
                    lock.lock()
                    relay.onNext($0)
                    lock.unlock()
                })
                .filter { _ in false }
                .map { _ in }

        return Observable.merge(token.skip(1).map { _ in }, error)
    }

    private let relay = PublishSubject<String>()
    private let lock = NSRecursiveLock()

    public func clearState() {}
}

public extension ObservableConvertibleType where E == Error {

    func renewToken(with service: RenewTokenServiceType) -> Observable<Void> {
        return service.trackErrors(for: self)
    }
}

public enum RenewTokenError: Error, Equatable {
    case unauthorized
    case refusedToken
}
