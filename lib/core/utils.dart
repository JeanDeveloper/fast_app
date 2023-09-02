class Utils{

  static String? convertTime(String hour){
    DateTime now = DateTime.now();
    List<String> timeParts = hour.split(':');
    String elapsedTime = "";

    if (timeParts.length == 2) {
      int horas = int.parse(timeParts[0]);
      int minutos = int.parse(timeParts[1].substring(0, 2));
      
      if ( hour.endsWith("pm") && horas != 12) {
        horas += 12;
      } else if (hour.endsWith("am") && horas == 12) {
        horas = 0;
      }

      int nowHours = now.hour;
      int nowMinutes = now.minute;
      int horasTranscurridas = nowHours - horas;
      int minutosTranscurridos = nowMinutes - minutos;
      
      if (minutosTranscurridos < 0) {
        minutosTranscurridos += 60;
        horasTranscurridas--;
      }

      if (horasTranscurridas <= 0) {
        elapsedTime = "($minutosTranscurridos\m)";
      }else{
        elapsedTime = "($horasTranscurridas\h $minutosTranscurridos\m)";
      }
      return elapsedTime ;
    } else {
      return elapsedTime;
    }
  }


  static String? getDateFormat(){
    DateTime now = DateTime.now();
    String horaFormateada = "";
    int nowHours = now.hour;
    int nowMinutes = now.minute;
    String amPm = nowHours < 12 ? "am" : "pm";

    if (nowHours > 12) {
      nowHours -= 12;
    } else if (nowHours == 0) {
      nowHours = 12;
    }
     horaFormateada = "$nowHours:${nowMinutes.toString().padLeft(2, '0')}$amPm";
     return horaFormateada;
  }


}