import 'package:get/get.dart';
import 'package:mesjid_app/pages/artikel/artikel_service.dart';

class ArtikelController extends GetxController{
  
  var isLoadingList = true.obs;
  var list = {}.obs;

  
  getData() async {
    final result = await ArtikelService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }
  
  
  
  @override
  void onInit(){
    super.onInit();
  }
}