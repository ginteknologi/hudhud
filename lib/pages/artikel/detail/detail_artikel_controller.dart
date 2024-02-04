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
    isLoadingList.value = true;
    final result = await ArtikelService().getDetailArtikel();
    detail.value = result['data'];
    String judul = result['data']['judul'];
    String content = _convertHtmlToText(result['data']['isi']);
    String link = 'Dibagikan dari aplikasi\n\n Marbot App';

    share.value = '$judul\n\n$content\n\n$link';

    final listartikel = await ArtikelService().getListArtikellain();
    listArtikels = listartikel['data'];
    isLoadingList.value = false;
  }

  goToDetail(param) {
    Get.offAllNamed('${RoutesArtikel.root}/${param['id']}');
  }

  

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
