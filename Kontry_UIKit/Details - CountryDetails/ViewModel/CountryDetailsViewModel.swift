//
//  CountryDetailsViewModel.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/23/21.
//

import Foundation
import Combine

// Responsibility:
// A viewmodel that handles data/state required by the views from CountryDetailsViewController.
final class CountryDetailsViewModel {
    
    //MARK: - Properties
    
    private var subscription: AnyCancellable?
    private let countriesRepository: CountriesRepositoryProtocol
    
    let loading: VisibilityViewModelProtocol
    let retryError: VisibilityViewModelProtocol
    
    var alpha2Code: String
    
    //MARK: - init Methods
    
    init(
        alpha2Code: String,
        countriesRepository: CountriesRepositoryProtocol,
        loadingViewModel: VisibilityViewModelProtocol,
        retryErrorViewModel: VisibilityViewModelProtocol
    ) {
        self.alpha2Code = alpha2Code
        self.countriesRepository = countriesRepository
        self.loading = loadingViewModel
        self.retryError = retryErrorViewModel
    }
    
    //MARK: - Publishers
    
    let detailsPublisher = PassthroughSubject<CountryDetailsDto, Never>()
        
    //MARK: - Send Events Methods
    
    private func send(details: CountryDetailsModel) {
        detailsPublisher.send(CountryDetailsDto(from: details))
    }
    
    //MARK: - ACTIONS
    
    func loadDetails() {
        cancelPreviousSubscription()
        
        loading.show()
        
        subscription = countriesRepository
            .getCountryDetails(for: alpha2Code)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.loading.hide()
                    
                    if case let .failure(error) = completion {
                        self?.retryError.show()
                        print(error)
                    }
                },
                receiveValue: { [weak self] details in
                    guard let details = details else {
                        self?.retryError.show()
                        return
                    }
                    
                    self?.send(details: details)
                }
            )
    }
    
    func loadCountryDetails(of code: String) -> AnyPublisher<CountryDetailsModel?, Error> {
        return countriesRepository
            .getCountryDetails(for: code)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
 
    func retryLoadCountries() {
        retryError.hide()
        loadDetails()
    }
    
    //MARK: - Helper Methods
    
    private func cancelPreviousSubscription() {
        subscription?.cancel()
        subscription = nil
    }
}
