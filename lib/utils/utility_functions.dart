String formatTimeDisplay(DateTime date, bool homeDisplay){
  String formattedTimeDisplay = "";
  DateTime now = DateTime.now();

  int minutesDiff = now.difference(date).inMinutes;

  if(minutesDiff >= 525600){
    int years = (minutesDiff/525600).floor();
    if(homeDisplay){
      formattedTimeDisplay = "${years}t lalu";
    }else{
      formattedTimeDisplay = "Updated $years tahun lalu";
    }
  }
  else if(minutesDiff >= 43200){
    int months = (minutesDiff/43200).floor();
    if(homeDisplay){
      formattedTimeDisplay = "${months}b lalu";
    }else{
      formattedTimeDisplay = "Updated $months bulan lalu";
    }
  }
  else if(minutesDiff >= 1440){
    int days = (minutesDiff/1440).floor();
    if(homeDisplay){
      formattedTimeDisplay = "${days}h lalu";
    }else{
      formattedTimeDisplay = "Updated $days hari lalu";
    }
  }else if(minutesDiff >= 60){
    int hours = (minutesDiff/60).floor();
    if(homeDisplay){
      formattedTimeDisplay = "${hours}j lalu";
    }else{
      formattedTimeDisplay = "Updated $hours jam lalu";
    }
  }else{
    if(homeDisplay){
      formattedTimeDisplay = "${minutesDiff}m lalu";
    }else{
      formattedTimeDisplay = "Updated $minutesDiff minit lalu";
    }
  }

  return formattedTimeDisplay;
}