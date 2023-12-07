//
//  RearrangeableCollectionViewLayout.swift
//

import UIKit

/// Протокол делегата
public protocol RearrangeableCollectionViewLayoutDelegate: AnyObject {

    /// Спрашивает у делегата можно ли перемещать ячейку c IndexPath'а
    ///
    /// - parameter collectionView: текущий collectionView
    /// - parameter layout: текущая layout
    /// - parameter index: индекс ячейки
    ///
    /// - returns: возвращает true если ячейку можно перемещать, иначе false
    func collectionView(_ collectionView: UICollectionView, layout: RearrangeableCollectionViewLayout, canMoveItemFrom index: IndexPath) -> Bool

    /// Спрашивает у делегата можно ли переместить ячейку в IndexPath
    ///
    /// - parameter collectionView: текущий collectionView
    /// - parameter layout: текущая layout
    /// - parameter index: индекс ячейки
    ///
    /// - returns: возвращает true если ячейку можно переместить, иначе false
    func collectionView(_ collectionView: UICollectionView, layout: RearrangeableCollectionViewLayout, canMoveItemTo index: IndexPath) -> Bool

    /// Сообщает делегату о завершении перемещения ячейки
    ///
    /// - parameter collectionView: текущий collectionView
    /// - parameter layout: текущая layout
    /// - parameter sourceIndexPath: indexPath источника
    /// - parameter destinationIndexPath: indexPath назначения
    func collectionView(_ collectionView: UICollectionView, layout: RearrangeableCollectionViewLayout, didMoveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)

    /// Сообщает делегату о завершении перемещения ячейки (ячейка уже перемешна полностью)
    ///
    /// - Parameters:
    ///   - collectionView: текущий collectionView
    ///   - layout: текущая layout
    func collectionView(_ collectionView: UICollectionView, finalizeItemDragIn layout: RearrangeableCollectionViewLayout)
}

/// Пакет данных необходимый для перемещния ячейки
private class LayoutBundle {

    var offset: UIOffset

    var sourceIndexPath: IndexPath
    var currentIndexPath: IndexPath
    var sourceCell: UICollectionViewCell

    var cellSnapshotImageView: UIView

    init (_ offset: UIOffset,
          _ sourceIndexPath: IndexPath,
          _ currentIndexPath: IndexPath,
          _ sourceCell: UICollectionViewCell,
          _ cellSnapshotImageView: UIView) {
        self.offset = offset
        self.sourceIndexPath = sourceIndexPath
        self.currentIndexPath = currentIndexPath
        self.sourceCell = sourceCell
        self.cellSnapshotImageView = cellSnapshotImageView
    }

    func set(current indexPath: IndexPath) {
        currentIndexPath = indexPath
    }
}

///  Оси направления перемещения ячейки
public enum LayoutDraggingAxis {

    /// Возможно перемещение по оси X и Y
    case axisXY
    /// Возможно перемещение только по оси X
    case axisX
    /// Возможно перемещение только по оси Y
    case axisY
}

/// Layout с возможностью перемещения элементов
public class RearrangeableCollectionViewLayout: UICollectionViewFlowLayout {

    // MARK: - Public properties

    /// Возможные направления перемещения
    public var layoutDraggingAxis = LayoutDraggingAxis.axisY

    /// Цвет границы ячейки при перемещении
    public var moveCellBorderColor = UIColor.white

    /// Ширина рамки выделения при перемещении
    public var moveCellBorderWidth: CGFloat = 2

    /// Радиус скругления для рамки выделения
    public var moveCellBorderCornerRadius: CGFloat = 2

    /// Делегат layout'а
    public weak var delegate: RearrangeableCollectionViewLayoutDelegate?

    // MARK: - Private properties

    /// Рекогнайзер для жеста перетаскивания
    private lazy var moveGestureRecognizer: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer(target: self,
                                                      action: #selector(moveCollectionViewCells(_:)))
        recognizer.minimumPressDuration = 0.3
        recognizer.delegate = self
        return recognizer
    }()

    /// Пакет данных хранящий информацию о перемещаемой ячейке
    fileprivate var layoutBundle: LayoutBundle?

    /// Frame коллекции на супер вью
    fileprivate var collectionViewFrameInSuperView = CGRect.zero

    // MARK: - Inits
    
    /// Публичный инициализатор с делегатом
    /// - Parameter delegate: delegate rearrangeableCollectionView
    public init(delegate: RearrangeableCollectionViewLayoutDelegate? = nil) {
        super.init()
        self.delegate = delegate
    }
    
    /// Публичный инициализатор с coder
    /// - Parameter aDecoder: coder
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Overrides

    /// Устанавливает возможность длительного нажатия на ячейку (если нажатие до это не было настроено)
    override public func prepare() {
        super.prepare()
        setupLongPressGestureIfNeeded()
    }

    /// Спрашивает объект layout'a, требуется ли обновление layout'a для новых границ (bounds)
    /// - Parameter newBounds: новые границы
    /// - Returns: возвращает true, если требуется обновление layout'a для новых границ, иначе false
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        invalidateLayout()
        return true
    }

    // MARK: - Public methods

    /// Прервать перемещение и отчистить данные
    func invalidateDrag() {
        layoutBundle?.cellSnapshotImageView.removeFromSuperview()
        layoutBundle?.sourceCell.isHidden = false
        layoutBundle = nil
        guard let collectionView = collectionView else { return }
        self.delegate?.collectionView(collectionView, finalizeItemDragIn: self)
    }

    // MARK: - Private methods

    /// Добавляет возможность длительного нажатия на ячейку (если нажатие до это не было настроено)
    fileprivate func setupLongPressGestureIfNeeded() {
        guard let collectionView = collectionView else { return }
        guard let recognizers = collectionView.gestureRecognizers, !recognizers.contains(where: { $0 === moveGestureRecognizer }) else { return }
        collectionView.addGestureRecognizer(moveGestureRecognizer)
    }

    /// Обработчик начала перемещения
    ///
    /// - parameter dragPointOnSuperView: точка перемещения на супер вью
    /// - parameter dragPointOnCollectionView: точка перемещения на коллекции
    fileprivate func handleMoveBegan(_ dragPointOnSuperView: CGPoint, _ dragPointOnCollectionView: CGPoint) {
        guard let collectionView = collectionView, let layoutBundle = layoutBundle else { return }

        collectionView.addSubview(layoutBundle.cellSnapshotImageView)
        layoutBundle.sourceCell.isHidden = true
    }

    /// Обработчик перемещения
    ///
    /// - parameter dragPointOnSuperView: точка перемещения на супер вью
    /// - parameter dragPointOnCollectionView: точка перемещения на коллекции
    fileprivate func handleMoveChanged(_ dragPointOnSuperView: CGPoint, _ dragPointOnCollectionView: CGPoint) {
        // swiftlint:disable:previous cyclomatic_complexity
        guard let collectionView = collectionView, let layoutBundle = layoutBundle else { return }

        var boundedPoint = dragPointOnSuperView
        var cellSnapshotImageViewFrame = layoutBundle.cellSnapshotImageView.frame

        if boundedPoint.y > collectionView.frame.maxY {
            boundedPoint.y = collectionView.frame.maxY
        } else if boundedPoint.y < collectionView.frame.minY {
            boundedPoint.y = collectionView.frame.minY
        }

        if boundedPoint.x > collectionView.frame.maxX {
            boundedPoint.x = collectionView.frame.maxX
        } else if boundedPoint.x < collectionView.frame.minX {
            boundedPoint.x = collectionView.frame.minX
        }

        var newLocation = CGPoint(x: boundedPoint.x - layoutBundle.offset.horizontal,
                                  y: boundedPoint.y - layoutBundle.offset.vertical)

        if layoutDraggingAxis == .axisX {
            newLocation.y = cellSnapshotImageViewFrame.origin.y
        } else if layoutDraggingAxis == .axisY {
            newLocation.x = cellSnapshotImageViewFrame.origin.x
        }

        cellSnapshotImageViewFrame.origin = newLocation
        layoutBundle.cellSnapshotImageView.frame = cellSnapshotImageViewFrame

        var point = dragPointOnCollectionView
        if layoutDraggingAxis == .axisX {
            point.y = layoutBundle.cellSnapshotImageView.center.y
        } else if layoutDraggingAxis == .axisY {
            point.x = layoutBundle.cellSnapshotImageView.center.x
        }

        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        let canMoveToIndexPath = delegate?.collectionView(collectionView, layout: self, canMoveItemTo: indexPath) ?? true
        guard canMoveToIndexPath == true else { return }
        collectionView.performBatchUpdates({
            collectionView.moveItem(at: layoutBundle.currentIndexPath, to: indexPath)
            layoutBundle.set(current: indexPath)
        })
    }

    /// Обработчик окончания перемещения
    ///
    /// - parameter dragPointOnSuperView: точка перемещения на супер вью
    /// - parameter dragPointOnCollectionView: точка перемещения на коллекции
    fileprivate func handleMoveEnded(_ dragPointOnSuperView: CGPoint, _ dragPointOnCollectionView: CGPoint) {
        defer { invalidateDrag() }
        guard let collectionView = collectionView, let layoutBundle = layoutBundle else { return }

        if layoutBundle.sourceIndexPath != layoutBundle.currentIndexPath {
            delegate?.collectionView(collectionView, layout: self, didMoveItemAt: layoutBundle.sourceIndexPath, to: layoutBundle.currentIndexPath)
        }
    }

    /// Обработчик отмены перемещения
    fileprivate func handleMoveCancelled() {
        invalidateDrag()
    }

    // MARK: - Actions
    @objc fileprivate func moveCollectionViewCells(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard let collectionView = collectionView, let superView = collectionView.superview else { return }

        let dragPointOnSuperView = gestureRecognizer.location(in: superView)
        let dragPointOnCollectionView = gestureRecognizer.location(in: collectionView)

        switch gestureRecognizer.state {
        case .began:
            handleMoveBegan(dragPointOnSuperView, dragPointOnCollectionView)
        case .changed:
            handleMoveChanged(dragPointOnSuperView, dragPointOnCollectionView)
        case .ended:
            handleMoveEnded(dragPointOnSuperView, dragPointOnCollectionView)
        default:
            handleMoveCancelled()
        }
    }
}

// MARK: - RearrangeableCollectionViewLayout + UIGestureRecognizerDelegate
extension RearrangeableCollectionViewLayout: UIGestureRecognizerDelegate {
    
    /// Спрашивает делегат, должен ли gestureRecognizer начать обработку касаний
    /// - Parameter gestureRecognizer: gestureRecognizer
    /// - Returns: возвращает true, чтобы сообщить gestureRecognizer продолжить обработку касаний, false - чтобы предотвратить попытки распознать свой жест
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let collectionView = collectionView else { return false }

        let point = gestureRecognizer.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return false }

        let canMoveCell = delegate?.collectionView(collectionView, layout: self, canMoveItemFrom: indexPath) ?? true
        guard canMoveCell == true else { return false }

        guard let cell = collectionView.cellForItem(at: indexPath) else { return false }
        cell.layer.cornerRadius = moveCellBorderCornerRadius
        cell.layer.borderWidth = moveCellBorderWidth
        cell.layer.borderColor = moveCellBorderColor.cgColor

        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.isOpaque, 0)
        cell.layer.render(in: UIGraphicsGetCurrentContext()!)
        let cellSnapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor.clear.cgColor

        let cellSnapshotImageView = UIImageView(image: cellSnapshot)
        cellSnapshotImageView.frame = cell.frame

        let pointOnSuperView = gestureRecognizer.location(in: collectionView)
        let offset = UIOffset(horizontal: pointOnSuperView.x - cellSnapshotImageView.frame.origin.x,
                              vertical: pointOnSuperView.y - cellSnapshotImageView.frame.origin.y)

        layoutBundle = LayoutBundle(offset, indexPath, indexPath, cell, cellSnapshotImageView)
        return true
    }
}
