import 'dart:async';

import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_elevated_button.dart';
import 'package:dotagiftx_mobile/presentation/my_orders/my_orders_view.dart';
import 'package:dotagiftx_mobile/presentation/place_buy_order/states/place_buy_order_state.dart';
import 'package:dotagiftx_mobile/presentation/place_buy_order/subviews/place_buy_order_dota_item_view.dart';
import 'package:dotagiftx_mobile/presentation/place_buy_order/subviews/place_buy_order_guidelines_view.dart';
import 'package:dotagiftx_mobile/presentation/place_buy_order/subviews/place_buy_order_note_field.dart';
import 'package:dotagiftx_mobile/presentation/place_buy_order/subviews/place_buy_order_price_field.dart';
import 'package:dotagiftx_mobile/presentation/place_buy_order/viewmodels/place_buy_order_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaceBuyOrderView extends StatelessWidget
    with ViewCubitMixin<PlaceBuyOrderCubit> {
  final DotaItemModel item;
  const PlaceBuyOrderView({required this.item, super.key});

  @override
  Widget buildView(BuildContext context) {
    return _PlaceBuyOrderView(item: item);
  }
}

class _PlaceBuyOrderView extends StatefulWidget {
  final DotaItemModel item;
  const _PlaceBuyOrderView({required this.item});

  @override
  State<_PlaceBuyOrderView> createState() => _PlaceBuyOrderViewState();
}

class _PlaceBuyOrderViewState extends State<_PlaceBuyOrderView> {
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
          I18n.of(context).placeBuyOrderViewTitle(widget.item.name ?? ''),
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
              PlaceBuyOrderDotaItemView(item: widget.item),
              const SizedBox(height: 16),
              PlaceBuyOrderPriceField(item: widget.item),
              const SizedBox(height: 16),
              const PlaceBuyOrderNoteField(),
              const SizedBox(height: 16),
              // Place order button
              _buildPlaceOrderButton(context),

              // Expiration date
              _buildExpirationDate(context),

              // Guides section
              const PlaceBuyOrderGuidelinesView(),
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

    context.read<PlaceBuyOrderCubit>().showSuccessOrder = () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(I18n.of(context).placeBuyOrderViewSuccessOrder),
          action: SnackBarAction(
            label: I18n.of(context).placeBuyOrderViewSuccessOrderAction,
            onPressed: () {
              unawaited(
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const MyOrdersView(),
                  ),
                ),
              );
            },
          ),
        ),
      );
    };
  }

  Widget _buildExpirationDate(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      alignment: Alignment.center,
      child: Text(
        I18n.of(context).placeBuyOrderViewExpirationDate,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      child: BlocBuilder<PlaceBuyOrderCubit, PlaceBuyOrderState>(
        buildWhen:
            (previous, current) =>
                previous.isPlaceBuyOrderLoading !=
                current.isPlaceBuyOrderLoading,
        builder: (context, state) {
          return AppElevatedButton(
            isLoading: state.isPlaceBuyOrderLoading,
            onPressed: () {
              unawaited(
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              );
              FocusScope.of(context).unfocus();
              unawaited(context.read<PlaceBuyOrderCubit>().placeBuyOrder());
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
                  I18n.of(context).placeBuyOrderViewPlaceOrderButton,
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
