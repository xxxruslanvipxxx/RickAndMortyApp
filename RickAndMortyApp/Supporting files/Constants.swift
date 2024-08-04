//
//  Constants.swift
//  RickAndMortyApp
//
//  Created by Руслан Забиран on 6.07.24.
//

import Foundation

enum API {
    static let baseURL = "https://rickandmortyapi.com/api"
    static let characterPath = "/character"
    static let episodePath = "/episode"
    static let pagePath = "?page="
}

enum ImageName {
    static let appLogo = "appLogo"
    static let loadingComponent = "loadingComponent"
    static let favouritesTabBarImage = "favouritesTabBarImage"
    static let favouritesTabBarImageSelected = "favouritesTabBarImageSelected"
    static let homeTabBarImage = "homeTabBarImage"
    static let homeTabBarImageSelected = "homeTabBarImageSelected"
    static let leadingTextView = "leadingTextView"
    static let filterButtonImage = "filterButtonImage"
    static let systemQuestionmark = "questionmark"
    static let monitorPlay = "monitorPlay"
    static let heart = "heart"
    static let heartFilled = "heartFilled"
}

enum ColorName {
    static let customBackgroundColor = "customBackgroundColor"
}

enum ConstantText {
    static let searchTextFieldPlaceholder = "Name or episode (ex.S01E01)..."
}
