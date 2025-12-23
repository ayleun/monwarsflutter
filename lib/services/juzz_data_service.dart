import '../models/juzz_item.dart';

class JuzzDataService {
  // Configuration des pages par Juzz (30 Juzz au total)
  static const List<int> _pagesPerJuzz = [
    45, // Juzz 1
    42, // Juzz 2
    42, // Juzz 3
    42, // Juzz 4
    42, // Juzz 5
    42, // Juzz 6
    48, // Juzz 7
    48, // Juzz 8
    46, // Juzz 9
    44, // Juzz 10
    46, // Juzz 11
    48, // Juzz 12
    46, // Juzz 13
    46, // Juzz 14
    48, // Juzz 15
    47, // Juzz 16
    42, // Juzz 17
    46, // Juzz 18
    45, // Juzz 19
    42, // Juzz 20
    44, // Juzz 21
    46, // Juzz 22
    42, // Juzz 23
    38, // Juzz 24
    44, // Juzz 25
    46, // Juzz 26
    48, // Juzz 27
    42, // Juzz 28
    46, // Juzz 29
    57  // Juzz 30 (pages 583-612, 30 pages dans le mushaf mais 57 pages au total)
  ];

  static const List<String> _sourateDescriptions = [
    "Al-Fatiha (1) - Al-Baqarah (141)",
    "Al-Baqarah (142) - Al-Baqarah (252)",
    "Al-Baqarah (253) - Al-Imran (92)",
    "Al-Imran (93) - An-Nisa (23)",
    "An-Nisa (24) - An-Nisa (147)",
    "An-Nisa (148) - Al-Ma'idah (81)",
    "Al-Ma'idah (82) - Al-An'am (110)",
    "Al-An'am (111) - Al-A'raf (87)",
    "Al-A'raf (88) - Al-Anfal (40)",
    "Al-Anfal (41) - At-Tawbah (92)",
    "At-Tawbah (93) - Hud (5)",
    "Hud (6) - Yusuf (52)",
    "Yusuf (53) - Ibrahim (52)",
    "Al-Hijr (1) - An-Nahl (128)",
    "Al-Isra (1) - Al-Kahf (74)",
    "Al-Kahf (75) - Ta-Ha (135)",
    "Al-Anbiya (1) - Al-Hajj (78)",
    "Al-Mu'minun (1) - Al-Furqan (20)",
    "Al-Furqan (21) - An-Naml (55)",
    "An-Naml (56) - Al-Ankabut (45)",
    "Al-Ankabut (46) - Al-Ahzab (30)",
    "Al-Ahzab (31) - Ya-Sin (27)",
    "Ya-Sin (28) - Az-Zumar (31)",
    "Az-Zumar (32) - Fussilat (46)",
    "Fussilat (47) - Al-Jathiya (37)",
    "Al-Ahqaf (1) - Az-Zariyat (30)",
    "Az-Zariyat (31) - Al-Hadid (29)",
    "Al-Mujadila (1) - At-Tahrim (12)",
    "Al-Mulk (1) - Al-Mursalat (50)",
    "An-Naba (78) - An-Nas (114)"
  ];

  static List<JuzzItem> getAllJuzz() {
    List<JuzzItem> juzzList = [];
    
    for (int i = 0; i < 30; i++) {
      juzzList.add(JuzzItem(
        juzzNumber: i + 1,
        name: 'Juzz ${i + 1}',
        sourateDescription: _sourateDescriptions[i],
        imagePath: 'assets/logo.png', // Vous devrez ajouter l'image logo.png
      ));
    }
    
    return juzzList;
  }

  static int getPagesInJuzz(int juzzNumber) {
    if (juzzNumber < 1 || juzzNumber > _pagesPerJuzz.length) {
      return 0;
    }
    return _pagesPerJuzz[juzzNumber - 1];
  }

  static int getTotalJuzz() {
    return _pagesPerJuzz.length;
  }

  static String getSourateForJuzz(int juzzNumber) {
    if (juzzNumber < 1 || juzzNumber > _sourateDescriptions.length) {
      return "Sourate inconnue";
    }
    return _sourateDescriptions[juzzNumber - 1];
  }

  // Obtenir le nom de ressource Android pour une page
  static String getPageImageResource(int juzzNumber, int pageNumber) {
    return 'j${juzzNumber}_$pageNumber';
  }

  // Obtenir la liste des pages par juzz (pour utilisation dans d'autres services)
  static List<int> getPagesPerJuzz() {
    return List.unmodifiable(_pagesPerJuzz);
  }
}

