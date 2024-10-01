//
//  BottomSheetConfiguration.swift
//  BottomSheetDemo
//
//  Created by Mikhail Maslo on 15.08.2022.
//  Copyright © 2022 Joom. All rights reserved.
//

import UIKit

public struct BottomSheetConfiguration {
    public let gestureInterceptView: UIView?
    public let cornerRadius: CGFloat

    public init(
        cornerRadius: CGFloat,
        gestureInterceptView: UIView? = nil

    ) {
        self.cornerRadius = cornerRadius
        self.gestureInterceptView = gestureInterceptView
    }

    public static let `default` = BottomSheetConfiguration(
        cornerRadius: 10,
        gestureInterceptView: nil
    )
}
