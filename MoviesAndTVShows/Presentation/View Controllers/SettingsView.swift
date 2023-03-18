//
//  SettingsView.swift
//  MoviesAndTVShows
//
//  Created by Luis Fariña on 8/4/23.
//

import SwiftUI

struct SettingsView<ViewModel: SettingsViewModelProtocol>: View {

    // MARK: Properties

    let viewModel: ViewModel

    // MARK: Body

    var body: some View {
        Form {
            Button {
                viewModel.onExportToCSVButtonTrigger()
            } label: {
                Text("Export to CSV")
                    .foregroundColor(.primary)
            }
            Section { } footer: {
                VStack(spacing: 20) {
                    // swiftlint:disable line_length
                    Text("All movie and TV show metadata used in this application is supplied by The Movie Database (TMDB).")
                        .multilineTextAlignment(.center)
                    // swiftlint:enable line_length
                    Image("TheMovieDatabaseLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 45)
                    Text("This application uses the TMDB API but is not endorsed or certified by TMDB.")
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Settings")
    }
}

// MARK: - Previews

struct SettingsView_Previews: PreviewProvider {

    // MARK: Types

    private struct ViewModel: SettingsViewModelProtocol {

        // MARK: Methods

        func onExportToCSVButtonTrigger() {
            // Do nothing
        }
    }

    // MARK: Previews

    static var previews: some View {
        NavigationStack {
            SettingsView(viewModel: ViewModel())
        }
    }
}
