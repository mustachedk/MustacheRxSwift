import UIKit
import RxSwift

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
