import CoreGraphics

public extension CGFloat {
    func bma_round(scale: CGFloat = UIScreen.main.scale) -> CGFloat {
        return ceil(self * scale) * (1.0 / scale)
    }
}
