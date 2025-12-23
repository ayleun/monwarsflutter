class SourateItem {
  final int sourateNumber;
  final String nameArabic;
  final String nameFrench;
  final String nameTransliteration;
  final int numberOfAyahs;
  final String revelationType; // Meccan ou Medinan
  final int startPage; // Page de début dans le Mushaf
  final int endPage; // Page de fin dans le Mushaf

  SourateItem({
    required this.sourateNumber,
    required this.nameArabic,
    required this.nameFrench,
    required this.nameTransliteration,
    required this.numberOfAyahs,
    required this.revelationType,
    required this.startPage,
    required this.endPage,
  });
}

