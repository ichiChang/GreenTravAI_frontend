import SwiftUI

extension View {
    func popupNavigationView<Content: View>(
        horizontalPadding: CGFloat = 40,
        show: Binding<Bool>,
        useDefaultFrame: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        return self
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay {
                if show.wrappedValue {
                    if useDefaultFrame {
                        GeometryReader { proxy in
                            Color.primary.opacity(0.3)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation {
                                        show.wrappedValue = false
                                    }
                                }
                            
                            NavigationView {
                                content()
                            }
                            .cornerRadius(15)
                            .frame(width: 350, height: 550, alignment: .center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        }
                    } else {
                        content()
                    }
                }
            }
    }
}

extension View {
    /// Helper function to conditionally apply a modifier
    @ViewBuilder func `if`<TrueContent: View>(
        _ condition: Bool,
        modifier: (Self) -> TrueContent
    ) -> some View {
        if condition {
            modifier(self)
        } else {
            self
        }
    }
}
