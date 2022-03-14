import Foundation
import SwiftUI

struct TabChildItem {
    let presentable: ViewPresentable
    let keyPathIsEqual: (Any) -> Bool
    let tabItem: (Bool) -> AnyView
    let onPopToRoot: () -> Void
}

/// Wrapper around childCoordinators
/// Used so that you don't need to write @Published
public class TabChild: ObservableObject {
    weak var parent: ChildDismissable?
    public let startingItems: [AnyKeyPath]
    
    @Published var activeItem: TabChildItem!
    
    var allItems: [TabChildItem]!
    var isFirstTime: Bool = true
    
    public var activeTab: Int {
        didSet {
            guard oldValue != activeTab else {
                if isFirstTime {
                    isFirstTime = false
                    allItems[activeTab].onPopToRoot()
                    isFirstTime = true
                }
                return
            }
            
            let newItem = allItems[activeTab]
            self.activeItem = newItem
        }
    }
    
    public init(startingItems: [AnyKeyPath], activeTab: Int = 0) {
        self.startingItems = startingItems
        self.activeTab = activeTab
    }
}
