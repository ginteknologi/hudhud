import 'package:get/get.dart';
import 'package:mesjid_app/pages/ruangan/ruangan_service.dart';

class RuanganController extends GetxController{
  
  var isLoadingList = true.obs;
  var list = {}.obs;

  
  getData() async {
    final result = await RuanganService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }
  
  
  
  @override
  void onInit(){
    super.onInit();
  }
}