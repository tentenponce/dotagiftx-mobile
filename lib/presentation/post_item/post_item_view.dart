import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/post_item/states/post_item_state.dart';
import 'package:dotagiftx_mobile/presentation/post_item/subviews/post_item_guidelines_view.dart';
import 'package:dotagiftx_mobile/presentation/post_item/subviews/post_item_list_dropdown_view.dart';
import 'package:dotagiftx_mobile/presentation/post_item/subviews/post_item_note_field.dart';
import 'package:dotagiftx_mobile/presentation/post_item/subviews/post_item_price_field.dart';
import 'package:dotagiftx_mobile/presentation/post_item/subviews/post_item_quantity_field.dart';
import 'package:dotagiftx_mobile/presentation/post_item/viewmodels/post_item_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostItemView extends StatelessWidget with ViewCubitMixin<PostItemCubit> {
  const PostItemView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return _PostItemView();
  }
}

class _PostItemView extends StatefulWidget {
  @override
  State<_PostItemView> createState() => _PostItemViewState();
}

class _PostItemViewState extends State<_PostItemView> {
  final _itemSearchFocusNode = FocusNode();
  final TextEditingController _itemSearchController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        surfaceTintColor: AppColors.black,
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          I18n.of(context).postItemViewTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header description
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Text(
                  I18n.of(context).postItemViewDescription,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),

              // Item dropdown
              _buildItemDropdown(),

              // Price and Quantity row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PostItemPriceField(controller: _priceController),
                  ),
                  const SizedBox(width: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 100),
                    child: const IntrinsicWidth(child: PostItemQuantityField()),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Notes field
              PostItemNoteField(controller: _notesController),

              // Post button
              _buildPostButton(),

              // Expiration date
              _buildExpirationDate(),

              // Guides section
              const PostItemGuidelinesView(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _itemSearchController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _itemSearchFocusNode.addListener(() {
      setState(
        () {},
      ); // to rebuild the search item dropdown if not focus then hide dropdown
    });
  }

  Widget _buildExpirationDate() {
    final now = DateTime.now();
    final expirationDate = now.add(const Duration(days: 30));
    final formattedDate =
        '${expirationDate.day.toString().padLeft(2, '0')}/${expirationDate.month.toString().padLeft(2, '0')}/${expirationDate.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Text(
        I18n.of(context).postItemViewExpirationDate(formattedDate),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildItemDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18n.of(context).postItemViewItemName,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.grey.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                BlocListener<PostItemCubit, PostItemState>(
                  listener: (context, state) {
                    if (state.selectedItem != null) {
                      _itemSearchController.text =
                          '${state.selectedItem?.hero ?? 'Unknown'} - ${state.selectedItem?.name ?? 'Unknown'}';
                    }
                  },
                  child: TextField(
                    focusNode: _itemSearchFocusNode,
                    controller: _itemSearchController,
                    onChanged: context.read<PostItemCubit>().filterItems,
                    onTap: () {
                      if (_itemSearchController.text.isNotEmpty) {
                        context.read<PostItemCubit>().filterItems(
                          _itemSearchController.text,
                        );
                      }
                    },
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: I18n.of(context).postItemViewItemHint,
                      hintStyle: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                      ),
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
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                PostItemListDropdownView(
                  itemSearchFocusNode: _itemSearchFocusNode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () => context.read<PostItemCubit>().postItem(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          disabledBackgroundColor: AppColors.grey.withValues(alpha: 0.3),
          disabledForegroundColor: AppColors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check, size: 20),
            const SizedBox(width: 8),
            Text(
              I18n.of(context).postItemViewPostButton,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
