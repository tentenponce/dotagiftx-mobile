import 'package:dotagiftx_mobile/presentation/core/base/view_cubit_mixin.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/post_item/states/post_item_state.dart';
import 'package:dotagiftx_mobile/presentation/post_item/viewmodels/post_item_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        top: false,
        child: BlocBuilder<PostItemCubit, PostItemState>(
          buildWhen:
              (previous, current) =>
                  previous.isGetItemsLoading != current.isGetItemsLoading,
          builder: (context, state) {
            return state.isGetItemsLoading
                ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
                : SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header description
                      Container(
                        margin: EdgeInsets.only(bottom: 24.h),
                        child: Text(
                          I18n.of(context).postItemViewDescription,
                          style: GoogleFonts.inter(
                            color: AppColors.grey,
                            fontSize: 14.sp,
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
                            child: _buildTextField(
                              label: 'Price',
                              controller: _priceController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          _buildQuantityField(),
                        ],
                      ),

                      // Notes field
                      _buildTextField(
                        label: 'Notes',
                        controller: _notesController,
                        maxLines: 4,
                      ),

                      // Post button
                      _buildPostButton(),

                      // Expiration date
                      _buildExpirationDate(),

                      // Guides section
                      _buildGuidesSection(),
                    ],
                  ),
                );
          },
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
      margin: EdgeInsets.only(bottom: 20.h),
      child: Text(
        'This listing will expires in 30 days - $formattedDate',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          color: AppColors.primary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGuideItem(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h, right: 12.w),
            width: 6.w,
            height: 6.h,
            decoration: const BoxDecoration(
              color: AppColors.grey,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: AppColors.grey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidesSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.only(top: 20.h),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guides for selling Giftables',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          _buildGuideItem(
            'Please make sure your item exist in your inventory.',
          ),
          _buildGuideItem(
            'Dota 2 Giftables transaction only viable if the two steam user parties have been friends for 30 days.',
          ),
          _buildGuideItem(
            'Please be clear in your terms and price. If the price is variable and subject to change, make a new post and remove the old one.',
          ),
          _buildGuideItem(
            'Payment agreements will be done between you and the buyer. This website does not accept or integrate any payment service.',
          ),
        ],
      ),
    );
  }

  Widget _buildItemDropdown() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18n.of(context).postItemViewItemName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
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
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: I18n.of(context).postItemViewItemHint,
                      hintStyle: TextStyle(
                        color: AppColors.grey,
                        fontSize: 14.sp,
                      ),
                      filled: true,
                      fillColor: AppColors.darkGrey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.grey,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ),
                BlocBuilder<PostItemCubit, PostItemState>(
                  buildWhen:
                      (previous, current) =>
                          previous.showDropdown != current.showDropdown ||
                          previous.items != current.items,
                  builder: (context, state) {
                    return state.showDropdown && _itemSearchFocusNode.hasFocus
                        ? Container(
                          constraints: BoxConstraints(maxHeight: 200.h),
                          decoration: BoxDecoration(
                            color: AppColors.darkGrey,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.r),
                              bottomRight: Radius.circular(12.r),
                            ),
                            border: Border(
                              top: BorderSide(
                                color: AppColors.grey.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.items.length,
                            itemBuilder: (context, index) {
                              final item = state.items[index];
                              return InkWell(
                                onTap:
                                    () => context
                                        .read<PostItemCubit>()
                                        .selectItem(item),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border:
                                        index < state.items.length - 1
                                            ? Border(
                                              bottom: BorderSide(
                                                color: AppColors.grey
                                                    .withValues(alpha: 0.2),
                                                width: 0.5,
                                              ),
                                            )
                                            : null,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${item.hero ?? 'Unknown'} - ${item.name ?? 'Unknown'}',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (item.hero != null) ...[
                                              SizedBox(height: 2.h),
                                              Text(
                                                item.hero!,
                                                style: GoogleFonts.inter(
                                                  color: AppColors.grey,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if (item.rarity != null)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getRarityColor(
                                              item.rarity!,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                          ),
                                          child: Text(
                                            item.rarity!,
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        : const SizedBox.shrink();
                  },
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
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: ElevatedButton(
        onPressed: () => context.read<PostItemCubit>().postItem(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          disabledBackgroundColor: AppColors.grey.withValues(alpha: 0.3),
          disabledForegroundColor: AppColors.grey,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Post Item',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityField() {
    return SizedBox(
      width: 100.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Qty',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            keyboardType: TextInputType.number,
            onChanged:
                (value) =>
                    context.read<PostItemCubit>().quantity =
                        int.tryParse(value) ?? 0,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 14.sp),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.darkGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    Widget? suffixWidget,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (label == 'Price') ...[
                Text(
                  ' *',
                  style: GoogleFonts.inter(
                    color: Colors.red,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  maxLines: maxLines ?? 1,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.grey,
                      fontSize: 14.sp,
                    ),
                    filled: true,
                    fillColor: AppColors.darkGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                  ),
                ),
              ),
              if (suffixWidget != null) ...[
                SizedBox(width: 12.w),
                suffixWidget,
              ],
            ],
          ),
          if (label == 'Price') ...[
            SizedBox(height: 4.h),
            Text(
              'Price value will be on USD.',
              style: GoogleFonts.inter(color: AppColors.grey, fontSize: 12.sp),
            ),
          ],
          if (label == 'Notes') ...[
            SizedBox(height: 4.h),
            Text(
              'Keep it short, This will be displayed when they check your offer.',
              style: GoogleFonts.inter(color: AppColors.grey, fontSize: 12.sp),
            ),
          ],
        ],
      ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'immortal':
        return AppColors.immortal;
      case 'mythical':
        return AppColors.mythical;
      case 'rare':
        return AppColors.rare;
      case 'very rare':
        return AppColors.veryRare;
      case 'ultra rare':
        return AppColors.ultraRare;
      default:
        return AppColors.grey;
    }
  }
}
