
import RxSwift

public extension ObservableType {

    func mapFilter<Input>(_ isIncluded: @escaping (Input) throws -> Bool) -> Observable<Array<Input>> where E: Collection, E.Element == Input {
        return map { try $0.filter(isIncluded) }
    }
}

public extension ObservableType {

    func mapVoid() -> Observable<Void> {
        return self.map { _ in return Void() }
    }

}
