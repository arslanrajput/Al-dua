import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';

import '../../home/theme/home_theme.dart';
import '../../utils/loading_widget.dart';
import '../cubit/azkar_categories_cubit.dart';
import '../theme/azkar_theme.dart';
import '../util/azkar_category_icon.dart';
import '../widget/azkar_category_tile.dart';
import '../widget/azkar_featured_card.dart';
import '../widget/azkar_header.dart';
import '../widget/azkar_search_footer.dart';
import '../widget/azkar_language.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AzkarCategoriesCubit()..load(),
      child: const _AzkarView(),
    );
  }
}

class _AzkarView extends StatefulWidget {
  const _AzkarView();

  @override
  State<_AzkarView> createState() => _AzkarViewState();
}

class _AzkarViewState extends State<_AzkarView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCategories() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarCategoriesCubit, AzkarCategoriesState>(
      builder: (context, state) {
        final language = azkarSupportedLanguages.contains(state.language)
            ? state.language
            : azkarSupportedLanguages.first;

        return Scaffold(
          backgroundColor: AzkarTheme.background(context),
          appBar: AppBar(
            backgroundColor: AzkarTheme.background(context),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: true,
            actions: const [],
            title: Text(
              'Azkars',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: HomeTheme.primaryText(context),
                  ),
            ),
            iconTheme: IconThemeData(color: HomeTheme.primaryText(context)),
          ),
          body: _buildBody(context, state, language),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AzkarCategoriesState state,
    Language language,
  ) {
    if (state.status == AzkarLoadStatus.loading ||
        state.status == AzkarLoadStatus.initial) {
      return const LoadingWidget();
    }

    if (state.status == AzkarLoadStatus.error) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            state.errorMessage ?? 'Something went wrong.',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.categories.isEmpty) {
      return Center(
        child: Text(
          'No supplication categories available.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    final morningCategory = findMorningAzkarCategory(state.categories);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: AzkarHeader(
              language: language,
              onLanguageChanged: (lang) {
                context.read<AzkarCategoriesCubit>().load(language: lang);
              },
            ),
          ),
          if (morningCategory != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: AzkarFeaturedCard(
                  category: morningCategory,
                  language: language,
                  title: morningCategory.name.contains('Evening')
                      ? morningCategory.name
                      : 'Morning Azkar',
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Categories',
                      style: AzkarTheme.sectionTitleStyle(context),
                    ),
                  ),
                  TextButton(
                    onPressed: _scrollToCategories,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'See all',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AzkarTheme.mutedText(context),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 0.82,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = state.categories[index];
                return AzkarCategoryTile(
                  category: category,
                  language: language,
                );
              },
              childCount: state.categories.length,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          const SliverToBoxAdapter(child: AzkarSearchFooter()),
        ],
      ),
    );
  }
}
