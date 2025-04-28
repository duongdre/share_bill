import 'package:flutter/material.dart';

import '../../gen/colors.gen.dart';

class AnimatedSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onClear;

  // Add a focus node parameter so it can be controlled from outside
  final FocusNode? focusNode;

  const AnimatedSearchBar({
    super.key,
    required this.onSearch,
    required this.onClear,
    this.focusNode,
  });

  @override
  AnimatedSearchBarState createState() => AnimatedSearchBarState();
}

// Make the state class public instead of private
class AnimatedSearchBarState extends State<AnimatedSearchBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _textController = TextEditingController();
  late FocusNode _focusNode;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    // Use the provided focus node or create a new one
    _focusNode = widget.focusNode ?? FocusNode();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _textController.addListener(() {
      setState(() {
        _showClear = _textController.text.isNotEmpty;
      });
    });

    // Listen for focus changes
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else if (_textController.text.isEmpty) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    _focusNode.removeListener(_onFocusChange);
    // Only dispose the focus node if we created it internally
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: TextField(
            controller: _textController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Search persons or groups...',
              hintStyle: const TextStyle(
                color: ColorName.homeGrayBalance,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.search,
                      color: ColorTween(
                        begin: ColorName.homeGrayBalance,
                        end: ColorName.homeBlackText,
                      ).evaluate(_animation),
                      size: 22,
                    ),
                  );
                },
              ),
              suffixIcon: _showClear
                  ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: ColorName.homeGrayBalance,
                      size: 18,
                    ),
                    onPressed: () {
                      _textController.clear();
                      widget.onClear();
                    },
                  )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: ColorName.homeGrayBalance, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            style: const TextStyle(
              color: ColorName.homeBlackText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: ColorName.homeBlackText,
            onChanged: widget.onSearch,
          ),
        ),
      ),
    );
  }

  // Allow external access to clear the text
  void clearText() {
    _textController.clear();
    widget.onClear();
  }
}
