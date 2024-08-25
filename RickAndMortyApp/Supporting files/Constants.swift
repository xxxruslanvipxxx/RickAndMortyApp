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
    static let nameFilterPath = "/?name="
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
    static let systemPlaceholder = "photo"
    static let logoBlack = "logoBlack"
    static let camera = "camera"
    static let systemArrowBackward = "arrow.backward"
}

enum ColorName {
    static let customBackgroundColor = "customBackgroundColor"
    static let mainDark = "mainDarkTextColor"
}

enum ConstantText {
    static let searchTextFieldPlaceholder = "Name or episode (ex.S01E01)..."
    static let goBackButton = "GO BACK"
    static let informationsLabel = "Informations"
    static let verticalBar = "|"
    static let actionSheetTitle = "Upload image"
    static let actionSheetButtonCamera = "Camera"
    static let actionSheetButtonGallery = "Gallery"
    static let favoritesLabelText =  "Favorite characters"
}
