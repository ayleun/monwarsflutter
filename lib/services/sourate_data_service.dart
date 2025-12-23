import '../models/sourate_item.dart';
import 'juzz_data_service.dart';

class SourateDataService {
  // Liste complète des 114 sourates du Coran avec leurs pages de début et fin
  static List<SourateItem> getAllSourates() {
    return [
      SourateItem(sourateNumber: 1, nameArabic: 'الفاتحة', nameFrench: 'Al-Fatiha', nameTransliteration: 'Al-Fatiha', numberOfAyahs: 7, revelationType: 'Meccan', startPage: 1, endPage: 1),
      SourateItem(sourateNumber: 2, nameArabic: 'البقرة', nameFrench: 'Al-Baqarah', nameTransliteration: 'Al-Baqarah', numberOfAyahs: 286, revelationType: 'Medinan', startPage: 2, endPage: 49),
      SourateItem(sourateNumber: 3, nameArabic: 'آل عمران', nameFrench: 'Al-Imran', nameTransliteration: 'Al-Imran', numberOfAyahs: 200, revelationType: 'Medinan', startPage: 50, endPage: 76),
      SourateItem(sourateNumber: 4, nameArabic: 'النساء', nameFrench: 'An-Nisa', nameTransliteration: 'An-Nisa', numberOfAyahs: 176, revelationType: 'Medinan', startPage: 77, endPage: 106),
      SourateItem(sourateNumber: 5, nameArabic: 'المائدة', nameFrench: 'Al-Ma\'idah', nameTransliteration: 'Al-Ma\'idah', numberOfAyahs: 120, revelationType: 'Medinan', startPage: 107, endPage: 126),
      SourateItem(sourateNumber: 6, nameArabic: 'الأنعام', nameFrench: 'Al-An\'am', nameTransliteration: 'Al-An\'am', numberOfAyahs: 165, revelationType: 'Meccan', startPage: 128, endPage: 150),
      SourateItem(sourateNumber: 7, nameArabic: 'الأعراف', nameFrench: 'Al-A\'raf', nameTransliteration: 'Al-A\'raf', numberOfAyahs: 206, revelationType: 'Meccan', startPage: 151, endPage: 176),
      SourateItem(sourateNumber: 8, nameArabic: 'الأنفال', nameFrench: 'Al-Anfal', nameTransliteration: 'Al-Anfal', numberOfAyahs: 75, revelationType: 'Medinan', startPage: 177, endPage: 186),
      SourateItem(sourateNumber: 9, nameArabic: 'التوبة', nameFrench: 'At-Tawbah', nameTransliteration: 'At-Tawbah', numberOfAyahs: 129, revelationType: 'Medinan', startPage: 187, endPage: 207),
      SourateItem(sourateNumber: 10, nameArabic: 'يونس', nameFrench: 'Yunus', nameTransliteration: 'Yunus', numberOfAyahs: 109, revelationType: 'Meccan', startPage: 208, endPage: 221),
      SourateItem(sourateNumber: 11, nameArabic: 'هود', nameFrench: 'Hud', nameTransliteration: 'Hud', numberOfAyahs: 123, revelationType: 'Meccan', startPage: 221, endPage: 235),
      SourateItem(sourateNumber: 12, nameArabic: 'يوسف', nameFrench: 'Yusuf', nameTransliteration: 'Yusuf', numberOfAyahs: 111, revelationType: 'Meccan', startPage: 235, endPage: 248),
      SourateItem(sourateNumber: 13, nameArabic: 'الرعد', nameFrench: 'Ar-Ra\'d', nameTransliteration: 'Ar-Ra\'d', numberOfAyahs: 43, revelationType: 'Medinan', startPage: 249, endPage: 255),
      SourateItem(sourateNumber: 14, nameArabic: 'إبراهيم', nameFrench: 'Ibrahim', nameTransliteration: 'Ibrahim', numberOfAyahs: 52, revelationType: 'Meccan', startPage: 255, endPage: 261),
      SourateItem(sourateNumber: 15, nameArabic: 'الحجر', nameFrench: 'Al-Hijr', nameTransliteration: 'Al-Hijr', numberOfAyahs: 99, revelationType: 'Meccan', startPage: 262, endPage: 267),
      SourateItem(sourateNumber: 16, nameArabic: 'النحل', nameFrench: 'An-Nahl', nameTransliteration: 'An-Nahl', numberOfAyahs: 128, revelationType: 'Meccan', startPage: 267, endPage: 281),
      SourateItem(sourateNumber: 17, nameArabic: 'الإسراء', nameFrench: 'Al-Isra', nameTransliteration: 'Al-Isra', numberOfAyahs: 111, revelationType: 'Meccan', startPage: 282, endPage: 293),
      SourateItem(sourateNumber: 18, nameArabic: 'الكهف', nameFrench: 'Al-Kahf', nameTransliteration: 'Al-Kahf', numberOfAyahs: 110, revelationType: 'Meccan', startPage: 293, endPage: 305),
      SourateItem(sourateNumber: 19, nameArabic: 'مريم', nameFrench: 'Maryam', nameTransliteration: 'Maryam', numberOfAyahs: 98, revelationType: 'Meccan', startPage: 305, endPage: 312),
      SourateItem(sourateNumber: 20, nameArabic: 'طه', nameFrench: 'Ta-Ha', nameTransliteration: 'Ta-Ha', numberOfAyahs: 135, revelationType: 'Meccan', startPage: 312, endPage: 321),
      SourateItem(sourateNumber: 21, nameArabic: 'الأنبياء', nameFrench: 'Al-Anbiya', nameTransliteration: 'Al-Anbiya', numberOfAyahs: 112, revelationType: 'Meccan', startPage: 322, endPage: 331),
      SourateItem(sourateNumber: 22, nameArabic: 'الحج', nameFrench: 'Al-Hajj', nameTransliteration: 'Al-Hajj', numberOfAyahs: 78, revelationType: 'Medinan', startPage: 332, endPage: 341),
      SourateItem(sourateNumber: 23, nameArabic: 'المؤمنون', nameFrench: 'Al-Mu\'minun', nameTransliteration: 'Al-Mu\'minun', numberOfAyahs: 118, revelationType: 'Meccan', startPage: 342, endPage: 349),
      SourateItem(sourateNumber: 24, nameArabic: 'النور', nameFrench: 'An-Nur', nameTransliteration: 'An-Nur', numberOfAyahs: 64, revelationType: 'Medinan', startPage: 350, endPage: 359),
      SourateItem(sourateNumber: 25, nameArabic: 'الفرقان', nameFrench: 'Al-Furqan', nameTransliteration: 'Al-Furqan', numberOfAyahs: 77, revelationType: 'Meccan', startPage: 359, endPage: 366),
      SourateItem(sourateNumber: 26, nameArabic: 'الشعراء', nameFrench: 'Ash-Shu\'ara', nameTransliteration: 'Ash-Shu\'ara', numberOfAyahs: 227, revelationType: 'Meccan', startPage: 367, endPage: 376),
      SourateItem(sourateNumber: 27, nameArabic: 'النمل', nameFrench: 'An-Naml', nameTransliteration: 'An-Naml', numberOfAyahs: 93, revelationType: 'Meccan', startPage: 377, endPage: 385),
      SourateItem(sourateNumber: 28, nameArabic: 'القصص', nameFrench: 'Al-Qasas', nameTransliteration: 'Al-Qasas', numberOfAyahs: 88, revelationType: 'Meccan', startPage: 385, endPage: 396),
      SourateItem(sourateNumber: 29, nameArabic: 'العنكبوت', nameFrench: 'Al-Ankabut', nameTransliteration: 'Al-Ankabut', numberOfAyahs: 69, revelationType: 'Meccan', startPage: 396, endPage: 404),
      SourateItem(sourateNumber: 30, nameArabic: 'الروم', nameFrench: 'Ar-Rum', nameTransliteration: 'Ar-Rum', numberOfAyahs: 60, revelationType: 'Meccan', startPage: 404, endPage: 411),
      SourateItem(sourateNumber: 31, nameArabic: 'لقمان', nameFrench: 'Luqman', nameTransliteration: 'Luqman', numberOfAyahs: 34, revelationType: 'Meccan', startPage: 411, endPage: 415),
      SourateItem(sourateNumber: 32, nameArabic: 'السجدة', nameFrench: 'As-Sajdah', nameTransliteration: 'As-Sajdah', numberOfAyahs: 30, revelationType: 'Meccan', startPage: 415, endPage: 417),
      SourateItem(sourateNumber: 33, nameArabic: 'الأحزاب', nameFrench: 'Al-Ahzab', nameTransliteration: 'Al-Ahzab', numberOfAyahs: 73, revelationType: 'Medinan', startPage: 418, endPage: 427),
      SourateItem(sourateNumber: 34, nameArabic: 'سبأ', nameFrench: 'Saba', nameTransliteration: 'Saba', numberOfAyahs: 54, revelationType: 'Meccan', startPage: 428, endPage: 434),
      SourateItem(sourateNumber: 35, nameArabic: 'فاطر', nameFrench: 'Fatir', nameTransliteration: 'Fatir', numberOfAyahs: 45, revelationType: 'Meccan', startPage: 434, endPage: 440),
      SourateItem(sourateNumber: 36, nameArabic: 'يس', nameFrench: 'Ya-Sin', nameTransliteration: 'Ya-Sin', numberOfAyahs: 83, revelationType: 'Meccan', startPage: 440, endPage: 445),
      SourateItem(sourateNumber: 37, nameArabic: 'الصافات', nameFrench: 'As-Saffat', nameTransliteration: 'As-Saffat', numberOfAyahs: 182, revelationType: 'Meccan', startPage: 446, endPage: 452),
      SourateItem(sourateNumber: 38, nameArabic: 'ص', nameFrench: 'Sad', nameTransliteration: 'Sad', numberOfAyahs: 88, revelationType: 'Meccan', startPage: 453, endPage: 458),
      SourateItem(sourateNumber: 39, nameArabic: 'الزمر', nameFrench: 'Az-Zumar', nameTransliteration: 'Az-Zumar', numberOfAyahs: 75, revelationType: 'Meccan', startPage: 458, endPage: 467),
      SourateItem(sourateNumber: 40, nameArabic: 'غافر', nameFrench: 'Ghafir', nameTransliteration: 'Ghafir', numberOfAyahs: 85, revelationType: 'Meccan', startPage: 467, endPage: 476),
      SourateItem(sourateNumber: 41, nameArabic: 'فصلت', nameFrench: 'Fussilat', nameTransliteration: 'Fussilat', numberOfAyahs: 54, revelationType: 'Meccan', startPage: 477, endPage: 482),
      SourateItem(sourateNumber: 42, nameArabic: 'الشورى', nameFrench: 'Ash-Shura', nameTransliteration: 'Ash-Shura', numberOfAyahs: 53, revelationType: 'Meccan', startPage: 483, endPage: 489),
      SourateItem(sourateNumber: 43, nameArabic: 'الزخرف', nameFrench: 'Az-Zukhruf', nameTransliteration: 'Az-Zukhruf', numberOfAyahs: 89, revelationType: 'Meccan', startPage: 489, endPage: 495),
      SourateItem(sourateNumber: 44, nameArabic: 'الدخان', nameFrench: 'Ad-Dukhan', nameTransliteration: 'Ad-Dukhan', numberOfAyahs: 59, revelationType: 'Meccan', startPage: 496, endPage: 498),
      SourateItem(sourateNumber: 45, nameArabic: 'الجاثية', nameFrench: 'Al-Jathiyah', nameTransliteration: 'Al-Jathiyah', numberOfAyahs: 37, revelationType: 'Meccan', startPage: 499, endPage: 502),
      SourateItem(sourateNumber: 46, nameArabic: 'الأحقاف', nameFrench: 'Al-Ahqaf', nameTransliteration: 'Al-Ahqaf', numberOfAyahs: 35, revelationType: 'Meccan', startPage: 502, endPage: 506),
      SourateItem(sourateNumber: 47, nameArabic: 'محمد', nameFrench: 'Muhammad', nameTransliteration: 'Muhammad', numberOfAyahs: 38, revelationType: 'Medinan', startPage: 507, endPage: 510),
      SourateItem(sourateNumber: 48, nameArabic: 'الفتح', nameFrench: 'Al-Fath', nameTransliteration: 'Al-Fath', numberOfAyahs: 29, revelationType: 'Medinan', startPage: 511, endPage: 515),
      SourateItem(sourateNumber: 49, nameArabic: 'الحجرات', nameFrench: 'Al-Hujurat', nameTransliteration: 'Al-Hujurat', numberOfAyahs: 18, revelationType: 'Medinan', startPage: 515, endPage: 517),
      SourateItem(sourateNumber: 50, nameArabic: 'ق', nameFrench: 'Qaf', nameTransliteration: 'Qaf', numberOfAyahs: 45, revelationType: 'Meccan', startPage: 518, endPage: 520),
      SourateItem(sourateNumber: 51, nameArabic: 'الذاريات', nameFrench: 'Adh-Dhariyat', nameTransliteration: 'Adh-Dhariyat', numberOfAyahs: 60, revelationType: 'Meccan', startPage: 520, endPage: 523),
      SourateItem(sourateNumber: 52, nameArabic: 'الطور', nameFrench: 'At-Tur', nameTransliteration: 'At-Tur', numberOfAyahs: 49, revelationType: 'Meccan', startPage: 523, endPage: 525),
      SourateItem(sourateNumber: 53, nameArabic: 'النجم', nameFrench: 'An-Najm', nameTransliteration: 'An-Najm', numberOfAyahs: 62, revelationType: 'Meccan', startPage: 526, endPage: 528),
      SourateItem(sourateNumber: 54, nameArabic: 'القمر', nameFrench: 'Al-Qamar', nameTransliteration: 'Al-Qamar', numberOfAyahs: 55, revelationType: 'Meccan', startPage: 528, endPage: 531),
      SourateItem(sourateNumber: 55, nameArabic: 'الرحمن', nameFrench: 'Ar-Rahman', nameTransliteration: 'Ar-Rahman', numberOfAyahs: 78, revelationType: 'Medinan', startPage: 531, endPage: 534),
      SourateItem(sourateNumber: 56, nameArabic: 'الواقعة', nameFrench: 'Al-Waqi\'ah', nameTransliteration: 'Al-Waqi\'ah', numberOfAyahs: 96, revelationType: 'Meccan', startPage: 534, endPage: 537),
      SourateItem(sourateNumber: 57, nameArabic: 'الحديد', nameFrench: 'Al-Hadid', nameTransliteration: 'Al-Hadid', numberOfAyahs: 29, revelationType: 'Medinan', startPage: 537, endPage: 541),
      SourateItem(sourateNumber: 58, nameArabic: 'المجادلة', nameFrench: 'Al-Mujadila', nameTransliteration: 'Al-Mujadila', numberOfAyahs: 22, revelationType: 'Medinan', startPage: 542, endPage: 545),
      SourateItem(sourateNumber: 59, nameArabic: 'الحشر', nameFrench: 'Al-Hashr', nameTransliteration: 'Al-Hashr', numberOfAyahs: 24, revelationType: 'Medinan', startPage: 545, endPage: 548),
      SourateItem(sourateNumber: 60, nameArabic: 'الممتحنة', nameFrench: 'Al-Mumtahanah', nameTransliteration: 'Al-Mumtahanah', numberOfAyahs: 13, revelationType: 'Medinan', startPage: 549, endPage: 551),
      SourateItem(sourateNumber: 61, nameArabic: 'الصف', nameFrench: 'As-Saff', nameTransliteration: 'As-Saff', numberOfAyahs: 14, revelationType: 'Medinan', startPage: 551, endPage: 552),
      SourateItem(sourateNumber: 62, nameArabic: 'الجمعة', nameFrench: 'Al-Jumu\'ah', nameTransliteration: 'Al-Jumu\'ah', numberOfAyahs: 11, revelationType: 'Medinan', startPage: 553, endPage: 554),
      SourateItem(sourateNumber: 63, nameArabic: 'المنافقون', nameFrench: 'Al-Munafiqun', nameTransliteration: 'Al-Munafiqun', numberOfAyahs: 11, revelationType: 'Medinan', startPage: 554, endPage: 555),
      SourateItem(sourateNumber: 64, nameArabic: 'التغابن', nameFrench: 'At-Taghabun', nameTransliteration: 'At-Taghabun', numberOfAyahs: 18, revelationType: 'Medinan', startPage: 556, endPage: 558),
      SourateItem(sourateNumber: 65, nameArabic: 'الطلاق', nameFrench: 'At-Talaq', nameTransliteration: 'At-Talaq', numberOfAyahs: 12, revelationType: 'Medinan', startPage: 558, endPage: 559),
      SourateItem(sourateNumber: 66, nameArabic: 'التحريم', nameFrench: 'At-Tahrim', nameTransliteration: 'At-Tahrim', numberOfAyahs: 12, revelationType: 'Medinan', startPage: 560, endPage: 561),
      SourateItem(sourateNumber: 67, nameArabic: 'الملك', nameFrench: 'Al-Mulk', nameTransliteration: 'Al-Mulk', numberOfAyahs: 30, revelationType: 'Meccan', startPage: 562, endPage: 564),
      SourateItem(sourateNumber: 68, nameArabic: 'القلم', nameFrench: 'Al-Qalam', nameTransliteration: 'Al-Qalam', numberOfAyahs: 52, revelationType: 'Meccan', startPage: 564, endPage: 566),
      SourateItem(sourateNumber: 69, nameArabic: 'الحاقة', nameFrench: 'Al-Haqqah', nameTransliteration: 'Al-Haqqah', numberOfAyahs: 52, revelationType: 'Meccan', startPage: 566, endPage: 568),
      SourateItem(sourateNumber: 70, nameArabic: 'المعارج', nameFrench: 'Al-Ma\'arij', nameTransliteration: 'Al-Ma\'arij', numberOfAyahs: 44, revelationType: 'Meccan', startPage: 568, endPage: 570),
      SourateItem(sourateNumber: 71, nameArabic: 'نوح', nameFrench: 'Nuh', nameTransliteration: 'Nuh', numberOfAyahs: 28, revelationType: 'Meccan', startPage: 571, endPage: 573),
      SourateItem(sourateNumber: 72, nameArabic: 'الجن', nameFrench: 'Al-Jinn', nameTransliteration: 'Al-Jinn', numberOfAyahs: 28, revelationType: 'Meccan', startPage: 573, endPage: 575),
      SourateItem(sourateNumber: 73, nameArabic: 'المزمل', nameFrench: 'Al-Muzzammil', nameTransliteration: 'Al-Muzzammil', numberOfAyahs: 20, revelationType: 'Meccan', startPage: 575, endPage: 577),
      SourateItem(sourateNumber: 74, nameArabic: 'المدثر', nameFrench: 'Al-Muddaththir', nameTransliteration: 'Al-Muddaththir', numberOfAyahs: 56, revelationType: 'Meccan', startPage: 577, endPage: 579),
      SourateItem(sourateNumber: 75, nameArabic: 'القيامة', nameFrench: 'Al-Qiyamah', nameTransliteration: 'Al-Qiyamah', numberOfAyahs: 40, revelationType: 'Meccan', startPage: 579, endPage: 580),
      SourateItem(sourateNumber: 76, nameArabic: 'الإنسان', nameFrench: 'Al-Insan', nameTransliteration: 'Al-Insan', numberOfAyahs: 31, revelationType: 'Medinan', startPage: 580, endPage: 582),
      SourateItem(sourateNumber: 77, nameArabic: 'المرسلات', nameFrench: 'Al-Mursalat', nameTransliteration: 'Al-Mursalat', numberOfAyahs: 50, revelationType: 'Meccan', startPage: 582, endPage: 583),
      SourateItem(sourateNumber: 78, nameArabic: 'النبأ', nameFrench: 'An-Naba', nameTransliteration: 'An-Naba', numberOfAyahs: 40, revelationType: 'Meccan', startPage: 583, endPage: 585),
      SourateItem(sourateNumber: 79, nameArabic: 'النازعات', nameFrench: 'An-Nazi\'at', nameTransliteration: 'An-Nazi\'at', numberOfAyahs: 46, revelationType: 'Meccan', startPage: 585, endPage: 587),
      SourateItem(sourateNumber: 80, nameArabic: 'عبس', nameFrench: 'Abasa', nameTransliteration: 'Abasa', numberOfAyahs: 42, revelationType: 'Meccan', startPage: 587, endPage: 589),
      SourateItem(sourateNumber: 81, nameArabic: 'التكوير', nameFrench: 'At-Takwir', nameTransliteration: 'At-Takwir', numberOfAyahs: 29, revelationType: 'Meccan', startPage: 589, endPage: 590),
      SourateItem(sourateNumber: 82, nameArabic: 'الانفطار', nameFrench: 'Al-Infitar', nameTransliteration: 'Al-Infitar', numberOfAyahs: 19, revelationType: 'Meccan', startPage: 590, endPage: 590),
      SourateItem(sourateNumber: 83, nameArabic: 'المطففين', nameFrench: 'Al-Mutaffifin', nameTransliteration: 'Al-Mutaffifin', numberOfAyahs: 36, revelationType: 'Meccan', startPage: 590, endPage: 592),
      SourateItem(sourateNumber: 84, nameArabic: 'الانشقاق', nameFrench: 'Al-Inshiqaq', nameTransliteration: 'Al-Inshiqaq', numberOfAyahs: 25, revelationType: 'Meccan', startPage: 592, endPage: 593),
      SourateItem(sourateNumber: 85, nameArabic: 'البروج', nameFrench: 'Al-Buruj', nameTransliteration: 'Al-Buruj', numberOfAyahs: 22, revelationType: 'Meccan', startPage: 593, endPage: 594),
      SourateItem(sourateNumber: 86, nameArabic: 'الطارق', nameFrench: 'At-Tariq', nameTransliteration: 'At-Tariq', numberOfAyahs: 17, revelationType: 'Meccan', startPage: 594, endPage: 595),
      SourateItem(sourateNumber: 87, nameArabic: 'الأعلى', nameFrench: 'Al-A\'la', nameTransliteration: 'Al-A\'la', numberOfAyahs: 19, revelationType: 'Meccan', startPage: 595, endPage: 596),
      SourateItem(sourateNumber: 88, nameArabic: 'الغاشية', nameFrench: 'Al-Ghashiyah', nameTransliteration: 'Al-Ghashiyah', numberOfAyahs: 26, revelationType: 'Meccan', startPage: 596, endPage: 597),
      SourateItem(sourateNumber: 89, nameArabic: 'الفجر', nameFrench: 'Al-Fajr', nameTransliteration: 'Al-Fajr', numberOfAyahs: 30, revelationType: 'Meccan', startPage: 597, endPage: 599),
      SourateItem(sourateNumber: 90, nameArabic: 'البلد', nameFrench: 'Al-Balad', nameTransliteration: 'Al-Balad', numberOfAyahs: 20, revelationType: 'Meccan', startPage: 599, endPage: 600),
      SourateItem(sourateNumber: 91, nameArabic: 'الشمس', nameFrench: 'Ash-Shams', nameTransliteration: 'Ash-Shams', numberOfAyahs: 15, revelationType: 'Meccan', startPage: 600, endPage: 601),
      SourateItem(sourateNumber: 92, nameArabic: 'الليل', nameFrench: 'Al-Layl', nameTransliteration: 'Al-Layl', numberOfAyahs: 21, revelationType: 'Meccan', startPage: 601, endPage: 602),
      SourateItem(sourateNumber: 93, nameArabic: 'الضحى', nameFrench: 'Ad-Duha', nameTransliteration: 'Ad-Duha', numberOfAyahs: 11, revelationType: 'Meccan', startPage: 602, endPage: 602),
      SourateItem(sourateNumber: 94, nameArabic: 'الشرح', nameFrench: 'Ash-Sharh', nameTransliteration: 'Ash-Sharh', numberOfAyahs: 8, revelationType: 'Meccan', startPage: 602, endPage: 603),
      SourateItem(sourateNumber: 95, nameArabic: 'التين', nameFrench: 'At-Tin', nameTransliteration: 'At-Tin', numberOfAyahs: 8, revelationType: 'Meccan', startPage: 603, endPage: 603),
      SourateItem(sourateNumber: 96, nameArabic: 'العلق', nameFrench: 'Al-Alaq', nameTransliteration: 'Al-Alaq', numberOfAyahs: 19, revelationType: 'Meccan', startPage: 603, endPage: 604),
      SourateItem(sourateNumber: 97, nameArabic: 'القدر', nameFrench: 'Al-Qadr', nameTransliteration: 'Al-Qadr', numberOfAyahs: 5, revelationType: 'Meccan', startPage: 604, endPage: 604),
      SourateItem(sourateNumber: 98, nameArabic: 'البينة', nameFrench: 'Al-Bayyinah', nameTransliteration: 'Al-Bayyinah', numberOfAyahs: 8, revelationType: 'Medinan', startPage: 604, endPage: 605),
      SourateItem(sourateNumber: 99, nameArabic: 'الزلزلة', nameFrench: 'Az-Zalzalah', nameTransliteration: 'Az-Zalzalah', numberOfAyahs: 8, revelationType: 'Medinan', startPage: 605, endPage: 605),
      SourateItem(sourateNumber: 100, nameArabic: 'العاديات', nameFrench: 'Al-Adiyat', nameTransliteration: 'Al-Adiyat', numberOfAyahs: 11, revelationType: 'Meccan', startPage: 606, endPage: 606),
      SourateItem(sourateNumber: 101, nameArabic: 'القارعة', nameFrench: 'Al-Qari\'ah', nameTransliteration: 'Al-Qari\'ah', numberOfAyahs: 11, revelationType: 'Meccan', startPage: 606, endPage: 607),
      SourateItem(sourateNumber: 102, nameArabic: 'التكاثر', nameFrench: 'At-Takathur', nameTransliteration: 'At-Takathur', numberOfAyahs: 8, revelationType: 'Meccan', startPage: 607, endPage: 607),
      SourateItem(sourateNumber: 103, nameArabic: 'العصر', nameFrench: 'Al-Asr', nameTransliteration: 'Al-Asr', numberOfAyahs: 3, revelationType: 'Meccan', startPage: 607, endPage: 607),
      SourateItem(sourateNumber: 104, nameArabic: 'الهمزة', nameFrench: 'Al-Humazah', nameTransliteration: 'Al-Humazah', numberOfAyahs: 9, revelationType: 'Meccan', startPage: 607, endPage: 608),
      SourateItem(sourateNumber: 105, nameArabic: 'الفيل', nameFrench: 'Al-Fil', nameTransliteration: 'Al-Fil', numberOfAyahs: 5, revelationType: 'Meccan', startPage: 608, endPage: 608),
      SourateItem(sourateNumber: 106, nameArabic: 'قريش', nameFrench: 'Quraysh', nameTransliteration: 'Quraysh', numberOfAyahs: 4, revelationType: 'Meccan', startPage: 608, endPage: 609),
      SourateItem(sourateNumber: 107, nameArabic: 'الماعون', nameFrench: 'Al-Ma\'un', nameTransliteration: 'Al-Ma\'un', numberOfAyahs: 7, revelationType: 'Meccan', startPage: 609, endPage: 609),
      SourateItem(sourateNumber: 108, nameArabic: 'الكوثر', nameFrench: 'Al-Kawthar', nameTransliteration: 'Al-Kawthar', numberOfAyahs: 3, revelationType: 'Meccan', startPage: 609, endPage: 609),
      SourateItem(sourateNumber: 109, nameArabic: 'الكافرون', nameFrench: 'Al-Kafirun', nameTransliteration: 'Al-Kafirun', numberOfAyahs: 6, revelationType: 'Meccan', startPage: 609, endPage: 610),
      SourateItem(sourateNumber: 110, nameArabic: 'النصر', nameFrench: 'An-Nasr', nameTransliteration: 'An-Nasr', numberOfAyahs: 3, revelationType: 'Medinan', startPage: 610, endPage: 610),
      SourateItem(sourateNumber: 111, nameArabic: 'المسد', nameFrench: 'Al-Masad', nameTransliteration: 'Al-Masad', numberOfAyahs: 5, revelationType: 'Meccan', startPage: 610, endPage: 611),
      SourateItem(sourateNumber: 112, nameArabic: 'الإخلاص', nameFrench: 'Al-Ikhlas', nameTransliteration: 'Al-Ikhlas', numberOfAyahs: 4, revelationType: 'Meccan', startPage: 611, endPage: 611),
      SourateItem(sourateNumber: 113, nameArabic: 'الفلق', nameFrench: 'Al-Falaq', nameTransliteration: 'Al-Falaq', numberOfAyahs: 5, revelationType: 'Meccan', startPage: 611, endPage: 612),
      SourateItem(sourateNumber: 114, nameArabic: 'الناس', nameFrench: 'An-Nas', nameTransliteration: 'An-Nas', numberOfAyahs: 6, revelationType: 'Meccan', startPage: 612, endPage: 612), // Fin du mushaf à la page 612
    ];
  }

  static SourateItem? getSourateByNumber(int number) {
    final sourates = getAllSourates();
    if (number < 1 || number > sourates.length) {
      return null;
    }
    return sourates[number - 1];
  }

  static int getTotalSourates() {
    return 114;
  }

  // Mapping des pages du Mushaf aux Juz' selon la structure réelle
  // Basé sur la liste fournie et les pages de début des sourates
  static Map<String, int>? findJuzzAndPageFromGlobalPage(int globalPage) {
    if (globalPage < 1) return null;
    
    // Le mushaf standard a 612 pages (Juzz 30 va jusqu'à la page 612)
    const int maxMushafPages = 612;
    
    // Trouver la sourate qui contient cette page
    final sourate = getAllSourates().firstWhere(
      (s) => globalPage >= s.startPage && globalPage <= s.endPage,
      orElse: () => getAllSourates().first,
    );
    
    // Trouver le Juz' basé sur la page de début de la sourate
    // En utilisant la liste fournie pour mapper correctement
    final juzzMapping = _getJuzzMappingForSourate(sourate.sourateNumber);
    
    if (juzzMapping != null) {
      // Calculer la position dans le Juz' (0-indexed)
      // La page dans le Juz' est relative à la page de début du Juz' dans le Mushaf
      final juzzStartPage = _getJuzzStartPageInMushaf(juzzMapping);
      final pageInJuzz = globalPage >= juzzStartPage ? globalPage - juzzStartPage : 0;
      final pagesInJuzz = JuzzDataService.getPagesInJuzz(juzzMapping);
      
      return {
        'juzzNumber': juzzMapping,
        'pageInJuzz': pageInJuzz.clamp(0, pagesInJuzz - 1),
      };
    }
    
    // Si la page est > maxMushafPages, on retourne le dernier Juz'
    if (globalPage > maxMushafPages) {
      return {
        'juzzNumber': 30,
        'pageInJuzz': JuzzDataService.getPagesInJuzz(30) - 1,
      };
    }
    
    // Par défaut, retourner le premier Juz'
    return {
      'juzzNumber': 1,
      'pageInJuzz': (globalPage - 1).clamp(0, JuzzDataService.getPagesInJuzz(1) - 1),
    };
  }
  
  // Mapping des sourates aux Juz' selon la liste fournie
  static int? _getJuzzMappingForSourate(int sourateNumber) {
    // Mapping basé sur la liste fournie - retourne le premier Juz' de la sourate
    final Map<int, int> sourateToFirstJuzz = {
      1: 1, 2: 1, 3: 3, 4: 4, 5: 6, 6: 7, 7: 8, 8: 9, 9: 10, 10: 11,
      11: 11, 12: 12, 13: 13, 14: 13, 15: 14, 16: 14, 17: 15, 18: 15, 19: 16, 20: 16,
      21: 17, 22: 17, 23: 18, 24: 18, 25: 19, 26: 19, 27: 20, 28: 20, 29: 21, 30: 21,
      31: 21, 32: 21, 33: 22, 34: 22, 35: 23, 36: 23, 37: 23, 38: 23, 39: 23, 40: 24,
      41: 24, 42: 25, 43: 25, 44: 25, 45: 25, 46: 26, 47: 26, 48: 26, 49: 26, 50: 26,
      51: 26, 52: 27, 53: 27, 54: 27, 55: 27, 56: 27, 57: 27, 58: 28, 59: 28, 60: 28,
      61: 28, 62: 28, 63: 28, 64: 28, 65: 28, 66: 28, 67: 29, 68: 29, 69: 29, 70: 29,
      71: 29, 72: 29, 73: 29, 74: 29, 75: 29, 76: 29, 77: 29, 78: 30, 79: 30, 80: 30,
      81: 30, 82: 30, 83: 30, 84: 30, 85: 30, 86: 30, 87: 30, 88: 30, 89: 30, 90: 30,
      91: 30, 92: 30, 93: 30, 94: 30, 95: 30, 96: 30, 97: 30, 98: 30, 99: 30, 100: 30,
      101: 30, 102: 30, 103: 30, 104: 30, 105: 30, 106: 30, 107: 30, 108: 30, 109: 30, 110: 30,
      111: 30, 112: 30, 113: 30, 114: 30,
    };
    return sourateToFirstJuzz[sourateNumber];
  }
  
  // Obtenir la page de début du Juz' dans le Mushaf
  static int _getJuzzStartPageInMushaf(int juzzNumber) {
    // Pages de début réelles de chaque Juz' dans le Mushaf
    // Basées sur les pages de début des sourates et leur répartition
    final Map<int, int> juzzStartPages = {
      1: 1, 2: 46, 3: 88, 4: 130, 5: 172, 6: 214, 7: 256, 8: 304, 9: 352, 10: 398,
      11: 442, 12: 488, 13: 536, 14: 582, 15: 628, 16: 676, 17: 723, 18: 765, 19: 811, 20: 856,
      21: 898, 22: 942, 23: 988, 24: 1030, 25: 1068, 26: 1112, 27: 1158, 28: 1206, 29: 1248, 30: 583,
    };
    return juzzStartPages[juzzNumber] ?? 1;
  }

  // Trouver le juzz qui contient une sourate donnée (basé sur la page de début)
  static int findJuzzForSourate(int sourateNumber) {
    final sourate = getSourateByNumber(sourateNumber);
    if (sourate == null) return 1;
    
    final result = findJuzzAndPageFromGlobalPage(sourate.startPage);
    return result?['juzzNumber'] ?? 1;
  }

  // Trouver la position dans le juzz pour une sourate donnée
  static int findPageInJuzzForSourate(int sourateNumber) {
    final sourate = getSourateByNumber(sourateNumber);
    if (sourate == null) return 0;
    
    final result = findJuzzAndPageFromGlobalPage(sourate.startPage);
    return result?['pageInJuzz'] ?? 0;
  }
}
