-- Seeds 02: Master 9 Imam & Hadits Arbain An-Nawawiyah (Marbot Backend)

-- 1. Master 9 Imam Hadits
INSERT OR IGNORE INTO had_imam (imamId, imamSorting, hadits, longNama, namaTabel) VALUES
(1, 1, 42, 'Hadits Arba''in An-Nawawiyah', 'arbain'),
(2, 2, 7008, 'Shahih Bukhari', 'bukhari'),
(3, 3, 5362, 'Shahih Muslim', 'muslim'),
(4, 4, 4590, 'Sunan Abu Daud', 'abudaud'),
(5, 5, 3891, 'Sunan At-Tirmidzi', 'tirmidzi'),
(6, 6, 5662, 'Sunan An-Nasa''i', 'nasai'),
(7, 7, 4332, 'Sunan Ibnu Majah', 'ibnumajah'),
(8, 8, 26363, 'Musnad Ahmad', 'ahmad'),
(9, 9, 1594, 'Muwaththa'' Malik', 'malik'),
(10, 10, 3367, 'Sunan Ad-Darimi', 'darimi');

-- 2. Master Kitab & Bab Sample
INSERT OR IGNORE INTO hadits_kitab (id, namaTabel, ID_Kitab, Kitab_Indonesia, Kitab_Arab, total_hadits) VALUES
(1, 'arbain', 1, 'Arba''in An-Nawawiyah', 'الأربعون النووية', 42),
(2, 'bukhari', 1, 'Permulaan Wahyu', 'بدء الوحي', 7),
(3, 'bukhari', 2, 'Iman', 'كتاب الإيمان', 58),
(4, 'muslim', 1, 'Iman', 'كتاب الإيمان', 93);

INSERT OR IGNORE INTO hadits_bab (id, namaTabel, ID_Kitab, ID_Bab, Bab_Indonesia, Bab_Arab) VALUES
(1, 'arbain', 1, 1, 'Niat dan Ikhlas', 'باب النية والإخلاص'),
(2, 'arbain', 1, 2, 'Islam, Iman, dan Ihsan', 'باب الإسلام والإيمان والإحسان'),
(3, 'arbain', 1, 3, 'Rukun Islam', 'باب أركان الإسلام'),
(4, 'arbain', 1, 4, 'Fase Penciptaan Manusia', 'باب أطوار خلق الإنسان');

-- 3. Hadits Arbain An-Nawawiyah (Hadits 1 - 5)
INSERT OR IGNORE INTO hadits_arbain (NoHdt, ID_Bab, ID_Kitab, Kitab_Indonesia, Isi_Arab, Isi_Indonesia) VALUES
(1, 1, 1, 'Arba''in An-Nawawiyah',
'عَنْ أَمِيرِ الْمُؤْمِنِينَ أَبِي حَفْصٍ عُمَرَ بْنِ الْخَطَّابِ رَضِيَ اللَّهُ عَنْهُ قَالَ: سَمِعْتُ رَسُولَ اللَّهِ صلى الله عليه وسلم يَقُولُ: "إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى، فَمَنْ كَانَتْ هِجْرَتُهُ إِلَى اللَّهِ وَرَسُولِهِ فَهِجْرَتُهُ إِلَى اللَّهِ وَرَسُولِهِ، وَمَنْ كَانَتْ هِجْرَتُهُ لِدُنْيَا يُصِيبُهَا أَوِ امْرَأَةٍ يَنْكِحُهَا فَهِجْرَتُهُ إِلَى مَا هَاجَرَ إِلَيْهِ".',
'Dari Amirul Mukminin Abu Hafsh Umar bin Khathab radhiyallahu ''anhu berkata: Aku mendengar Rasulullah shallallahu ''alaihi wa sallam bersabda: "Sesungguhnya setiap amalan tergantung pada niatnya, dan sesungguhnya setiap orang akan mendapatkan sesuai apa yang dia niatkan. Barangsiapa hijrahnya karena Allah dan Rasul-Nya, maka hijrahnya kepada Allah dan Rasul-Nya. Dan barangsiapa hijrahnya karena dunia yang ingin diraihnya atau karena wanita yang ingin dinikahinya, maka hijrahnya kepada apa yang ia tuju." (HR. Bukhari dan Muslim)'),

(2, 2, 1, 'Arba''in An-Nawawiyah',
'عَنْ عُمَرَ بْنِ الْخَطَّابِ رَضِيَ اللَّهُ عَنْهُ أَيْضاً قَالَ: بَيْنَمَا نَحْنُ جُلُوسٌ عِنْدَ رَسُولِ اللَّهِ صلى الله عليه وسلم ذَاتَ يَوْمٍ إِذْ طَلَعَ عَلَيْنَا رَجُلٌ شَدِيدُ بَيَاضِ الثِّيَابِ شَدِيدُ سَوَادِ الشَّعْرِ، لاَ يُرَى عَلَيْهِ أَثَرُ السَّفَرِ، وَلاَ يَعْرِفُهُ مِنَّا أَحَدٌ... فَقَالَ رَسُولُ اللَّهِ صلى الله عليه وسلم: "فَإِنَّهُ جِبْرِيلُ أَتَاكُمْ يُعَلِّمُكُمْ دِينَكُمْ".',
'Dari Umar radhiyallahu ''anhu pula berkata: Ketika kami sedang duduk bersama Rasulullah shallallahu ''alaihi wa sallam pada suatu hari, tiba-tiba datang seorang laki-laki mengenakan pakaian yang sangat putih dan rambut yang sangat hitam, tidak tampak padanya bekas perjalanan, dan tidak seorang pun dari kami yang mengenalnya... Rasulullah bersabda: "Sesungguhnya dia adalah Jibril yang datang kepada kalian untuk mengajarkan agama kalian." (HR. Muslim)'),

(3, 3, 1, 'Arba''in An-Nawawiyah',
'عَنْ أَبِي عَبْدِ الرَّحْمَنِ عَبْدِ اللَّهِ بْنِ عُمَرَ بْنِ الْخَطَّابِ رَضِيَ اللَّهُ عَنْهُمَا قَالَ: سَمِعْتُ رَسُولَ اللَّهِ صلى الله عليه وسلم يَقُولُ: "بُنِيَ الإِسْلاَمُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّداً رَسُولُ اللَّهِ، وَإِقَامِ الصَّلاَةِ، وَإِيتَاءِ الزَّكَاةِ، وَحَجِّ الْبَيْتِ، وَصَوْمِ رَمَضَانَ".',
'Dari Abu Abdirrahman Abdullah bin Umar bin Khathab radhiyallahu ''anhuma berkata: Aku mendengar Rasulullah shallallahu ''alaihi wa sallam bersabda: "Islam dibangun di atas lima perkara: persaksian bahwa tiada tuhan selain Allah dan Muhammad adalah utusan Allah, mendirikan shalat, menunaikan zakat, haji ke Baitullah, dan puasa Ramadhan." (HR. Bukhari dan Muslim)'),

(4, 4, 1, 'Arba''in An-Nawawiyah',
'عَنْ أَبِي عَبْدِ الرَّحْمَنِ عَبْدِ اللَّهِ بْنِ مَسْعُودٍ رَضِيَ اللَّهُ عَنْهُ قَالَ: حَدَّثَنَا رَسُولُ اللَّهِ صلى الله عليه وسلم وَهُوَ الصَّادِقُ الْمَصْدُوقُ: "إِنَّ أَحَدَكُمْ يُجْمَعُ خَلْقُهُ فِي بَطْنِ أُمِّهِ أَرْبَعِينَ يَوْماً نُطْفَةً، ثُمَّ يَكُونُ عَلَقَةً مِثْلَ ذَلِكَ، ثُمَّ يَكُونُ مُضْغَةً مِثْلَ ذَلِكَ، ثُمَّ يُرْسَلُ إِلَيْهِ الْمَلَكُ فَيَنْفُخُ فِيهِ الرُّوحَ..."',
'Dari Abu Abdirrahman Abdullah bin Mas''ud radhiyallahu ''anhu berkata: Rasulullah shallallahu ''alaihi wa sallam—dan beliau adalah orang yang jujur lagi terpercaya—menyampaikan kepada kami: "Sesungguhnya setiap kalian dikumpulkan penciptaannya dalam rahim ibunya selama 40 hari sebagai nuthfah, kemudian menjadi segumpal darah dalam waktu yang sama, lalu menjadi segumpal daging dalam waktu yang sama, kemudian diutuslah malaikat untuk meniupkan ruh padanya..." (HR. Bukhari dan Muslim)'),

(5, 1, 1, 'Arba''in An-Nawawiyah',
'عَنْ أُمِّ الْمُؤْمِنِينَ أُمِّ عَبْدِ اللَّهِ عَائِشَةَ رَضِيَ اللَّهُ عَنْهَا قَالَتْ: قَالَ رَسُولُ اللَّهِ صلى الله عليه وسلم: "مَنْ أَحْدَثَ فِي أَمْرِنَا هَذَا مَا لَيْسَ مِنْهُ فَهُوَ رَدٌّ".',
'Dari Ummul Mukminin Ummu Abdillah Aisyah radhiyallahu ''anha berkata: Rasulullah shallallahu ''alaihi wa sallam bersabda: "Barangsiapa membuat perkara baru dalam urusan (agama) kami ini yang tidak ada asalnya darinya, maka amalan itu tertolak." (HR. Bukhari dan Muslim)');
