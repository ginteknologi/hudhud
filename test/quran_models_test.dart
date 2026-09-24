import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/models/quran_models.dart';

void main() {
  group('Quran Models & Juz List Tests', () {
    test('kQuranJuzList has 30 juz items with valid data', () {
      expect(kQuranJuzList.length, 30);
      expect(kQuranJuzList.first.juzNumber, 1);
      expect(kQuranJuzList.first.name, 'Juz 1');
      expect(kQuranJuzList.first.startSurahName, 'Al-Fatihah');
      expect(kQuranJuzList.first.startPage, 1);

      expect(kQuranJuzList.last.juzNumber, 30);
      expect(kQuranJuzList.last.name, 'Juz 30');
      expect(kQuranJuzList.last.startSurahName, "An-Naba'");
      expect(kQuranJuzList.last.startPage, 582);
    });

    test('SurahModel parses json successfully', () {
      final jsonStandard = {
        'id': 1,
        'nama': 'Al-Fatihah',
        'asma': 'الفاتحة',
        'ayat': 7,
        'tipe': 'mekah',
        'arti': 'Pembukaan',
        'audio': 'https://example.com/1.mp3',
      };

      final surah1 = SurahModel.fromJson(jsonStandard);
      expect(surah1.id, 1);
      expect(surah1.nama, 'Al-Fatihah');
      expect(surah1.asma, 'الفاتحة');
      expect(surah1.jumlahAyat, 7);
      expect(surah1.tipe, 'mekah');

      final jsonAlternative = {
        'id': '2',
        'arab': 'البقرة',
        'nama': 'Al-Baqarah',
        'ayat': '286',
        'type': 'madaniyah',
        'arti': 'Sapi Betina',
      };

      final surah2 = SurahModel.fromJson(jsonAlternative);
      expect(surah2.id, 2);
      expect(surah2.asma, 'البقرة');
      expect(surah2.nama, 'Al-Baqarah');
      expect(surah2.jumlahAyat, 286);
      expect(surah2.tipe, 'madaniyah');
    });
  });
}
