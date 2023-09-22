import 'package:get/get.dart';
import 'package:mesjid_app/pages/sedekah/sedekah_service.dart';

class SedekahController extends GetxController{
  
  var isLoadingList = true.obs;
  var list = {}.obs;

  
  getData() async {
    final result = await SedekahService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }
  
  
  
  @override
  void onInit(){
    super.onInit();
  }
}