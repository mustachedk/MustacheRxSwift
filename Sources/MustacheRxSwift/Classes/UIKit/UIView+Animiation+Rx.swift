import Foundation
import UIKit
import RxCocoa
import RxSwift

public extension Reactive where Base: UIView {

    static func animate(withDuration: TimeInterval, animations: @escaping () -> Void) -> Single<Bool> {

        return Single.create { single in
            UIView.animate(withDuration: withDuration, animations: animations, completion: {
                finished in single(.success(finished))
            })
            return Disposables.create()
        }
    }

}
