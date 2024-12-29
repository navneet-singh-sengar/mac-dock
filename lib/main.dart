import 'dart:ui';

import 'package:flutter/material.dart';

class DockItem {
  final String logo;

  const DockItem({required this.logo});
}

class MacOSDock extends StatefulWidget {
  const MacOSDock({super.key});

  @override
  State<MacOSDock> createState() => _MacOSDockState();
}

class _MacOSDockState extends State<MacOSDock> with TickerProviderStateMixin {
  final List<DockItem> dockItems = [
    const DockItem(logo: "assets/icons/1.png"),
    const DockItem(logo: "assets/icons/2.png"),
    const DockItem(logo: "assets/icons/3.png"),
    const DockItem(logo: "assets/icons/4.png"),
    const DockItem(logo: "assets/icons/5.png"),
    const DockItem(logo: "assets/icons/6.png"),
  ];

  int? _draggedIndex;
  int? _hoveredIndex;
  late List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(
      dockItems.length,
      (index) => GlobalKey(debugLabel: 'dock-item-$index'),
    );
  }

  void _updateDragPosition(DragUpdateDetails details, int itemIndex) {
    final RenderBox dock = context.findRenderObject() as RenderBox;
    final dockPosition = dock.localToGlobal(Offset.zero);
    final dragPosition = details.globalPosition - dockPosition;

    for (int i = 0; i < _itemKeys.length; i++) {
      if (i != _draggedIndex) {
        final currentKey = _itemKeys[i];
        final RenderBox? itemBox =
            currentKey.currentContext?.findRenderObject() as RenderBox?;

        if (itemBox != null) {
          final itemPosition = itemBox.localToGlobal(Offset.zero);
          final itemSize = itemBox.size;
          final itemRect = Rect.fromLTWH(
            itemPosition.dx - dockPosition.dx,
            itemPosition.dy - dockPosition.dy,
            itemSize.width,
            itemSize.height,
          );

          if (itemRect.contains(dragPosition)) {
            if (i != itemIndex) {
              setState(() {
                final item = dockItems.removeAt(itemIndex);
                dockItems.insert(i, item);

                final key = _itemKeys.removeAt(itemIndex);
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

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MouseRegion(
                onEnter: (_) => setState(() => isHovered = true),
                onExit: (_) => setState(() => isHovered = false),
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.linear,
                      tween: Tween<double>(
                        begin: 1.0,
                        end: isHovered ? 1.1 : 1.0,
                      ),
                      builder: (context, scale, child) {
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
                          children: List.generate(
                            dockItems.length,
                            (index) => _buildDraggableIcon(index),
                          ),
                        ),
                      ),
                    )))
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableIcon(int index) {
    final item = dockItems[index];
    final isHovered = _hoveredIndex == index;

    return Draggable<int>(
      key: _itemKeys[index],
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: Image.asset(
          item.logo,
          width: 50,
          height: 50,
        ),
      ),
      childWhenDragging: Container(
        alignment: Alignment.center,
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 6),
      ),
      onDragStarted: () => setState(() => _draggedIndex = index),
      onDragEnd: (details) {
        final RenderBox dock = context.findRenderObject() as RenderBox;
        final dockPosition = dock.localToGlobal(Offset.zero);
        final dragPosition = details.offset - dockPosition;

        for (int i = 0; i < _itemKeys.length; i++) {
          if (i != _draggedIndex) {
            final currentKey = _itemKeys[i];
            final RenderBox? itemBox =
                currentKey.currentContext?.findRenderObject() as RenderBox?;

            if (itemBox != null) {
              final itemPosition = itemBox.localToGlobal(Offset.zero);
              final itemSize = itemBox.size;
              final itemRect = Rect.fromLTWH(
                itemPosition.dx - dockPosition.dx,
                itemPosition.dy - dockPosition.dy,
                itemSize.width,
                itemSize.height,
              );

              if (itemRect.contains(dragPosition)) {
                if (i != index) {
                  setState(() {
                    final item2 = dockItems.removeAt(index);
                    dockItems.insert(i, item2);

                    final key = _itemKeys.removeAt(index);
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
      onDragUpdate: (details) => _updateDragPosition(details, index),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _hoveredIndex = index;
          });
        },
        onExit: (_) => setState(() => _hoveredIndex = null),
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
              begin: 1.0,
              end: isHovered ? 1.2 : 1.0,
            ),
            builder: (context, scale, child) => Transform.scale(
              scale: scale,
              child: child,
            ),
            child: Image.asset(
              item.logo,
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/wall.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const MacOSDock(),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
