import Foundation

import RxSwift
import RxSwiftExt
import RxCocoa

import CoreLocation

import MustacheServices

public protocol DawaViewModelType {

    var addressSearchText: PublishSubject<String> { get }
    var zipSearchText: PublishSubject<String> { get }

    var cursorPosition: PublishSubject<Int> { get }

    var autoCompleteChoices: PublishSubject<[AutoCompleteModel]> { get }
    var chosenAutoCompleteChoice: PublishSubject<AutoCompleteModel> { get }

    var autoCompleteAddress: PublishSubject<DAWAAddressProtol> { get }
    var zipAutoComplete: PublishSubject<[ZipAutoCompleteModel]> { get }

    var type: AutoCompleteType { get set }

    func getNearest() -> Observable<DAWAAddressProtol?>

}

open class DawaViewModel: NSObject, DawaViewModelType {

    public let addressSearchText = PublishSubject<String>()
    public let zipSearchText = PublishSubject<String>()

    public let cursorPosition = PublishSubject<Int>()

    public let autoCompleteChoices = PublishSubject<[AutoCompleteModel]>()
    public let chosenAutoCompleteChoice = PublishSubject<AutoCompleteModel>()

    public let autoCompleteAddress = PublishSubject<DAWAAddressProtol>()

    public var zipAutoComplete = PublishSubject<[ZipAutoCompleteModel]>()

    fileprivate let disposeBag = DisposeBag()

    fileprivate let dawaService: DAWAServiceType
    fileprivate let locationService: RxGeoLocationServiceType

    public var type: AutoCompleteType = .adgangsadresse

    public init(services: ServicesType) throws {
        self.dawaService = try services.get()
        self.locationService = try services.get()
        super.init()

        self.configureAutoComplete()
        self.configureChosenAutoCompleteChoice()
        self.configureZipAutoComplete()
    }

    public func getNearest() -> Observable<DAWAAddressProtol?> {
        return self.locationService.location
                .take(1)
                .timeout(3, scheduler: MainScheduler.asyncInstance)
                .map { return $0 as CLLocation? }
                .catchErrorJustReturn(nil)
                .flatMapLatest { [weak self] location -> Observable<DAWAAddressProtol?> in
                    guard let self = self, let location = location else { return Observable<DAWAAddressProtol?>.just(nil) }
                    return self.dawaService.nearest(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, type: self.type).map { return $0 as DAWAAddressProtol? }
                }
    }

    fileprivate func configureAutoComplete() {

        self.addressSearchText
                .do(onNext: { [weak self] (searchText: String) in
                    if searchText.count <= 2 { self?.autoCompleteChoices.onNext([]) }
                })
                .filter { (searchText: String) -> Bool in return searchText.count > 2 }
                .throttle(1.0, scheduler: MainScheduler.instance)
                .flatMapLatest { [weak self] (searchText: String) -> Observable<[AutoCompleteModel]> in
                    guard let self = self else { return Observable<[AutoCompleteModel]>.just([]) }
                    return self.dawaService.choices(searchText: searchText, type: self.type)
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
                            _ = self.dawaService.address(href: choice.id!, type: choice.type)
                                .subscribe(onNext: { [weak self, type = self.type] address in
                                                self?.autoCompleteAddress.onNext(address)
                                            }, onError: { error in
                                                print(error)
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
            .throttle(1.0, scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] (searchText: String) -> Observable<[ZipAutoCompleteModel]> in
                guard let self = self else { return Observable<[ZipAutoCompleteModel]>.just([]) }
                return self.dawaService.zip(searchText: searchText)
            }
            .bind(to: self.zipAutoComplete)
            .disposed(by: self.disposeBag)
    }

}
