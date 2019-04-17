
import MapKit
import RxSwift
import RxCocoa

// swiftlint:disable identifier_name
public extension Reactive where Base: MKLocalSearchCompleter {

    /**
    Reactive wrapper for `delegate`.

    For more information take a look at `DelegateProxyType` protocol documentation.
    */
    public var delegate: DelegateProxy<MKLocalSearchCompleter, MKLocalSearchCompleterDelegate> {
        return RxMKLocalSearchCompleterDelegateProxy.proxy(for: base)
    }

    /// Bindable sink for `enabled` property.
    public var queryFragment: Binder<String> {
        return Binder(self.base) { searchCompleter, value in
            searchCompleter.queryFragment = value
        }
    }

    public var didUpdateResults: Observable<[MKLocalSearchCompletion]> {
        return delegate.methodInvoked(#selector(MKLocalSearchCompleterDelegate.completerDidUpdateResults(_:)))
                .map { a in
                    let completer = a[0] as? MKLocalSearchCompleter
                    let completions = completer?.results
                    return completions ?? []
                }
    }

    public var didFailWithError: Observable<[MKLocalSearchCompletion]> {
        return delegate.methodInvoked(#selector(MKLocalSearchCompleterDelegate.completer(_:didFailWithError:)))
                .map { a in
                    let completer = a[0] as? MKLocalSearchCompleter
                    let completions = completer?.results
                    return completions ?? []
                }
    }

}
