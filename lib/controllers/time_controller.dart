import 'dart:async';

import 'package:get/get.dart';

class TimeController extends GetxController{
  final DateTime fechaFin;
  Rx<Duration> tiempoRestante = const Duration().obs;
  RxBool estaCaducado = false.obs;

  TimeController({required this.fechaFin});

  late Timer _timer;

  @override
  void onInit() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _actualizarTiempo();
    });
    super.onInit();
  }

  void _actualizarTiempo(){

    Duration diferencia =  fechaFin.difference(DateTime.now());
    if(diferencia.isNegative){
      tiempoRestante.value = Duration.zero;
      estaCaducado.value = true;
      _timer.cancel();
    }else{
      tiempoRestante.value = diferencia;
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}