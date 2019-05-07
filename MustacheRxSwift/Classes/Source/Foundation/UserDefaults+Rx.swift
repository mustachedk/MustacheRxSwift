//
// Created by Tommy Hinrichsen on 2019-05-06.
//

import Foundation
import RxSwift
import RxCocoa

public extension Reactive where Base: NSObject {

    public func observeCodable<T: Codable>(_ type: T.Type, _ keyPath: String, options: KeyValueObservingOptions = [.new, .initial]) -> Observable<T?> {
        return self.observe(Data.self, keyPath, options: options).map { data in
            guard let data = data else { return nil }
            let decoder = JSONDecoder()
            let loaded = try? decoder.decode(T.self, from: data)
            return loaded
        }
    }
}
