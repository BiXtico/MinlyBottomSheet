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

    var presentableController: ResizeViewController?

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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleOrientationChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    private func getCurrentInterfaceOrientation() -> UIInterfaceOrientation {
        if #available(iOS 13.0, *) {
            // Use the current windowScene's interfaceOrientation
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return scene.interfaceOrientation
            }
            return .unknown
        } else {
            // Fallback on earlier versions
            return UIApplication.shared.statusBarOrientation
        }
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
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @objc
    private func handleOrientationChangeTest() {
        // Fetch the current interface orientation more reliably
        let currentOrientation = getCurrentInterfaceOrientation()

        switch currentOrientation {
        case .portrait:
            print("Portrait")
        // Handle portrait layout changes
        case .landscapeLeft, .landscapeRight:
            print("Landscape")
        // Handle landscape layout changes
        case .portraitUpsideDown:
            print("Portrait Upside Down")
        default:
            print("Unknown Orientation")
        }
    }

    @objc
    private func handleOrientationChange() {
        // Fetch the current interface orientation more reliably
        let currentOrientation = getCurrentInterfaceOrientation()
        print(currentOrientation)

//        if presentableController != nil {
//            presentableController?.dismiss(animated: false)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.presentableController = ResizeViewController(initialHeight: 300, initialWidth: 300)
//                guard let strongViewController = self.presentableController else { return }
//
//                // Use the current orientation to determine the configuration or perform additional logic if needed
//                let bottomSheetConfiguration: BottomSheetConfiguration
//                switch currentOrientation {
//                case .portrait:
//                    print("Portrait")
//                    bottomSheetConfiguration = .init(cornerRadius: 20, bottomSheetOrientation: .portrait, gestureInterceptView: strongViewController.gestureInterceptorView)
//                case .landscapeLeft, .landscapeRight:
//                    print("Landscape")
//                    bottomSheetConfiguration = .init(cornerRadius: 20, bottomSheetOrientation: .landscape, gestureInterceptView: strongViewController.gestureInterceptorView)
//                default:
//                    bottomSheetConfiguration = .init(cornerRadius: 20, bottomSheetOrientation: .portrait, gestureInterceptView: strongViewController.gestureInterceptorView)
//                }
//                self.presentBottomSheet(
//                    viewController: strongViewController,
//                    configuration: bottomSheetConfiguration,
//                    canBeDismissed: { true },
//                    dismissCompletion: {
//                        self.presentableController = nil
//                    }
//                )
//            }
//        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .all // or specify .portrait, .landscapeLeft, etc.
    }

    override var shouldAutorotate: Bool {
        true // Allow rotation
    }

    @objc
    private func handleShowBottomSheet() {
        presentableController = ResizeViewController(initialHeight: 300, initialWidth: 300)
        guard let strongViewController = presentableController else { return }
        let currentOrientation = getCurrentInterfaceOrientation()
        presentBottomSheet(
            viewController: strongViewController,
            configuration: .init(cornerRadius: 20),
//            currentOrientation.isLandscape ? .landscape : .portrait
            canBeDismissed: {
                // return `true` or `false` based on your business logic
                true
            },
            dismissCompletion: {
                self.presentableController = nil
            }
        )
    }
}
