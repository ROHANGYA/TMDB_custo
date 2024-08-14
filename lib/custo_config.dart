import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb/config/core_config.dart';
import 'package:tmdb/constants.dart';
import 'package:tmdb_custo/router_custo.dart';

class CustoConfig extends CoreConfig {
  @override
  GoRouter routeConfig() {
    return goRouterConfigCusto;
  }

  @override
  ThemeData lightTheme() {
    return super.lightTheme().copyWith(
        chipTheme: ChipThemeData(
            backgroundColor: MyColors.charcoal,
            selectedColor: MyColors.crayolaGold,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: const BorderSide(color: MyColors.charcoal, width: 0.0),
            labelStyle: super.lightTheme().textTheme.displaySmall,
            labelPadding: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 8)));
  }
}
