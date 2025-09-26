import 'dart:async';

import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_elevated_button.dart';
import 'package:dotagiftx_mobile/presentation/my_listings/my_listings_view.dart';
import 'package:dotagiftx_mobile/presentation/post_item/states/post_item_state.dart';
import 'package:dotagiftx_mobile/presentation/post_item/subviews/post_item_dota_item_field.dart';
import 'package:dotagiftx_mobile/presentation/post_item/subviews/post_item_guidelines_view.dart';
import 'package:dotagiftx_mobile/presentation/post_item/subviews/post_item_note_field.dart';
import 'package:dotagiftx_mobile/presentation/post_item/subviews/post_item_price_field.dart';
import 'package:dotagiftx_mobile/presentation/post_item/subviews/post_item_quantity_field.dart';
import 'package:dotagiftx_mobile/presentation/post_item/subviews/post_item_selected_dota_item_view.dart';
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
  final _scrollController = ScrollController();

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
          controller: _scrollController,
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
              const PostItemDotaItemField(),

              const SizedBox(height: 16),

              const PostItemSelectedDotaItemView(),

              const SizedBox(height: 16),

              // Price and Quantity row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: PostItemPriceField()),
                  const SizedBox(width: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 100),
                    child: const IntrinsicWidth(child: PostItemQuantityField()),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Notes field
              const PostItemNoteField(),

              // Post button
              _buildPostButton(context),

              // Expiration date
              _buildExpirationDate(context),

              // Guides section
              const PostItemGuidelinesView(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      FocusScope.of(context).unfocus();
    });

    context.read<PostItemCubit>()
      ..showSuccessPost = () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(I18n.of(context).postItemViewSuccessPost),
            action: SnackBarAction(
              label: I18n.of(context).postItemViewSuccessPostAction,
              onPressed: () {
                unawaited(
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const MyListingsView(),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
      ..showInvalidQuantityError = () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(I18n.of(context).postItemViewInvalidQuantityError),
          ),
        );
      };
  }

  Widget _buildExpirationDate(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      alignment: Alignment.center,
      child: Text(
        I18n.of(context).postItemViewExpirationDate,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPostButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      child: BlocBuilder<PostItemCubit, PostItemState>(
        buildWhen:
            (previous, current) =>
                previous.isPostItemLoading != current.isPostItemLoading,
        builder: (context, state) {
          return AppElevatedButton(
            isLoading: state.isPostItemLoading,
            onPressed: () {
              unawaited(
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              );
              FocusScope.of(context).unfocus();
              unawaited(context.read<PostItemCubit>().postItem());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
