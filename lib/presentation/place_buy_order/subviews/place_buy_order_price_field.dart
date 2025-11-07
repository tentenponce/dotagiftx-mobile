import 'package:dotagiftx_mobile/domain/models/dota_item_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_text_styles.dart';
import 'package:dotagiftx_mobile/presentation/core/utils/number_format_utils.dart';
import 'package:dotagiftx_mobile/presentation/core/widgets/app_text_field.dart';
import 'package:dotagiftx_mobile/presentation/place_buy_order/states/place_buy_order_state.dart';
import 'package:dotagiftx_mobile/presentation/place_buy_order/viewmodels/place_buy_order_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaceBuyOrderPriceField extends StatefulWidget {
  final DotaItemModel item;
  const PlaceBuyOrderPriceField({required this.item, super.key});

  @override
  State<PlaceBuyOrderPriceField> createState() =>
      _PlaceBuyOrderPriceFieldState();
}

class _PlaceBuyOrderPriceFieldState extends State<PlaceBuyOrderPriceField> {
  final TextEditingController _priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((widget.item.bidCount ?? 0) > 0) ...[
          Row(
            children: [
              Text(
                '${widget.item.bidCount ?? 0} ',
                style: AppTextStyles.defaultTextStyle(
                  context,
                ).copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                I18n.of(context).playBuyOrderDotaItemPriceTitle,
                style: AppTextStyles.defaultTextStyle(context).copyWith(
                  color: AppColors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                ' \$${NumberFormatUtils.formatDecimal(widget.item.highestBid, 2)} ',
                style: AppTextStyles.defaultTextStyle(
                  context,
                ).copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                I18n.of(context).playBuyOrderDotaItemPriceTitle2,
                style: AppTextStyles.defaultTextStyle(context).copyWith(
                  color: AppColors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            Text(
              I18n.of(context).postItemViewTextFieldPrice,
              style: AppTextStyles.defaultTextStyle(
                context,
              ).copyWith(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              ' *',
              style: AppTextStyles.defaultTextStyle(context).copyWith(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: BlocBuilder<PlaceBuyOrderCubit, PlaceBuyOrderState>(
                buildWhen:
                    (previous, current) =>
                        previous.isPriceErrorRequired !=
                        current.isPriceErrorRequired,
                builder: (context, state) {
                  return AppTextField(
                    controller: _priceController,
                    onChanged:
                        (value) =>
                            context.read<PlaceBuyOrderCubit>().price = value,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    maxLines: 1,
                    error:
                        state.isPriceErrorRequired
                            ? Text(
                              I18n.of(context).postItemViewPriceErrorRequired,
                              style: AppTextStyles.defaultTextStyle(
                                context,
                              ).copyWith(color: Colors.red),
                            )
                            : null,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          I18n.of(context).postItemViewTextFieldPriceDescription,
          style: AppTextStyles.defaultTextStyle(
            context,
          ).copyWith(color: AppColors.grey, fontSize: 12),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _priceController.text = context.read<PlaceBuyOrderCubit>().price;
  }
}
