import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_dua/src/core/bloc/language_bloc/language_bloc.dart';
import 'package:al_dua/src/core/util/app_localizations.dart';
import 'package:al_dua/src/core/util/constants.dart';
import 'package:al_dua/src/core/util/model/language_model.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedLanguage = context.watch<LanguageBloc>().state.selectedLanguage;
    
    return PopupMenuButton<AppLanguage>(
      icon: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: Theme.of(context).cardColor,
        ),
        child: Icon(
          Icons.language,
          size: 18.w,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      tooltip: AppLocalizations.of(context).language,
      onSelected: (AppLanguage language) {
        context.read<LanguageBloc>().add(LanguageChanged(language));
      },
      itemBuilder: (BuildContext context) {
        return AppLanguage.values.map((AppLanguage language) {
          return PopupMenuItem<AppLanguage>(
            value: language,
            child: Row(
              children: [
                Text(
                  language.flag,
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(width: 8.w),
                Text(
                  language.displayName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                if (selectedLanguage == language)
                  Icon(
                    Icons.check,
                    size: 16.w,
                    color: Theme.of(context).primaryColor,
                  ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
