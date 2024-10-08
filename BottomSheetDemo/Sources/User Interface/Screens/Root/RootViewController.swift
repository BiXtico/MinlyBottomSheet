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

final class RootViewController: UIViewController, DrawerStateDelegate {
    func drawerStateDidChange(to state: BottomSheet.DrawerState) {
        switch state {
        case .opened:
            // Handle when the drawer is opened (e.g., adjust view height)
            print("Drawer opened")
        case .closed:
            // Handle when the drawer is closed
            print("Drawer closed")
        }
    }

    private var drawerManager: DrawerManager!
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
        drawerManager = DrawerManager(parentController: self)
        drawerManager.drawerStateDelegate = self
        setupSubviews()
    }

    private func getCurrentInterfaceOrientation() -> UIInterfaceOrientation {
        if #available(iOS 13.0, *) {
            // Use the current windowScene's interfaceOrientation
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return scene.interfaceOrientation
            }
        } else {
            // Fallback on earlier versions
            return UIApplication.shared.statusBarOrientation
        }
        return .unknown
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

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { context in
            // Code to execute during the transition
        }, completion: { context in
            // Code to execute after the transition
            self.handleOrientationChange() // Call your function here

        })
    }

//
//    private func handleOrientationChangeTest() {
//        // Fetch the current interface orientation more reliably
//        let currentOrientation = getCurrentInterfaceOrientation()
//
//        switch currentOrientation {
//        case .portrait:
//            print("Portrait")
//        // Handle portrait layout changes
//        case .landscapeLeft, .landscapeRight:
//            print("Landscape")
//        // Handle landscape layout changes
//        case .portraitUpsideDown:
//            print("Portrait Upside Down")
//        default:
//            print("Unknown Orientation")
//        }
//    }

    let bottomSheetConfiguration: BottomSheetConfiguration = .init(cornerRadius: 22, portraitSize: 300, landscapeSize: 300)

    @objc
    private func handleOrientationChange() {
        drawerManager.orientationDidChange()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .allButUpsideDown // or specify .portrait, .landscapeLeft, etc.
    }

    override var shouldAutorotate: Bool {
        true // Allow rotation
    }

    @objc
    private func handleShowBottomSheet() {
        presentableController = ResizeViewController(initialHeight: 300, initialWidth: 300)
        guard let strongViewController = presentableController else { return }
        drawerManager.presentDrawer(
            from: self, viewController: strongViewController, configuration: bottomSheetConfiguration, dismissCompletion: {
                self.presentableController = nil
            }
        )
    }
}
