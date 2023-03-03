# BSwiftUIKitNavigation


### 1. Create Navigator:
```
class Navigator: BSwiftUIKitNavigation  {
    var window: UIWindow {
        get { return UIApplication.keyWindow ?? UIWindow() }
        set { }
    }
    
    init() { }
}
```

### 2. Create Navigator:
```
protocol NavigatorProtocol {
    associatedtype View: SwiftUI.View
    
    @ViewBuilder var view: View { get }
}

extension Navigator {
  struct Root: NavigatorProtocol {
    enum RootItem {
     case root
     case home
    }
        
    var item: RootItem
        
    var view: some View {
      switch item {
        case .root:
          RootView()
            .environmentObject(RootViewModel())
        case .home:
          HomeView()
            .environmentObject(HomeViewModel())
      }
    }
        
    init(_ item: RootItem) {
      self.item = item
    }
  }
}
```

### 3. Use:
```
let navigator = Navigator()
```
```
navigator.pushView(Navigator.Root(.home).view)
```

SwiftUI
```
navigator.pushView(View)
navigator.presentView(View)
navigator.presentViewFullScreen(View)
navigator.replaceView(View)
```

UIKit
```
navigator.push(ViewController)
navigator.present(ViewController)
navigator.presentFullScreen(ViewController)
navigator.replace(ViewController)
```
SwiftUI and UIKit with NavigationController/Stack
```
navigator.dismiss(animated,completion)
navigator.pop(animated)
navigator.popToRoot
```
