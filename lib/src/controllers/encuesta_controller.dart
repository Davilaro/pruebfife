import 'package:emart/src/modelos/encuesta.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EncuestaControllers extends GetxController {
  RxBool isVisibleSurvey = true.obs;
  RxBool isVisibleNoSurvey = true.obs;
  RxBool showMandatorySurvey = false.obs;
  Rx<Encuesta> surveyActiveMandatory = Encuesta().obs;
  Rx<Encuesta> surveyActiveNoMandatory = Encuesta().obs;
  RxBool showNoMandatorySurvey = false.obs;
  RxList<Encuesta> mandatorySurveyList = <Encuesta>[].obs;
  RxList<Encuesta> noMandatorySurveyList = <Encuesta>[].obs;

  late FocusNode focusEncuesta;

  Future<bool> consultSurveys() async {
    final allSurveys =
        await DBProvider.db.consultarEncuesta(prefs.momentSurvey);

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
      surveyActiveMandatory.value = mandatorySurveyList.first;
    } else {
      showMandatorySurvey.value = false;
    }

    if (noMandatorySurveyList.isNotEmpty) {
      showNoMandatorySurvey.value = true;
      surveyActiveNoMandatory.value = noMandatorySurveyList.first;
    } else {
      showNoMandatorySurvey.value = false;
    }
    return showMandatorySurvey.value;
  }

  bool existenEncuestasObligatorias() {
    if (showMandatorySurvey.value && mandatorySurveyList.length > 0) {
      try {
        int position = mandatorySurveyList.indexOf(surveyActiveMandatory.value);
        surveyActiveMandatory.value = mandatorySurveyList[position + 1];
        return isVisibleSurvey.value = true;
      } catch (e) {
        return isVisibleSurvey.value = false;
      }
    } else {
      return isVisibleSurvey.value = false;
    }
  }

  bool existenEncuestasNoObligatorias() {
    if (showNoMandatorySurvey.value && noMandatorySurveyList.length > 0) {
      try {
        int position =
            noMandatorySurveyList.indexOf(surveyActiveNoMandatory.value);
        surveyActiveNoMandatory.value = noMandatorySurveyList[position + 1];
        return isVisibleNoSurvey.value = true;
      } catch (e) {
        return isVisibleNoSurvey.value = false;
      }
    } else {
      return isVisibleNoSurvey.value = false;
    }
  }

 
}
