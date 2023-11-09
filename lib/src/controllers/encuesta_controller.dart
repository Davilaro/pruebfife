import 'package:emart/src/modelos/encuesta.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EncuestaControllers extends GetxController {
  RxBool isVisibleSurvey = true.obs;
  RxBool showMandatorySurvey = false.obs;
  RxList<Encuesta> mandatorySurveyList = <Encuesta>[].obs;
  RxList<Encuesta> noMandatorySurveyList = <Encuesta>[].obs;

  late FocusNode focusEncuesta;

  void setIsVisibleEncuesta(bool val) {
    isVisibleSurvey.value = val;
  }

  Future<void> consultSurveys() async {
    final allSurveys = await DBProvider.db.consultarEncuesta();

    mandatorySurveyList.clear();
    noMandatorySurveyList.clear();

    for (final survey in allSurveys) {
      if (survey.obligatoria == 1) {
        mandatorySurveyList.add(survey);
      } else {
        noMandatorySurveyList.add(survey);
      }
    }

    if (mandatorySurveyList.isNotEmpty) {
      showMandatorySurvey.value = true;
    } else {
      showMandatorySurvey.value = false;
    }
  }
}
