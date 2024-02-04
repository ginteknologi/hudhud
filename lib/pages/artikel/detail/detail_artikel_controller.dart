import 'package:get/get.dart';
import 'package:masjid_app/pages/artikel/artikel_service.dart';
import 'package:masjid_app/routes/artikel/index.dart';
import 'package:html/parser.dart';

class DetailArtikelController extends GetxController {
  var isLoadingList = true.obs;
  var detail = {}.obs;
  var share = "".obs;

  List listArtikels = [].obs;
  List listCategoryFilter = [].obs;
  late List<RxBool> listCategoryFilterSelected;
  String _convertHtmlToText(String htmlString) {
    var document = parse(htmlString);
    return parse(document.body!.text).documentElement!.text;
  }
  getData() async {
    final result = await ArtikelService().getDetailArtikel();
    detail.value = result;
    String judul = _convertHtmlToText(result['title']['rendered']);
    String content = _convertHtmlToText(result['content']['rendered']);
    String link = 'Dibagikan dari aplikasi\n\n Marbot App';

    share.value = '$judul\n\n$content\n\n$link';
    isLoadingList.value = false;
  }

  goToDetail(param) {
    Get.offAllNamed('${RoutesArtikel.root}/${param['id']}');
  }

  getListArtikels() async {
    final result = await ArtikelService().getListArtikellain();
    listArtikels = result;
  }

  @override
  void onInit() {
    getData();
    getListArtikels();
    super.onInit();
  }
}
