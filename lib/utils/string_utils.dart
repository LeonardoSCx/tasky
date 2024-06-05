class StringUtils{
  static String printDuration(Duration duration) {
    String signoNegativo = duration.isNegative ? '-' : '';
    String horas(int n) => n.toString().padLeft(2, "0");
    String minutos = horas(duration.inMinutes.remainder(60).abs());
    String segundos = horas(duration.inSeconds.remainder(60).abs());
    return "$signoNegativo${horas(duration.inHours)}:$minutos:$segundos";
  }
}