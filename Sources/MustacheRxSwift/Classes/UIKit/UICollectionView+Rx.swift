import Foundation
import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UICollectionView {

    /// Bindable sink for `selected` property.
    public var reloadData: Binder<Void> {
        return Binder(self.base) { control, _ in
            control.reloadData()
        }
    }
}
