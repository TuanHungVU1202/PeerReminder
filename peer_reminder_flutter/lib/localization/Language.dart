class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;
  final String countryCode;

  const Language(
      this.id, this.flag, this.name, this.languageCode, this.countryCode);

  static List<Language> languageList = [
    const Language(1, "🇺🇸", "English", "en", 'US'),
    const Language(12, "🇻🇳", "Tiếng Việt", "vi", 'VN'),
  ];
}
