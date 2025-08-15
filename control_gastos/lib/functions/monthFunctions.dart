String getNameMonth(int month) {
  String nameMonth = "";
  switch (month) {
    case 1:
      nameMonth = "Enero";
      break;
    case 2:
      nameMonth = "Febrero";
      break;
    case 3:
      nameMonth = "Marzo";
      break;
    case 4:
      nameMonth = "Abril";
      break;
    case 5:
      nameMonth = "Mayo";
      break;
    case 6:
      nameMonth = "Junio";
      break;
    case 7:
      nameMonth = "Julio";
      break;
    case 8:
      nameMonth = "Agosto";
      break;
    case 9:
      nameMonth = "Septiembre";
      break;
    case 10:
      nameMonth = "Octubre";
      break;
    case 11:
      nameMonth = "Noviembre";
      break;
    case 12:
      nameMonth = "Diciembre";
      break;
    default:
      nameMonth = "Mes inválido";
      break;
  }
  return nameMonth;
}

int getNumberMonth(DateTime date) {
  return date.month;
}

int getNumberYear(DateTime date) {
  return date.year;
}
