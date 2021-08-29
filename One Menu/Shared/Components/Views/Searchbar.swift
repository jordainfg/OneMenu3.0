//
//  Searchbar.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 19/08/2020.
//

import SwiftUI
import Combine

public extension View {
    func navigationBarSearch(_ searchText: Binding<String>, placeholder: String? = nil, hidesNavigationBarDuringPresentation: Bool = true, hidesSearchBarWhenScrolling: Bool = true, cancelClicked: @escaping () -> Void = {}, searchClicked: @escaping () -> Void = {}, searchDidBeginEditing: @escaping () -> Void = {}, didEndEditing: @escaping () -> Void = {}) -> some View {
        return overlay(SearchBar<AnyView>(text: searchText, placeholder: placeholder, hidesNavigationBarDuringPresentation: hidesNavigationBarDuringPresentation, hidesSearchBarWhenScrolling: hidesSearchBarWhenScrolling, cancelClicked: cancelClicked, searchClicked: searchClicked, searchDidBeginEditing:searchDidBeginEditing,didEndEditing: didEndEditing).frame(width: 0, height: 0))
    }

    func navigationBarSearch<ResultContent: View>(_ searchText: Binding<String>, placeholder: String? = nil, hidesNavigationBarDuringPresentation: Bool = true, hidesSearchBarWhenScrolling: Bool = true, cancelClicked: @escaping () -> Void = {}, searchClicked: @escaping () -> Void = {}, searchDidBeginEditing: @escaping () -> Void = {}, didEndEditing: @escaping () -> Void = {}, @ViewBuilder resultContent: @escaping (String) -> ResultContent) -> some View {
        return overlay(SearchBar(text: searchText, placeholder: placeholder, hidesNavigationBarDuringPresentation: hidesNavigationBarDuringPresentation, hidesSearchBarWhenScrolling: hidesSearchBarWhenScrolling, cancelClicked: cancelClicked, searchClicked: searchClicked, searchDidBeginEditing:searchDidBeginEditing,didEndEditing: didEndEditing, resultContent: resultContent).frame(width: 0, height: 0))
    }
}

fileprivate struct SearchBar<ResultContent: View>: UIViewControllerRepresentable {
    @Binding
    var text: String
    let placeholder: String?
    let hidesNavigationBarDuringPresentation: Bool
    let hidesSearchBarWhenScrolling: Bool
    let cancelClicked: () -> Void
    let searchClicked: () -> Void
    var searchDidBeginEditing: () -> Void
    var didEndEditing: () -> Void
    
    let resultContent: (String) -> ResultContent?

    init(text: Binding<String>, placeholder: String?, hidesNavigationBarDuringPresentation: Bool, hidesSearchBarWhenScrolling: Bool, cancelClicked: @escaping () -> Void, searchClicked: @escaping () -> Void, searchDidBeginEditing: @escaping () -> Void, didEndEditing: @escaping () -> Void, @ViewBuilder resultContent: @escaping (String) -> ResultContent? = { _ in nil }) {
        self._text = text
        self.placeholder = placeholder
        self.hidesNavigationBarDuringPresentation = hidesNavigationBarDuringPresentation
        self.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
        self.cancelClicked = cancelClicked
        self.searchClicked = searchClicked
        self.resultContent = resultContent
        self.searchDidBeginEditing = searchDidBeginEditing
        self.didEndEditing = didEndEditing
    }

    func makeUIViewController(context: Context) -> SearchBarWrapperController {
        return SearchBarWrapperController()
    }

    func updateUIViewController(_ controller: SearchBarWrapperController, context: Context) {
        controller.searchController = context.coordinator.searchController
        controller.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
        controller.text = text
        if let resultView = resultContent(text) {
            (controller.searchController?.searchResultsController as? UIHostingController<ResultContent>)?.rootView = resultView
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, placeholder: placeholder, hidesNavigationBarDuringPresentation: hidesNavigationBarDuringPresentation, resultContent: resultContent, cancelClicked: cancelClicked, searchClicked: searchClicked, searchDidBeginEditing:searchDidBeginEditing,didEndEditing: didEndEditing)
    }

    class Coordinator: NSObject, UISearchResultsUpdating, UISearchBarDelegate {
        @Binding
        var text: String
        let cancelClicked: () -> Void
        let searchClicked: () -> Void
        let searchController: UISearchController
        var searchDidBeginEditing: () -> Void
        var didEndEditing: () -> Void

        init(text: Binding<String>, placeholder: String?, hidesNavigationBarDuringPresentation: Bool, resultContent: (String) -> ResultContent?, cancelClicked: @escaping () -> Void, searchClicked: @escaping () -> Void, searchDidBeginEditing: @escaping () -> Void, didEndEditing: @escaping () -> Void) {
            self._text = text
            self.cancelClicked = cancelClicked
            self.searchClicked = searchClicked
            self.searchDidBeginEditing = searchDidBeginEditing
            self.didEndEditing = didEndEditing
            let resultView = resultContent(text.wrappedValue)
            let searchResultController = resultView.map { UIHostingController(rootView: $0) }
            self.searchController = UISearchController(searchResultsController: searchResultController)

            super.init()
           

           // UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = String("Cancel".localized)
            searchController.searchResultsUpdater = self
            searchController.hidesNavigationBarDuringPresentation = hidesNavigationBarDuringPresentation
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            searchController.searchBar.searchTextField.textColor = UIColor.white
            
            searchController.searchBar.delegate = self
            if let placeholder = placeholder {
                searchController.searchBar.placeholder = placeholder
            }

            self.searchController.searchBar.text = self.text
        }

        // MARK: - UISearchResultsUpdating
        func updateSearchResults(for searchController: UISearchController) {
            guard let text = searchController.searchBar.text else { return }
            DispatchQueue.main.async {
                self.text = text
            }
        }


        // MARK: - UISearchBarDelegate
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            self.cancelClicked()
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            self.searchClicked()
            
        }
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
            searchDidBeginEditing()
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar){
            didEndEditing()
        }
    }

    class SearchBarWrapperController: UIViewController {
        var text: String? {
            didSet {
                self.parent?.navigationItem.searchController?.searchBar.text = text
            }
        }

        var searchController: UISearchController? {
            didSet {
                self.parent?.navigationItem.searchController = searchController
            }
        }

        var hidesSearchBarWhenScrolling: Bool = true {
            didSet {
                self.parent?.navigationItem.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
            }
        }

        override func viewWillAppear(_ animated: Bool) {
            setup()
        }
        override func viewDidAppear(_ animated: Bool) {
            setup()
        }

        private func setup() {
            self.parent?.navigationItem.searchController = searchController
            self.parent?.navigationItem.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
           

            // make search bar appear at start (default behaviour since iOS 13)
            self.parent?.navigationController?.navigationBar.sizeToFit()
        }
        
        
    }
    
}















struct SearchNavigation<Content: View>: UIViewControllerRepresentable {
    @Binding var text: String
    var searchDidBeginEditing: () -> Void
    var cancel: () -> Void
    var didEndEditing: () -> Void

    var content: () -> Content

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: context.coordinator.rootViewController)
       
        navigationController.navigationBar.sizeToFit()
        context.coordinator.searchController.searchBar.delegate = context.coordinator
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.update(content: content())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(content: content(), searchText: $text, searchBegonAction: searchDidBeginEditing, cancelAction: cancel, searchEndedAction: didEndEditing)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        let rootViewController: UIHostingController<Content>
        let searchController = UISearchController(searchResultsController: nil)
        var searchDidBeginEditing: () -> Void
        var cancel: () -> Void
        var didEndEditing: () -> Void
        init(content: Content, searchText: Binding<String>, searchBegonAction: @escaping () -> Void, cancelAction: @escaping () -> Void, searchEndedAction: @escaping () -> Void) {
            rootViewController = UIHostingController(rootView: content)
            searchController.searchBar.autocapitalizationType = .none
            searchController.obscuresBackgroundDuringPresentation = false
            rootViewController.navigationItem.searchController = searchController
            
            _text = searchText
            searchDidBeginEditing = searchBegonAction
            cancel = cancelAction
            didEndEditing = searchEndedAction
        }
    
    
        func update(content: Content) {
            rootViewController.rootView = content
            rootViewController.view.setNeedsDisplay()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            cancel()
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
            searchDidBeginEditing()
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar){
            didEndEditing()
        }
        
    }
    
}
