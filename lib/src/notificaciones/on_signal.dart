
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

void onSignalInitialize(){

    if(kDebugMode){
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    }
    
    OneSignal.shared.setAppId('37c60bd3-da90-43af-9275-dfb934198e04');  

}