import 'package:get/get.dart';
import 'package:masjid_app/pages/artikel/artikel_service.dart';
import 'package:html/parser.dart';
import 'package:masjid_app/models/artikelData.dart';

class DetailArtikelController extends GetxController {
  var isLoadingList = true.obs;
  var share = "".obs;

  var listArtikels = <ArtikelData>[].obs;
  Rx<ArtikelData> detail = Rx(ArtikelData(
    id: 1,
    judul: '',
    updatedAt: '',
    image: '',
    publish_date: '',
  ));
  List listCategoryFilter = [].obs;
  late List<RxBool> listCategoryFilterSelected;
  String _convertHtmlToText(String htmlString) {
    var document = parse(htmlString);
    return parse(document.body!.text).documentElement!.text;
  }

  Future<void> getData() async {
    try {
      isLoadingList.value = true;
      final result = await ArtikelService().getDetailArtikel();
      detail.value = ArtikelData(
          id: result['data']['id'],
          judul: result['data']['judul'],
          isi: result['data']['isi'],
          image: result['data']['image'],
          category_artikel: result['data']['category_artikel'],
          updatedAt: result['data']['updatedAt'],
          publish_date: result['data']['publish_date']);
      String judul = result['data']['judul'];
      String content = _convertHtmlToText(result['data']['isi']);
      String link = 'Dibagikan dari aplikasi\n\n Marbot App';
      share.value = '$judul\n\n$content\n\n$link';
      final listartikel = await ArtikelService().getListArtikellain();
      for (var element in listartikel['data']) {
        listArtikels.add(ArtikelData(
            id: element['id'],
            judul: element['judul'],
            image: element['image'],
            publish_date: element['publish_date'],
            updatedAt: element['updatedAt']));
      }
      listArtikels.sort((a, b) =>
          DateTime.parse(b.updatedAt).compareTo(DateTime.parse(a.updatedAt)));
      isLoadingList.value = false;
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
