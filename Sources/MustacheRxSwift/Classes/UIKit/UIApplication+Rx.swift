import UIKit
import RxSwift

public extension Reactive where Base: UIApplication {

    /**
     Reactive wrapper for `UIApplication.willEnterForegroundNotification`.
     */
    var applicationWillEnterForeground: Observable<Void> {
        return NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).mapVoid()
    }

    /**
     Reactive wrapper for `UIApplication.didBecomeActiveNotification`.
     */
    var applicationDidBecomeActive: Observable<Void> {
        return NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification).mapVoid()
    }

    /**
     Reactive wrapper for `UIApplication.didBecomeActiveNotification`.
     */
    var applicationDidEnterBackground: Observable<Void> {
        return NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification).mapVoid()
    }

    /**
     Reactive wrapper for `UIApplication.willResignActiveNotification`.
     */
    var applicationWillResignActive: Observable<Void> {
        return NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification).mapVoid()
    }

    /**
     Reactive wrapper for `UIApplication.willTerminateNotification`.
     */
    var applicationWillTerminate: Observable<Void> {
        return NotificationCenter.default.rx.notification(UIApplication.willTerminateNotification).mapVoid()
    }

}

public extension PrimitiveSequence where Trait == SingleTrait {

    func withStatusIndicator() -> PrimitiveSequence {

        return self.do(
                onSubscribed: {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                },
                onDispose: {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    })
                })
    }
}
