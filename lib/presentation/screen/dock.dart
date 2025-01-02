import 'package:dock/model/dock_item.dart';
import 'package:dock/presentation/widgets/dock_icon.dart';
import 'package:flutter/material.dart';

class Dock extends StatefulWidget {
  const Dock({super.key});

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> with TickerProviderStateMixin {
  final List<DockItem> dockItems = <DockItem>[
    const DockItem(logo: 'assets/icons/1.png'),
    const DockItem(logo: 'assets/icons/2.png'),
    const DockItem(logo: 'assets/icons/3.png'),
    const DockItem(logo: 'assets/icons/4.png'),
    const DockItem(logo: 'assets/icons/5.png'),
    const DockItem(logo: 'assets/icons/6.png'),
  ];

  bool isHovered = false;

  int? _draggedIndex;
  int? _hoveredIndex;
  late List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = List<GlobalKey>.generate(
      dockItems.length,
      (final int index) => GlobalKey(debugLabel: 'dock-item-$index'),
    );
  }

  void _updateDragPosition(
    final DragUpdateDetails details,
    final int itemIndex,
  ) {
    final RenderBox dock = context.findRenderObject()! as RenderBox;
    final Offset dockPosition = dock.localToGlobal(Offset.zero);
    final Offset dragPosition = details.globalPosition - dockPosition;

    for (int i = 0; i < _itemKeys.length; i++) {
      if (i != _draggedIndex) {
        final GlobalKey<State<StatefulWidget>> currentKey = _itemKeys[i];
        final RenderBox? itemBox =
            currentKey.currentContext?.findRenderObject() as RenderBox?;

        if (itemBox != null) {
          final Offset itemPosition = itemBox.localToGlobal(Offset.zero);
          final Size itemSize = itemBox.size;
          final Rect itemRect = Rect.fromLTWH(
            itemPosition.dx - dockPosition.dx,
            itemPosition.dy - dockPosition.dy,
            itemSize.width,
            itemSize.height,
          );

          if (itemRect.contains(dragPosition)) {
            if (i != itemIndex) {
              setState(() {
                final DockItem item = dockItems.removeAt(itemIndex);
                dockItems.insert(i, item);

                final GlobalKey<State<StatefulWidget>> key =
                    _itemKeys.removeAt(itemIndex);
                _itemKeys.insert(i, key);

                _draggedIndex = i;
              });
            }
            break;
          }
        }
      }
    }
  }

  Draggable<int> _buildDraggableIcon(final int index) {
    final DockItem item = dockItems[index];
    final bool isHovered = _hoveredIndex == index;

    return Draggable<int>(
      key: _itemKeys[index],
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: DockIcon(
          iconPath: item.logo,
        ),
      ),
      childWhenDragging: Container(
        alignment: Alignment.center,
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 6),
      ),
      onDragStarted: () => setState(() => _draggedIndex = index),
      onDragEnd: (final DraggableDetails details) {
        final RenderBox dock = context.findRenderObject()! as RenderBox;
        final Offset dockPosition = dock.localToGlobal(Offset.zero);
        final Offset dragPosition = details.offset - dockPosition;

        for (int i = 0; i < _itemKeys.length; i++) {
          if (i != _draggedIndex) {
            final GlobalKey<State<StatefulWidget>> currentKey = _itemKeys[i];
            final RenderBox? itemBox =
                currentKey.currentContext?.findRenderObject() as RenderBox?;

            if (itemBox != null) {
              final Offset itemPosition = itemBox.localToGlobal(Offset.zero);
              final Size itemSize = itemBox.size;
              final Rect itemRect = Rect.fromLTWH(
                itemPosition.dx - dockPosition.dx,
                itemPosition.dy - dockPosition.dy,
                itemSize.width,
                itemSize.height,
              );

              if (itemRect.contains(dragPosition)) {
                if (i != index) {
                  setState(() {
                    final DockItem item2 = dockItems.removeAt(index);
                    dockItems.insert(i, item2);

                    final GlobalKey<State<StatefulWidget>> key =
                        _itemKeys.removeAt(index);
                    _itemKeys.insert(i, key);

                    _draggedIndex = i;
                  });
                }
                break;
              }
            }
          }
        }
        setState(() => _draggedIndex = null);
      },
      onDragUpdate: (final DragUpdateDetails details) =>
          _updateDragPosition(details, index),
      child: MouseRegion(
        onEnter: (final _) {
          setState(() {
            _hoveredIndex = index;
          });
        },
        onExit: (final _) => setState(() => _hoveredIndex = null),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeIn,
          width: 50,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            tween: Tween<double>(
              begin: 1,
              end: isHovered ? 1.2 : 1.0,
            ),
            builder: (
              final BuildContext context,
              final double scale,
              final Widget? child,
            ) =>
                Transform.scale(
              scale: scale,
              child: child,
            ),
            child: DockIcon(
              iconPath: item.logo,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MouseRegion(
              onEnter: (final _) => setState(() => isHovered = true),
              onExit: (final _) => setState(() => isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 100),
                  tween: Tween<double>(
                    begin: 1,
                    end: isHovered ? 1.1 : 1.0,
                  ),
                  builder: (
                    final BuildContext context,
                    final double scale,
                    final Widget? child,
                  ) {
                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12, width: 0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List<Draggable<int>>.generate(
                        dockItems.length,
                        _buildDraggableIcon,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
