import 'package:get_it/get_it.dart';
import 'package:jiwa_bakti/services/api_service.dart';

class AdsStore{
  DateTime refreshTime = DateTime.now().toUtc();
  List<dynamic> adsList = [];
  final ApiService apiService = GetIt.I<ApiService>();
  int count = 0;
  int partialCount = 0;

  Future<List<dynamic>> getAds() async {
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 8));
    if(now.difference(refreshTime).inMinutes >= 10 || adsList.isEmpty) {
      refreshTime = now;
      final data = await apiService.getAds();
      adsList = data['ads'];
      adsList.removeWhere((element) => element["status"] != "active");
    }

    return adsList;
  }

  Future<Map<String, String>> getNextAds() async{
    Map<String, String> result = {};
    await getAds();

    if(adsList.isNotEmpty){
      result["image"] = adsList[count]['image'];
      result["url"] = adsList[count]['url'];
    }else{
      await getAds();
      result["image"] = adsList[count]['image'];
      result["url"] = adsList[count]['url'];
    }

    if(count >= adsList.length - 1){
      count = 0;
    }else{
      count++;
    }

    return result;
  }
  
  Future<List<Map<String, String>>> getAdsListPartial() async {
    List<Map<String, String>> result = [];
    List<dynamic> ads = await getAds();

    if (ads.isNotEmpty) {
      int numberOfAds = ads.length <= 5 ? ads.length : 5;

      for (int i = 0; i < numberOfAds; i++) {
        if(ads[partialCount]['image'] != null){
          result.add({
            "image": ads[partialCount]['image'],
            "url": ads[partialCount]['url'],
            "id": ads[partialCount]['id'],
          });
        }

        partialCount = (partialCount >= ads.length - 1) ? 0 : partialCount + 1;
      }
    }

    // print("----- RESULT RETURN $result");
    return result;
  }

}
