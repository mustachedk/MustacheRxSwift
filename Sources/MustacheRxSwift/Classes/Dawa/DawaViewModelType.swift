import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa
import MustacheServices
import MustacheFoundation
import CoreLocation
import Resolver

protocol AddressViewModelType {
    
    var searchText: PublishSubject<String?> { get }
    var autoCompleteChoices: PublishSubject<[AutoCompleteContainer]> { get }
    var selectedAutoCompleteChoice: PublishSubject<AutoCompleteContainer> { get }
    var foundAddress: Observable<AutoCompleteAdresse> { get }
    
    var zipSearchText: PublishSubject<String?> { get }
    var zipChoices: PublishSubject<[AutoCompletePostnummerContainer]> { get }
    
}

open class AddressViewModel: NSObject, AddressViewModelType {
    
    public let searchText = PublishSubject<String?>()
    public let autoCompleteChoices = PublishSubject<[AutoCompleteContainer]>()
    public var selectedAutoCompleteChoice = PublishSubject<AutoCompleteContainer>()
    
    public var foundAddress: Observable<AutoCompleteAdresse> { self._foundAddress.asObservable() }
    public let _foundAddress = PublishSubject<AutoCompleteAdresse>()
    
    public let zipSearchText = PublishSubject<String?>()
    public let zipChoices = PublishSubject<[AutoCompletePostnummerContainer]>()
    
    @Injected
    fileprivate var addressService: RxAddressServiceType
    
    fileprivate let disposeBag = DisposeBag()
    
    override public init() {
        super.init()
        
        self.configureAutoComplete()
        self.configureZipAutoComplete()
    }
    
    fileprivate func configureAutoComplete() {
        
        self.searchText.asObservable()
            .map { $0.orEmpty }
            .do(onNext: { [weak self] searchText in
                if searchText.count <= 2 { self?.autoCompleteChoices.onNext([]) }
            })
            .filter({ $0.count > 2 })
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest( { [weak self] searchText -> Observable<[AutoCompleteContainer]> in
                guard let self = self else { return Observable<[AutoCompleteContainer]>.just([]) }
                return self.addressService.choices(searchText: searchText)
            })
            .bind(to: self.autoCompleteChoices)
            .disposed(by: self.disposeBag)
        
        self.selectedAutoCompleteChoice
            .flatMap({ [weak self] selected -> Observable<AutoCompleteContainer> in
                guard let self = self else { return Observable.just(selected) }
                if selected.type == .adgangsadresse { //Try to see if we can find an adresse at the same place as the adgangsadresse
                    return self.addressService.find(addresse: selected.forslagstekst).mapAdresser(fallback: selected)
                } else {
                    return Observable.just(selected)
                }
            })
            .subscribe(onNext: { [weak self] selected in
                if selected.type == .adresse, let address = selected.data as? AutoCompleteAdresse {
                    self?._foundAddress.onNext(address)
                } else {
                    self?.searchText.onNext(selected.tekst)
                }
            })
            .disposed(by: self.disposeBag)
        
    }
    
    fileprivate func configureZipAutoComplete() {
        self.zipSearchText
            .map { $0.orEmpty }
            .do(onNext: { [weak self] (searchText: String) in
                if searchText.count < 2 { self?.zipChoices.onNext([]) }
            })
            .filter { $0.count >= 2 }
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest( { [weak self] (searchText: String) -> Observable<[AutoCompletePostnummerContainer]> in
                guard let self = self else { return Observable<[AutoCompletePostnummerContainer]>.just([]) }
                return self.addressService.zipCodes(searchText: searchText)
            })
            .bind(to: self.zipChoices)
            .disposed(by: self.disposeBag)
    }
    
    func clearState() {}
    
}

extension Observable where Element == Array<AutoCompleteAdresseContainer> {
    
    func mapAdresser(fallback: AutoCompleteContainer) -> Observable<AutoCompleteContainer> {
        return self.map { (containers: [AutoCompleteAdresseContainer]) -> AutoCompleteContainer in
            guard let found = containers.first(where: { container in container.tekst == fallback.forslagstekst }) else { return fallback }
            return AutoCompleteContainer(adresse: found)
        }
    }
    
}
