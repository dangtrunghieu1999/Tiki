import UIKit

public protocol ExpandableTextViewPlaceholderDelegate: class {
    func expandableTextViewDidShowPlaceholder(_ textView: ExpandableTextView)
    func expandableTextViewDidHidePlaceholder(_ textView: ExpandableTextView)
}

open class ExpandableTextView: PaddingTextView {

    public weak var placeholderDelegate: ExpandableTextViewPlaceholderDelegate?
    public var limitHeight = true
    
    private let placeholder: PaddingTextView = PaddingTextView()
    
    convenience init() {
        self.init(frame: .zero, textContainer: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.commonInit()
    }

    override open var contentSize: CGSize {
        didSet {
            if limitHeight {
                if contentSize.height < 150 {
                    self.invalidateIntrinsicContentSize()
                    self.layoutIfNeeded()
                }
            } else {
                self.invalidateIntrinsicContentSize()
                self.layoutIfNeeded()
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func commonInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(ExpandableTextView.textDidChange), name: UITextView.textDidChangeNotification, object: self)
        self.updateBoundsToFitSize()
        self.configurePlaceholder()
        self.updatePlaceholderVisibility()
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()

        if self.isPlaceholderViewAttached {
            self.placeholderDelegate?.expandableTextViewDidShowPlaceholder(self)
        } else {
            self.placeholderDelegate?.expandableTextViewDidHidePlaceholder(self)
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.placeholder.frame = self.bounds
    }

    override open var intrinsicContentSize: CGSize {
        return self.contentSize
    }

    override open var text: String! {
        didSet {
            self.textDidChange()
        }
    }

    open var placeholderText: String {
        get {
            return self.placeholder.text
        }
        set {
            self.placeholder.text = newValue
        }
    }

    override open var textContainerInset: UIEdgeInsets {
        didSet {
            self.configurePlaceholder()
        }
    }

    override open var textAlignment: NSTextAlignment {
        didSet {
            self.configurePlaceholder()
        }
    }

    override open func closestPosition(to point: CGPoint) -> UITextPosition? {
        let pointInTextContainer = self.closestPointInTextContainer(to: point)
        return super.closestPosition(to: pointInTextContainer)
    }

    override open func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? {
        let pointInTextContainer = self.closestPointInTextContainer(to: point)
        return super.closestPosition(to: pointInTextContainer, within: range)
    }

    override open func characterRange(at point: CGPoint) -> UITextRange? {
        let pointInTextContainer = self.closestPointInTextContainer(to: point)
        return super.characterRange(at: pointInTextContainer)
    }

    @available(*, deprecated, message: "use placeholderText property instead")
    open func setTextPlaceholder(_ textPlaceholder: String) {
        self.placeholder.text = textPlaceholder
    }

    open func setTextPlaceholderColor(_ color: UIColor) {
        self.placeholder.textColor = color
    }

    open func setTextPlaceholderFont(_ font: UIFont) {
        self.placeholder.font = font
    }

    open func setTextPlaceholderAccessibilityIdentifier(_ accessibilityIdentifier: String) {
        self.placeholder.accessibilityIdentifier = accessibilityIdentifier
    }

    @objc func textDidChange() {
        self.updateBoundsToFitSize()
        self.updatePlaceholderVisibility()
        self.scrollToCaret()

        // Bugfix:
        // 1. Open keyboard
        // 2. Paste very long text (so it snaps to nav bar and shows scroll indicators)
        // 3. Select all and cut
        // 4. Paste again: Texview it's smaller than it should be
        self.isScrollEnabled = false
        self.isScrollEnabled = true
    }

    // MARK: - Private methods

    private func updateBoundsToFitSize() {
        guard #available(iOS 13.0, *) else { return }

        /*
         Since iOS 13 Beta 4, changing a text doesn't cause a recalculation of the content size.
         Because of this, invalidateIntrinsicContentSize is not called, and layout is not updated.
         To fix it, updateBoundsToFitSize should be called on each text change.

         Analyzing a stack trace:
         -[_UITextContainerView setConstrainedFrameSize:] is still called.
         -[_UITextContainerView setFrame:] is NOT called since iOS 13 Beta 4.
         */

        self.bounds.size = self.sizeThatFits(self.bounds.size)
    }

    private func scrollToCaret() {
        if let textRange = self.selectedTextRange {
            var rect = caretRect(for: textRange.end)
            rect = CGRect(origin: rect.origin, size: CGSize(width: rect.width, height: rect.height + textContainerInset.bottom))

            self.scrollRectToVisible(rect, animated: false)
        }
    }

    private func updatePlaceholderVisibility() {
        if self.text == "" {
            self.showPlaceholder()
        } else {
            self.hidePlaceholder()
        }
    }

    private func showPlaceholder() {
        let wasAttachedBeforeShowing = self.isPlaceholderViewAttached
        self.addSubview(self.placeholder)

        if !wasAttachedBeforeShowing {
            self.placeholderDelegate?.expandableTextViewDidShowPlaceholder(self)
        }
    }

    private func hidePlaceholder() {
        let wasAttachedBeforeHiding = self.isPlaceholderViewAttached
        self.placeholder.removeFromSuperview()

        if wasAttachedBeforeHiding {
            self.placeholderDelegate?.expandableTextViewDidHidePlaceholder(self)
        }
    }

    private var isPlaceholderViewAttached: Bool {
        return self.placeholder.superview != nil
    }

    private func configurePlaceholder() {
        self.placeholder.translatesAutoresizingMaskIntoConstraints = false
        self.placeholder.isEditable = false
        self.placeholder.isSelectable = false
        self.placeholder.isUserInteractionEnabled = false
        self.placeholder.textAlignment = self.textAlignment
        self.placeholder.textContainerInset = self.textContainerInset
        self.placeholder.backgroundColor = UIColor.clear
    }

    // When you press on inset area inside UITextView, cursor is automatically moved to beginning of the content.
    // We move press point to the closest point inside text container to avoid this behaviour.
    // Point that is already inside text container or outside of the view itself will not be moved.
    private func closestPointInTextContainer(to point: CGPoint) -> CGPoint {
        guard self.bounds.contains(point) else { return point }
        return point.clamped(to: self.bounds.inset(by: self.textContainerInset))
    }
}
