import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../../../core/util/theme.dart';
import '../../home/theme/home_theme.dart';
import '../../utils/loading_widget.dart';
import '../cubit/azkar_items_cubit.dart';
import '../widget/azkar_language.dart';
import '../cubit/azkar_categories_cubit.dart';
import '../theme/azkar_theme.dart';

class AzkarItemsScreen extends StatelessWidget {
  const AzkarItemsScreen({
    super.key,
    required this.chapterId,
    required this.chapterTitle,
    required this.language,
  });

  final int chapterId;
  final String chapterTitle;
  final AzkarLanguage language;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AzkarItemsCubit(
        chapterId: chapterId,
        chapterTitle: chapterTitle,
        language: language,
      )..load(),
      child: const _AzkarItemsView(),
    );
  }
}

class _AzkarItemsView extends StatelessWidget {
  const _AzkarItemsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarItemsCubit, AzkarItemsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AzkarTheme.background(context),
          appBar: AppBar(
            backgroundColor: AzkarTheme.background(context),
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: AzkarTheme.primaryText(context)),
            title: Text(
              state.chapterTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appBarTitleTextStyle(
                color: AzkarTheme.primaryText(context),
                fontSize: 18.sp,
              ),
            ),
          ),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (state.status == AzkarLoadStatus.loading ||
                    state.status == AzkarLoadStatus.initial) {
                  return const LoadingWidget();
                }
                if (state.status == AzkarLoadStatus.error) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'Something went wrong.',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (state.items.isEmpty) {
                  return Center(
                    child: Text(
                      'No Azkars found.',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    final arabic = item.item;
                    final translation = item.translation;
                    final reference = item.reference;

                    return _AzkarItemCard(
                      arabic: arabic,
                      translation: translation,
                      reference: reference,
                      isUrdu: state.language == AzkarLanguage.ur,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _AzkarItemCard extends StatelessWidget {
  const _AzkarItemCard({
    required this.arabic,
    required this.translation,
    required this.reference,
    required this.isUrdu,
  });

  final String arabic;
  final String translation;
  final String reference;
  final bool isUrdu;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? HomeTheme.darkCardElevated : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: 0.08),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (arabic.isNotEmpty)
                            Text(
                              arabic,
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontFamily: 'Uthman',
                                    height: 1.7,
                                    fontWeight: FontWeight.w600,
                                    color: AzkarTheme.primaryText(context),
                                  ),
                            ),
                          if (arabic.isNotEmpty && translation.isNotEmpty)
                            SizedBox(height: 10.h),
                          if (translation.isNotEmpty)
                            Text(
                              translation,
                              textAlign: isUrdu ? TextAlign.right : null,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontFamily: isUrdu ? 'Jameel' : null,
                                    height: isUrdu ? 1.6 : 1.4,
                                    color: AzkarTheme.primaryText(context),
                                  ),
                            ),
                          if (reference.isNotEmpty) ...[
                            SizedBox(height: 10.h),
                            Text(
                              reference,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AzkarTheme.mutedText(context),
                                  ),
                            ),
                          ],
                        ],
                      ),
    );
  }
}

