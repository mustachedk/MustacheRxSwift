//
// Created by Tommy Hinrichsen on 2019-05-01.
//

import Foundation
import MustacheServices
import RxSwift

public protocol TokenServiceType: Service {

    func updateToken() -> Observable<String>

}
