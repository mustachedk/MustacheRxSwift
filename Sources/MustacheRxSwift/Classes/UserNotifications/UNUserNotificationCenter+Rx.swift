
import Foundation
import UserNotifications
import RxSwift
import UIKit

extension Reactive where Base: UNUserNotificationCenter {

    public func requestAuthorization(options: UNAuthorizationOptions = []) -> Observable<Bool> {
        return Observable.create { (observer: AnyObserver<Bool>) in
            DispatchQueue.main.async {
                self.base.requestAuthorization(options: options, completionHandler: { (_ granted: Bool, _ error: Error?) -> Void in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onNext(granted)
                        observer.onCompleted()
                        if granted { DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() } }

                    }
                })
            }
            return Disposables.create()
        }
    }

    public func getNotificationSettings() -> Observable<UNNotificationSettings> {
        return Observable.create { (observer: AnyObserver<UNNotificationSettings>) in
            DispatchQueue.main.async {
                self.base.getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) -> Void in
                    observer.onNext(settings)
                    observer.onCompleted()
                })
            }
            return Disposables.create()
        }
    }

}
