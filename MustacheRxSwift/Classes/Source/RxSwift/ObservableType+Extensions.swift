import RxSwift

public extension ObservableType {

    func mapFilter<Input>(_ isIncluded: @escaping (Input) throws -> Bool) -> Observable<Array<Input>> where E: Collection, E.Element == Input {
        return map { try $0.filter(isIncluded) }
    }

    func mapVoid() -> Observable<Void> {
        return self.map { _ in return Void() }
    }

}

public extension ObservableType {

    func withPrevious(startWith first: E) -> Observable<(E, E)> {
        return self.withPrevious(startWith: first, skip: 0)
    }

    func withPrevious(startWith first: E, skip: Int) -> Observable<(E, E)> {
        return scan((first, first)) { ($0.1, $1) }.skip(skip)
    }
}
