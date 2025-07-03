import 'dart:async';

import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCatalogTextfieldView extends StatefulWidget {
  final TextEditingController controller;

  const SearchCatalogTextfieldView({required this.controller, super.key});

  @override
  State<SearchCatalogTextfieldView> createState() =>
      _SearchCatalogTextfieldViewState();
}

class _SearchCatalogTextfieldViewState
    extends State<SearchCatalogTextfieldView> {
  bool _showClearButton = false;

  // Animation variables for hint text
  Timer? _typingTimer;
  int _currentHintIndex = 0;
  int _currentCharIndex = 0;
  String _animatedHintText = '';
  bool _isTyping = true;

  final List<String> _hintTexts = ['item name', 'hero', 'treasure'];

  String get _displayHintText {
    return _animatedHintText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: widget.controller,
        onChanged: (value) {
          setState(() {
            _showClearButton = value.isNotEmpty;
          });
          unawaited(context.read<HomeCubit>().searchCatalog(query: value));
        },
        decoration: InputDecoration(
          hintText: I18n.of(context).homeSearchHint(_displayHintText),
          hintStyle: const TextStyle(color: AppColors.grey),
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          suffixIcon:
              _showClearButton
                  ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.grey),
                    onPressed: _clearSearch,
                  )
                  : null,
          filled: true,
          fillColor: AppColors.darkGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _showClearButton = widget.controller.text.isNotEmpty;
    _startHintAnimation();
  }

  void _clearSearch() {
    widget.controller.clear();
    setState(() {
      _showClearButton = false;
    });
    unawaited(context.read<HomeCubit>().searchCatalog(query: ''));
  }

  void _startDeletingAnimation() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      setState(() {
        if (_currentCharIndex > 0) {
          _currentCharIndex--;
          _animatedHintText = _hintTexts[_currentHintIndex].substring(
            0,
            _currentCharIndex,
          );
        } else {
          // Finished deleting, move to next hint
          _currentHintIndex = (_currentHintIndex + 1) % _hintTexts.length;
          _isTyping = true;
          timer.cancel();
          _startHintAnimation();
        }
      });
    });
  }

  void _startHintAnimation() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      setState(() {
        if (_isTyping) {
          // Typing animation
          if (_currentCharIndex < _hintTexts[_currentHintIndex].length) {
            _animatedHintText = _hintTexts[_currentHintIndex].substring(
              0,
              _currentCharIndex + 1,
            );
            _currentCharIndex++;
          } else {
            // Finished typing current hint, wait a bit then start deleting
            _isTyping = false;
            timer.cancel();
            Timer(const Duration(milliseconds: 2000), _startDeletingAnimation);
          }
        }
      });
    });
  }
}
