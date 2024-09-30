//
//  RootViewController.swift
//  BottomSheetDemo
//
//  Created by Mikhail Maslo on 14.11.2021.
//  Copyright © 2021 Joom. All rights reserved.
//

import BottomSheet
import SnapKit
import UIKit

final class RootViewController: UIViewController {
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Show BottomSheet", for: .normal)
        return button
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }

    private func setupSubviews() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }

        // Existing button setup
        let button = UIButton(type: .system)
        button.setTitle("Show Bottom Sheet", for: .normal)
        button.addTarget(self, action: #selector(handleShowBottomSheet), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(44)
        }

        // New button for toast
        let toastButton = UIButton(type: .system)
        toastButton.setTitle("Show Toast", for: .normal)
        toastButton.addTarget(self, action: #selector(handleShowToast), for: .touchUpInside)
        view.addSubview(toastButton)
        toastButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20) // Position it at the top
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(44)
        }
    }

    @objc
    private func handleShowToast() {
        showToast(message: "Button pressed!")
    }

    private func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.addSubview(toastLabel)

        toastLabel.center = CGPoint(x: window!.center.x, y: window!.frame.height - 100)
        toastLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseIn, animations: {
                toastLabel.alpha = 0.0
                toastLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

//    @objc
//    func orientationDidChange() {
//        if let presentedVC = presentedViewController {
//            presentedVC.dismiss(animated: false) {
//                let viewController = ResizeViewController(initialHeight: 300, initialWidth: 300)
//                self.presentBottomSheet(
//                    viewController: viewController,
//                    configuration: .init(cornerRadius: 20, bottomSheetOrientation: UIDevice.current.orientation.isLandscape ? .landscape : .portrait, gestureInterceptView: viewController.gestureInterceptorView),
//                    canBeDismissed: { true },
//                    dismissCompletion: nil
//                )
//            }
//        }
//    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .all // or specify .portrait, .landscapeLeft, etc.
    }

    override var shouldAutorotate: Bool {
        true // Allow rotation
    }

    @objc
    private func handleShowBottomSheet() {
        let viewController = ResizeViewController(initialHeight: 300, initialWidth: 300)
        presentBottomSheet(
            viewController: viewController,
            configuration: .init(cornerRadius: 20, bottomSheetOrientation: .unknown),
            canBeDismissed: {
                // return `true` or `false` based on your business logic
                true
            },
            dismissCompletion: {
                // handle bottom sheet dismissal completion
            }
        )
    }
}
