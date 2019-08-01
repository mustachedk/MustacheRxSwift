import RxSwift
import RxCocoa

public func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object as AnyObject, targetType: resultType)
    }

    return returnValue
}

public func castOptionalOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T? {
    if NSNull().isEqual(object) {
        return nil
    }

    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object as AnyObject, targetType: resultType)
    }

    return returnValue
}

infix operator <->

public func <-><T: Equatable>(variable: Variable<T>, property: ControlProperty<T>) -> Disposable {
    let variableToProperty = variable.asObservable()
            .distinctUntilChanged()
            .bind(to: property)

    let propertyToVariable = property
            .distinctUntilChanged()
            .bind(to: variable)

    return Disposables.create(variableToProperty, propertyToVariable)
}

public func <-><T: Equatable>(property: ControlProperty<T>, variable: Variable<T>) -> Disposable {
    let variableToProperty = variable.asObservable()
            .distinctUntilChanged()
            .bind(to: property)

    let propertyToVariable = property
            .distinctUntilChanged()
            .bind(to: variable)

    return Disposables.create(variableToProperty, propertyToVariable)
}

public func <-><T: Equatable>(relay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
    let relayToProperty = relay.asObservable()
            .distinctUntilChanged()
            .bind(to: property)

    let propertyToVariable = property
            .distinctUntilChanged()
            .bind(to: relay)

    return Disposables.create(relayToProperty, propertyToVariable)
}

public func <-><T: Equatable>(left: BehaviorRelay<T>, right: BehaviorRelay<T>) -> Disposable {
    let leftToRight = left.asObservable()
            .distinctUntilChanged()
            .bind(to: right)

    let rightToLeft = right
            .distinctUntilChanged()
            .bind(to: left)

    return Disposables.create(leftToRight, rightToLeft)
}

public func <-><T: Equatable>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    let relayToProperty = relay.asObservable()
            .distinctUntilChanged()
            .bind(to: property)

    let propertyToVariable = property
            .distinctUntilChanged()
            .bind(to: relay)

    return Disposables.create(relayToProperty, propertyToVariable)
}

public func <-><T: Equatable>(left: Variable<T>, right: Variable<T>) -> Disposable {
    let leftToRight = left.asObservable()
            .distinctUntilChanged()
            .bind(to: right)

    let rightToLeft = right.asObservable()
            .distinctUntilChanged()
            .bind(to: left)

    return Disposables.create(leftToRight, rightToLeft)
}

public func <-><T: Equatable>(left: PublishSubject<T>, right: ControlProperty<T>) -> Disposable {
    let leftToRight = left.asObservable()
            .distinctUntilChanged()
            .bind(to: right)

    let rightToLeft = right.asObservable()
            .distinctUntilChanged()
            .bind(to: left)

    return Disposables.create(leftToRight, rightToLeft)
}

public func <-><T: Equatable>(left: ControlProperty<T>, right: PublishSubject<T>) -> Disposable {
    let leftToRight = left.asObservable()
            .distinctUntilChanged()
            .bind(to: right)

    let rightToLeft = right.asObservable()
            .distinctUntilChanged()
            .bind(to: left)

    return Disposables.create(leftToRight, rightToLeft)
}

public enum MustacheRxSwiftError: Error {
    case deallocated
}
