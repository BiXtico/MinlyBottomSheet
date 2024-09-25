//
//  BottomSheetConfiguration.swift
//  BottomSheetDemo
//
//  Created by Mikhail Maslo on 15.08.2022.
//  Copyright © 2022 Joom. All rights reserved.
//

import UIKit

public struct BottomSheetConfiguration {
    public enum Responsiveness {
        case responsive
        case nonReponsive
        public static let `default`: Responsiveness = .nonReponsive
    }

    public let gestureInterceptView: UIView?
    public let cornerRadius: CGFloat
    public var responsiveness: Responsiveness

    public init(
        cornerRadius: CGFloat,
        bottomSheetOrientation: Responsiveness,
        gestureInterceptView: UIView? = nil

    ) {
        self.cornerRadius = cornerRadius
        self.responsiveness = bottomSheetOrientation
        self.gestureInterceptView = gestureInterceptView
    }

    public static let `default` = BottomSheetConfiguration(
        cornerRadius: 10,
        bottomSheetOrientation: .nonReponsive,
        gestureInterceptView: nil
    )
}
