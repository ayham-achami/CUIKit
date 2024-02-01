//
//  MaterialTextView.swift
//

import UIKit

// MARK: - View

/// TextView с плейсхолдером отъезжающим наверх,
/// подчеркивающей линией и отображением состоянии ошибки.
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
@IBDesignable
public class MaterialTextView: UITextView {

    /// Тип подчета количества символов
    public enum CharactersCountKind {

        /// Соответсвует string.count
        case simple
        /// Соответсвует string.utf8.count
        case utf8
        /// Соответсвует string.utf16.count
        case utf16
    }
    
    private struct Constants {

        let lineOffset = CGFloat(-2.0)
        let underLayersOffset = CGFloat(2.0)

        let placeholderSmallScale = CGFloat(0.78)

        let lineChangeAnimationDuration = CFTimeInterval(0.1)

        var defaultPlaceholderColor: UIColor {
            if #available(iOS 13.0, *) {
                return .secondaryLabel
            } else {
                return .gray
            }
        }

        var defaultUnderlineActiveColor: UIColor {
            if #available(iOS 13.0, *) {
                return .label
            } else {
                return .black
            }
        }
    }
    
    // MARK: - Inspectable

    /// Текст placeholder'a
    @IBInspectable
    public var placeHolderText: String = "Placeholder" {
        didSet {
            placeholderTextLayer.string = placeHolderText
            layoutPlaceholderTextLayer()
        }
    }

    /// Цвет placeholder'a
    @IBInspectable
    public var placeholderColor: UIColor = Constants().defaultPlaceholderColor {
        didSet {
            placeholderTextLayer.foregroundColor = currentPlaceholderColor
        }
    }

    /// Цвет активного placeholder'a
    @IBInspectable
    public var placeholderActiveColor: UIColor?

    /// Размер шрифта placeholder'a
    @IBInspectable
    public var placeholderFontSize: CGFloat = 14.0 {
        didSet {
            placeholderTextLayer.fontSize = placeholderFontSize
            layoutPlaceholderTextLayer()
        }
    }

    /// Высота подчеркивающей линии
    @IBInspectable
    public var underlineHeight: CGFloat = 1.0 {
        didSet {
            lineLayer.frame.size.height = underlineHeight
        }
    }

    /// Цвет подчеркиывающей линии
    @IBInspectable
    public var underlineColor: UIColor = .systemGray {
        didSet {
            lineLayer.backgroundColor = underlineColor.cgColor
        }
    }

    /// Цвет активной подчеркивающей линии
    @IBInspectable
    public var underlineActiveColor: UIColor = Constants().defaultUnderlineActiveColor

    /// Текст ошибки
    @IBInspectable
    public var errorText: String = "Error" {
        didSet {
            errorTextLayer.string = errorText
        }
    }

    /// Цвет ошибки
    @IBInspectable
    public var errorColor: UIColor = .systemRed {
        didSet {
            errorTextLayer.foregroundColor = errorColor.cgColor
        }
    }

    /// Размер шрифта ошибки
    @IBInspectable
    public var errorFontSize: CGFloat = 10.0 {
        didSet {
            errorTextLayer.fontSize = errorFontSize
            layoutErrorTextLayer()
        }
    }

    /// Цвет нормального состояния кол-ва символов (когда текущее кол-во меньше максимальное)
    @IBInspectable
    public var charactersNumberColor: UIColor = .systemGray {
        didSet {
            setNeedsDisplay()
        }
    }

    /// Цвет ошибочного состояния кол-ва символов (когда текущее кол-во превышает максимальное)
    @IBInspectable
    public var charactersNumberErrorColor: UIColor = .systemRed {
        didSet {
            setNeedsDisplay()
        }
    }

    /// Размеры шрифта для отображения кол-ва символов
    @IBInspectable
    public var charactersNumbersFontSize: CGFloat = 10.0 {
        didSet {
            charactersNumbersTextLayer.fontSize = charactersNumbersFontSize
            layoutCharactersNumberTextLayer()
        }
    }

    /// Максимальное кол-во символов (отображается под линией)
    /// При привышении этого числа кол-во символов окрасится в ошибочный цвет
    /// Если параметр установлен `0`, кол-во символов не будет отображатся
    @IBInspectable
    public var charactersMaxValue: Int = 0 {
        didSet {
            charactersNumbersTextLayer.isHidden = charactersMaxValue <= 0
            charactersNumbersTextLayer.string = charactersNumberText
        }
    }

    /// Используется для установки шрифта дополнительным полям текста (плейсхолжер, текст ошибки, кол-во символов)
    public var additionalTextFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            // Замена шрифта
            placeholderTextLayer.font = additionalTextFont
            charactersNumbersTextLayer.font = additionalTextFont
            errorTextLayer.font = additionalTextFont
            // Расчет новых размеров и положения для дополнительных полей
            layoutPlaceholderTextLayer()
            layoutErrorTextLayer()
            layoutCharactersNumberTextLayer()
        }
    }

    /// Валидное ли состояние у textView
    public var isValid: Bool {
        errorTextLayer.isHidden && !(charactersMaxValue > 0 && text.count > charactersMaxValue)
    }

    /// Тип подчета количества символов для textView
    public var charactersCountKind: CharactersCountKind = .utf8

    /// Выключаем скролл у textView, так как это ломает рассчет высоты (*_*)
    public override var isScrollEnabled: Bool {
        get {
            false
        }
        set { // swiftlint:disable:this unused_setter_value
            super.isScrollEnabled = false
        }
    }
    
    // MARK: - Private properties
    
    private let constants = Constants()

    private let placeholderTextLayer: CATextLayer = {
        let layer = CATextLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.anchorPoint = .zero
        layer.isWrapped = true
        layer.truncationMode = .end
        return layer
    }()

    private let errorTextLayer: CATextLayer = {
        let layer = CATextLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.anchorPoint = .zero
        layer.isHidden = true
        layer.isWrapped = true
        layer.truncationMode = .end
        return layer
    }()

    private let charactersNumbersTextLayer: CATextLayer = {
        let layer = CATextLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.isHidden = true
        layer.isWrapped = true
        layer.alignmentMode = .right
        layer.truncationMode = .end
        return layer
    }()

    private let lineLayer = CALayer()

    // MARK: - Lifecycle

    /// Инициализатор с frame и textContainer
    /// - Parameters:
    ///   - frame: frame
    ///   - textContainer: textContainer
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    /// Инициализатор с coder
    /// - Parameter coder: coder
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        // setup lineLayer
        lineLayer.frame = CGRect(x: bounds.minX,
                                 y: bounds.height + constants.lineOffset,
                                 width: bounds.width,
                                 height: underlineHeight)
        layoutPlaceholderTextLayer()
        layoutCharactersNumberTextLayer()
        layoutErrorTextLayer()
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        // setup colors
        setupColors()
    }

    // MARK: - Responder methods override
    public override func becomeFirstResponder() -> Bool {
        defer {
            changeLayersForResponder()
        }
        return super.becomeFirstResponder()
    }

    public override func resignFirstResponder() -> Bool {
        defer {
            changeLayersForResponder()
        }
        return super.resignFirstResponder()
    }

    // MARK: - Show/Hide error text

    /// Отобразить состояние ошибки с заданнм текстом.
    /// Текст ошибки отображается под подчеркивающей линией.
    /// В состоянии ошибки подчеркивающая линия окрашивается в `errorColor`
    /// - Parameter errorText: пояснительный текст ошибки (если не указан используется  собственный `errorText`)
    public func showError(with errorText: String? = nil) {
        if let text = errorText {
            self.errorText = text
        }
        errorTextLayer.isHidden = false
        lineLayer.backgroundColor = errorColor.cgColor
    }

    /// Спрятать состояние ошибки
    public func hideError() {
        errorTextLayer.isHidden = true
        lineLayer.backgroundColor = currentLineColor
    }
}

// MARK: - Computed properties
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension MaterialTextView {

    /// переопределен для корректного изменения позиции
    /// подчеркивающей линии при изменении текста
    override var bounds: CGRect {
        didSet {
            CATransaction.begin()
            CATransaction.setAnimationDuration(constants.lineChangeAnimationDuration)
            lineLayer.position.y = bounds.height + constants.lineOffset
            charactersNumbersTextLayer.position.y = bounds.height + constants.underLayersOffset
            errorTextLayer.position.y = bounds.height + constants.underLayersOffset
            CATransaction.commit()
        }
    }

    /// переопределён для корректного изменения placeholder,
    /// когда устанавливают текст
    override var text: String! {
        didSet {
            placeholderTextLayer.transform = placeholderTransform
            textDidChange()
        }
    }
}

// MARK: - Private methods
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
private extension MaterialTextView {

    var textWidth: CGFloat {
        bounds.width - (textContainerInset.left + textContainer.lineFragmentPadding * 2)
    }

    var placeholderTransform: CATransform3D {
        let isNeedSmall = !text.isEmpty || isFirstResponder
        let y: CGFloat = isNeedSmall ? font?.lineHeight ?? additionalTextFont.lineHeight : 0
        let scale: CGFloat = isNeedSmall ? constants.placeholderSmallScale : 1
        let transform = CATransform3DMakeTranslation(0, -y, 0)
        return CATransform3DScale(transform, scale, scale, 1)
    }

    var currentLineColor: CGColor {
        guard !isValid else {
            return isFirstResponder ? underlineActiveColor.cgColor : underlineColor.cgColor
        }
        return errorColor.cgColor
    }

    var currentPlaceholderColor: CGColor {
        let activeColor = placeholderActiveColor?.cgColor ?? placeholderColor.cgColor
        return isFirstResponder ? activeColor : placeholderColor.cgColor
    }

    var currentCharactersNumberColor: CGColor {
        charactersCount <= charactersMaxValue ? charactersNumberColor.cgColor : charactersNumberErrorColor.cgColor
    }

    var charactersNumberText: String {
        "\(charactersCount)/\(charactersMaxValue)"
    }

    var charactersCount: Int {
        switch charactersCountKind {
        case .simple:
            return text.count
        case .utf8:
            return text.utf8.count
        case .utf16:
            return text.utf16.count
        }
    }

    func setup() {
        setupColors()
        setupTextLayers()

        textContainer.lineFragmentPadding = 0
        clipsToBounds = false

        layer.addSublayer(placeholderTextLayer)
        layer.addSublayer(errorTextLayer)
        layer.addSublayer(lineLayer)
        layer.addSublayer(charactersNumbersTextLayer)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)
    }

    func textHeight(for string: String, in width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let stringOptions: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let boundingBox = string.boundingRect(with: constraintRect,
                                              options: stringOptions,
                                              attributes: [NSAttributedString.Key.font: font],
                                              context: nil)
        return boundingBox.height
    }

    func changeLayersForResponder() {
        lineLayer.backgroundColor = currentLineColor
        placeholderTextLayer.transform = placeholderTransform
        placeholderTextLayer.foregroundColor = currentPlaceholderColor
    }

    @objc func textDidChange() {
        if !errorTextLayer.isHidden { hideError() }

        if lineLayer.backgroundColor != currentLineColor {
            lineLayer.backgroundColor = currentLineColor
        }

        if charactersNumbersTextLayer.foregroundColor != currentCharactersNumberColor {
            charactersNumbersTextLayer.foregroundColor = currentCharactersNumberColor
        }
        charactersNumbersTextLayer.isHidden = charactersMaxValue <= 0
        charactersNumbersTextLayer.string = charactersNumberText
    }

    func setupColors() {
        placeholderTextLayer.foregroundColor = currentPlaceholderColor
        errorTextLayer.foregroundColor = errorColor.cgColor
        lineLayer.backgroundColor = currentLineColor
        charactersNumbersTextLayer.foregroundColor = currentCharactersNumberColor
    }

    func setupTextLayers() {
        placeholderTextLayer.string = placeHolderText
        placeholderTextLayer.fontSize = placeholderFontSize
        errorTextLayer.string = errorText
        errorTextLayer.fontSize = errorFontSize
    }

    func layoutPlaceholderTextLayer() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        placeholderTextLayer.transform = CATransform3DIdentity
        let placeHolderTextHeight = textHeight(for: placeHolderText,
                                               in: textWidth,
                                               font: additionalTextFont.withSize(placeholderFontSize))
        placeholderTextLayer.frame = CGRect(x: textContainerInset.left + textContainer.lineFragmentPadding,
                                            y: textContainerInset.top,
                                            width: textWidth,
                                            height: placeHolderTextHeight)
        placeholderTextLayer.transform = placeholderTransform
        CATransaction.commit()
    }

    func layoutCharactersNumberTextLayer() {
        charactersNumbersTextLayer.fontSize = charactersNumbersFontSize
        let charactersNumbersTextHeight = textHeight(for: charactersNumberText,
                                                     in: textWidth,
                                                     font: additionalTextFont.withSize(charactersNumbersFontSize))
        charactersNumbersTextLayer.frame = CGRect(x: textContainerInset.left + textContainer.lineFragmentPadding,
                                                  y: bounds.height + constants.underLayersOffset,
                                                  width: bounds.width,
                                                  height: charactersNumbersTextHeight)
    }

    func layoutErrorTextLayer() {
        let errorTextHeight = textHeight(for: errorText,
                                         in: textWidth,
                                         font: additionalTextFont.withSize(errorFontSize))
        errorTextLayer.frame = CGRect(x: textContainerInset.left + textContainer.lineFragmentPadding,
                                      y: bounds.height + constants.underLayersOffset,
                                      width: bounds.width,
                                      height: errorTextHeight)
    }
}
