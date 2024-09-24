//
//  BottomSheetConfiguration.swift
//  BottomSheetDemo
//
//  Created by Mikhail Maslo on 15.08.2022.
//  Copyright © 2022 Joom. All rights reserved.
//

import UIKit

public struct BottomSheetConfiguration {
    public enum BottomSheetOrientation {
        case portrait
        case landscape

        public static let `default`: BottomSheetOrientation = .portrait
    }

    public let cornerRadius: CGFloat
    public var bottomSheetOrientation: BottomSheetOrientation

    public init(
        cornerRadius: CGFloat,
        bottomSheetOrientation: BottomSheetOrientation
    ) {
        self.cornerRadius = cornerRadius
        self.bottomSheetOrientation = bottomSheetOrientation
    }

    public static let `default` = BottomSheetConfiguration(
        cornerRadius: 10,
        bottomSheetOrientation: .portrait
    )
}
