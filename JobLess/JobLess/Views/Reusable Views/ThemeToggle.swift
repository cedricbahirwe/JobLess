//
//  ThemeToggle.swift
//  JobLess
//
//  Created by Cédric Bahirwe on 07/09/2022.
//

import SwiftUI

struct ThemeToggle: View {
    @AppStorage("app.colorscheme")
    private var appTheme: AppTheme = .dark

    var body: some View {
        Picker("App Theme", selection: $appTheme) {
            ForEach(AppTheme.allCases, id: \.self) { theme in
                Text(theme.rawValue.capitalized)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .colorScheme(.dark)
    }
}
struct ThemeToggle_Previews: PreviewProvider {
    static var previews: some View {
        ThemeToggle()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
