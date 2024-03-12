
#if os(iOS) || os(tvOS) || os(watchOS)
import SwiftUI
import UIKit


public protocol BSwiftUIKitNavigation: ObservableObject {
    var window: UIWindow { get set }
}

//View
public extension BSwiftUIKitNavigation {
    func presentViewFullScreen(_ view: some View, animated: Bool = true) {
        let controller = DestinationHostingController(rootView: view)
        presentFullScreen(controller, animated: animated)
    }
    
    func presentView(_ view: some View, animated: Bool = true) {
        let controller = DestinationHostingController(rootView: view)
        present(controller, animated: animated)
    }
    
    func pushView(_ view: some View, animated: Bool = true) {
        let controller = DestinationHostingController(rootView: view)
        pushViewController(controller, animated: animated)
    }
    
    func replaceView(_ view: some View, animated: Bool = true) {
        let controller = DestinationHostingController(rootView: view)
        replaceViewController(controller, animated: animated)
    }
}

//UIViewController
public extension BSwiftUIKitNavigation {
    func presentFullScreen(_ viewController: UIViewController, animated: Bool = true) {
        guard let rootViewController = rootViewController else { return }
        
        func present() {
            let presentedVC = getPresentedViewController(rootViewController)
            
            if let popoverPresentationController = viewController.popoverPresentationController {
                popoverPresentationController.sourceView = presentedVC.view
                popoverPresentationController.sourceRect = CGRect(x: presentedVC.view.bounds.midX,
                                                                  y: presentedVC.view.bounds.midY,
                                                                  width: .zero,
                                                                  height: .zero)
                popoverPresentationController.permittedArrowDirections = []
            }
            
            viewController
                .modalPresentationStyle = .fullScreen
            
            presentedVC
                .present(viewController, animated: animated)
        }
        
        if Thread.isMainThread {
            present()
        } else {
            DispatchQueue.main.async {
                present()
            }
        }
    }
    
    func present(_ viewController: UIViewController, animated: Bool = true) {
        guard let rootViewController = rootViewController else { return }
        
        func present() {
            let presentedVC = getPresentedViewController(rootViewController)
            
            if let popoverPresentationController = viewController.popoverPresentationController {
                popoverPresentationController.sourceView = presentedVC.view
                popoverPresentationController.sourceRect = CGRect(x: presentedVC.view.bounds.midX,
                                                                  y: presentedVC.view.bounds.midY,
                                                                  width: .zero,
                                                                  height: .zero)
                popoverPresentationController.permittedArrowDirections = []
            }
            
            presentedVC
                .present(viewController, animated: animated)
        }
        
        if Thread.isMainThread {
            present()
        } else {
            DispatchQueue.main.async {
                present()
            }
        }
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        guard let rootViewController = rootViewController else { return }
        let presentedViewController = getPresentedViewController(rootViewController)
        
        func push() {
            let navc = getNavigationViewController(presentedViewController)
            navc?.pushViewController(viewController, animated: animated)
        }
        
        if Thread.isMainThread {
            push()
        } else {
            DispatchQueue.main.async {
                push()
            }
        }
    }
    
    func replaceViewController(_ viewController: UIViewController, animated: Bool = true) {
        guard let rootViewController = rootViewController else { return }
        
        func replace() {
            let navc = getNavigationViewController(rootViewController)
            navc?.setViewControllers([viewController], animated: animated)
        }
        
        if Thread.isMainThread {
            replace()
        } else {
            DispatchQueue.main.async {
                replace()
            }
        }
    }
}

public extension BSwiftUIKitNavigation {
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let rootViewController = rootViewController else {
            completion?()
            return
        }
        
        func dismiss() {
            getPresentedViewController(rootViewController)
                .dismiss(animated: animated, completion: completion)
        }
        
        if Thread.isMainThread {
            dismiss()
        } else {
            DispatchQueue.main.async {
                dismiss()
            }
        }
    }
    
    func pop(animated: Bool = true) {
        guard let rootViewController = rootViewController else {
            return
        }
        
        func pop() {
            let navc = getNavigationViewController(rootViewController)
            navc?.popViewController(animated: animated)
        }
        
        if Thread.isMainThread {
            pop()
        } else {
            DispatchQueue.main.async {
                pop()
            }
        }
    }
    
    func popToRoot(animated: Bool = true) {
        guard let rootViewController = rootViewController else {
            return
        }
        
        func  popToRoot() {
            let navc = getNavigationViewController(rootViewController)
            navc?.popToRootViewController(animated: animated)
        }
        
        if Thread.isMainThread {
            popToRoot()
        } else {
            DispatchQueue.main.async {
                popToRoot()
            }
        }
    }
}

private extension BSwiftUIKitNavigation {
    var rootViewController: UIViewController? {
        return window.rootViewController
    }
    
    func getPresentedViewController(_ vc: UIViewController) -> UIViewController {
        if let presentedViewController = vc.presentedViewController {
            return getPresentedViewController(presentedViewController)
        }
        
        return vc
    }
    
    func getNavigationViewController(_ vc: UIViewController) -> UINavigationController? {
        let presentedVC = getPresentedViewController(vc)
        
        func findNavigationController(_ vc: UIViewController) -> UINavigationController? {
            guard let children = vc.children.last else { return nil }
            
            if let nvc = children as? UINavigationController {
                return nvc
            } else {
                return getNavigationViewController(children)
            }
        }
        
        return findNavigationController(presentedVC)
    }
}

#endif
