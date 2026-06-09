import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/bloc/juz/juz_bloc.dart';
import '../../../core/util/bloc/quran/quran_bloc.dart';
import '../../../core/util/bloc/surah/surah_bloc.dart';
import '../../../core/util/model/juz.dart';
import '../../../core/util/model/surah.dart';
import '../bloc/selected_juz/selected_juz_bloc.dart';
import '../bloc/selected_surah/selected_surah_bloc.dart';
import '../cubit/quran_cubit.dart';
import '../cubit/quran_reading_cubit.dart';
import '../screen/selected_quran_screen.dart';
import 'last_read_card.dart';

class QuranLastReadSection extends StatelessWidget {
  const QuranLastReadSection({super.key});

  void _openSurahReader(
    BuildContext context, {
    required Surahs surahs,
    required int surahIndex,
    required int lastAyatId,
    required bool fromNav,
  }) {
    QuranReadingCubit? parentCubit;
    try {
      parentCubit = BlocProvider.of<QuranReadingCubit>(context);
    } catch (_) {
      parentCubit = null;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => SelectedSurahBloc(surahs, surahIndex),
          child: BlocProvider(
            create: (context) => QuranCubit(fromNav),
            child: parentCubit != null
                ? BlocProvider.value(
                    value: parentCubit,
                    child: SelectedQuranScreen(
                      surah: true,
                      initialAyatId: lastAyatId,
                    ),
                  )
                : BlocProvider(
                    create: (context) => QuranReadingCubit(),
                    child: SelectedQuranScreen(
                      surah: true,
                      initialAyatId: lastAyatId,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _openJuzReader(
    BuildContext context, {
    required Juzs juzs,
    required int juzIndex,
    required int lastAyatId,
    required bool fromNav,
  }) {
    QuranReadingCubit? parentCubit;
    try {
      parentCubit = BlocProvider.of<QuranReadingCubit>(context);
    } catch (_) {
      parentCubit = null;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => SelectedJuzBloc(juzs, juzIndex),
          child: BlocProvider(
            create: (context) => QuranCubit(fromNav),
            child: parentCubit != null
                ? BlocProvider.value(
                    value: parentCubit,
                    child: SelectedQuranScreen(
                      surah: false,
                      initialAyatId: lastAyatId,
                    ),
                  )
                : BlocProvider(
                    create: (context) => QuranReadingCubit(),
                    child: SelectedQuranScreen(
                      surah: false,
                      initialAyatId: lastAyatId,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranReadingCubit, QuranReadingState>(
      builder: (context, readingState) {
        if (!readingState.hasLastReading) {
          return const SizedBox.shrink();
        }

        final lastAyatId = readingState.lastAyatId;
        if (lastAyatId == null) {
          return const SizedBox.shrink();
        }

        final fromNav = BlocProvider.of<QuranCubit>(context).state.fromNav;
        final ayah = BlocProvider.of<QuranBloc>(context)
            .state
            .qurans
            .findByAyatId(lastAyatId);

        if (readingState.lastMode == 'surah') {
          return BlocBuilder<SurahBloc, SurahState>(
            builder: (context, surahState) {
              final lastSurahId = readingState.lastSurahId;
              if (lastSurahId == null) return const SizedBox.shrink();

              final index = surahState.surahs.surahs
                  .indexWhere((s) => s.id == lastSurahId);
              if (index < 0) return const SizedBox.shrink();

              final surah = surahState.surahs.surahs[index];
              final ayahNum = ayah?.ayatNumber ?? 1;

              return LastReadCard(
                title: surah.nameEn,
                subtitle: 'Surah ${surah.id} • Ayah $ayahNum',
                badgeNumber: surah.id,
                badgeLabel: 'Surah',
                onTap: () => _openSurahReader(
                  context,
                  surahs: surahState.surahs,
                  surahIndex: index,
                  lastAyatId: lastAyatId,
                  fromNav: fromNav,
                ),
              );
            },
          );
        }

        if (readingState.lastMode == 'juz') {
          return BlocBuilder<JuzBloc, JuzState>(
            builder: (context, juzState) {
              final lastJuzId = readingState.lastJuzId;
              if (lastJuzId == null) return const SizedBox.shrink();

              final index =
                  juzState.juzs.juzs.indexWhere((j) => j.id == lastJuzId);
              if (index < 0) return const SizedBox.shrink();

              final juz = juzState.juzs.juzs[index];
              final ayahNum = ayah?.ayatNumber ?? 1;
              final surahNum = ayah?.surahId ?? 1;

              return LastReadCard(
                title: juz.englishName,
                subtitle: 'Juz ${juz.id} • Surah $surahNum • Ayah $ayahNum',
                badgeNumber: juz.id,
                badgeLabel: 'Juz',
                onTap: () => _openJuzReader(
                  context,
                  juzs: juzState.juzs,
                  juzIndex: index,
                  lastAyatId: lastAyatId,
                  fromNav: fromNav,
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
