import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa
import CoreLocation
import MustacheServices
import Resolver

public protocol DawaViewModelType {

    var addressSearchText: PublishSubject<String> { get }
    var zipSearchText: PublishSubject<String> { get }

    var cursorPosition: PublishSubject<Int> { get }

    var autoCompleteChoices: PublishSubject<[DAWAAddressSuggestion]> { get }
    var chosenAutoCompleteChoice: PublishSubject<DAWAAddressSuggestion> { get }

    var autoCompleteAddress: PublishSubject<DAWAAddress> { get }
    var zipAutoComplete: PublishSubject<[DAWAZipSuggestion]> { get }

    func getNearest() -> Observable<DAWAAddress?>

}

open class DawaViewModel: DawaViewModelType {
    
    public let addressSearchText = PublishSubject<String>()
    public let zipSearchText = PublishSubject<String>()

    public let cursorPosition = PublishSubject<Int>()

    public let autoCompleteChoices = PublishSubject<[DAWAAddressSuggestion]>()
    public let chosenAutoCompleteChoice = PublishSubject<DAWAAddressSuggestion>()

    public let autoCompleteAddress = PublishSubject<DAWAAddress>()

    public var zipAutoComplete = PublishSubject<[DAWAZipSuggestion]>()

    fileprivate let disposeBag = DisposeBag()

    @Injected
    fileprivate var dawaService: DAWAServiceType
    
    @Injected
    fileprivate var locationService: RxGeoLocationServiceType

    public init() {
        self.configureAutoComplete()
        self.configureChosenAutoCompleteChoice()
        self.configureZipAutoComplete()
    }

    public func getNearest() -> Observable<DAWAAddress?> {
        return self.locationService.location
                .take(1)
                .timeout(.seconds(3), scheduler: MainScheduler.asyncInstance)
                .map { return $0 as CLLocation? }
                .catchErrorJustReturn(nil)
                .flatMapLatest { [weak self] location -> Observable<DAWAAddress?> in
                    guard let self = self, let location = location else { return Observable<DAWAAddress?>.just(nil) }
                    return self.dawaService.nearest(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude).map { return $0 as DAWAAddress? }
                }
    }

    fileprivate func configureAutoComplete() {

        self.addressSearchText
                .do(onNext: { [weak self] (searchText: String) in
                    if searchText.count <= 2 { self?.autoCompleteChoices.onNext([]) }
                })
                .filter { (searchText: String) -> Bool in return searchText.count > 2 }
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .flatMapLatest { [weak self] (searchText: String) -> Observable<[DAWAAddressSuggestion]> in
                    guard let self = self else { return Observable<[DAWAAddressSuggestion]>.just([]) }
                    return self.dawaService.choices(searchText: searchText)
                }
                .bind(to: self.autoCompleteChoices)
                .disposed(by: self.disposeBag)
    }

    fileprivate func configureChosenAutoCompleteChoice() {

        self.chosenAutoCompleteChoice.subscribe(onNext: { [weak self] choice in
                    guard let self = self else { return }
                    switch choice.type {
                        case .vejnavn: self.addressSearchText.onNext(choice.forslagsTekst)
                        case .adresse, .adgangsadresse:
                            _ = self.dawaService.address(href: choice.href)
                                    .subscribe(onNext: { [weak self] address in
                                        self?.autoCompleteAddress.onNext(address)
                                    })

                    }
                }, onError: { error in
                    print(error)
                })
                .disposed(by: self.disposeBag)
    }
    

    fileprivate func configureZipAutoComplete() {
        self.zipSearchText
            .do(onNext: { [weak self] (searchText: String) in
                if searchText.count <= 2 { self?.zipAutoComplete.onNext([]) }
            })
            .filter { (searchText: String) -> Bool in return searchText.count > 2 }
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] (searchText: String) -> Observable<[DAWAZipSuggestion]> in
                guard let self = self else { return Observable<[DAWAZipSuggestion]>.just([]) }
                return self.dawaService.zip(searchText: searchText)
            }
            .bind(to: self.zipAutoComplete)
            .disposed(by: self.disposeBag)
    }

}
