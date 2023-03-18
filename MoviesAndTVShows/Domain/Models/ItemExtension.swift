//
//  ItemExtension.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 18/3/23.
//

extension Item {

    // MARK: Types

    enum Kind: String, CaseIterable {

        // MARK: Cases

        case movie, tvShow
    }

    enum Progress: String, CaseIterable {

        // MARK: Cases

        case backlog, watching, watched

        // MARK: Properties

        /// The name of the progress.
        var name: String {
            let name: String
            switch self {
            case .backlog:
                name = "Backlog"
            case .watching:
                name = "Watching"
            case .watched:
                name = "Watched"
            }

            return name
        }

        /// The name of the SF Symbol corresponding to the progress.
        var systemImage: String {
            let systemImage: String
            switch self {
            case .backlog:
                systemImage = "square.stack"
            case .watching:
                systemImage = "play.tv"
            case .watched:
                systemImage = "checkmark"
            }

            return systemImage
        }
    }

    // MARK: Properties

    var kind: Kind? {
        get {
            kindString.flatMap(Kind.init)
        }
        set {
            kindString = newValue?.rawValue
        }
    }

    var progress: Progress? {
        get {
            progressString.flatMap(Progress.init)
        }
        set {
            progressString = newValue?.rawValue
        }
    }
}

// MARK: - ItemProtocol

extension Item: ItemProtocol {}
