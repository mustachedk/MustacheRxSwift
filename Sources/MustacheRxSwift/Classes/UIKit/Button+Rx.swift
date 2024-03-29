//
// Created by Tommy Hinrichsen on 2019-05-02.
//

import MustacheUIKit
import RxSwift
import RxCocoa

extension Reactive where Base: Button {

    /// Bindable sink for `hidden` property.
    public var isBusy: Binder<Bool> {
        return Binder(self.base) { view, busy in
            view.isBusy = busy
        }
    }

}

public extension Observable {

    func bind(button: Button) -> Observable {
        return self.do(onSubscribe: { [weak button] in
            button?.isBusy = true
        }, onDispose: { [weak button] in
            button?.isBusy = false
        })
    }
}
