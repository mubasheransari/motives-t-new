abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {
  final bool isDark;

  ToggleThemeEvent(this.isDark);
}

class LoadThemeEvent extends ThemeEvent {}
