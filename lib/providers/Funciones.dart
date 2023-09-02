class Funciones {
  static String numeroALetras(String Monto, String Moneda) {
    unidades(num, valor) {
      var res = "";
      num = int.parse(num.toString());
      switch (num) {
        case 1:
          res = valor ? "un" : "uno";
          break;
        case 2:
          res = "dos";
          break;
        case 3:
          res = "tres";
          break;
        case 4:
          res = "cuatro";
          break;
        case 5:
          res = "cinco";
          break;
        case 6:
          res = "seis";
          break;
        case 7:
          res = "siete";
          break;
        case 8:
          res = "ocho";
          break;
        case 9:
          res = "nueve";
          break;
      }
      return res;
    }

    decenas(num, valor) {
      var res = "";

      if (num < 10) {
        res = unidades(num, false);
      } else if (num == 10)
        res = "diez";
      else if (num == 11)
        res = "once";
      else if (num == 12)
        res = "doce";
      else if (num == 13)
        res = "trece";
      else if (num == 14)
        res = "catorce";
      else if (num == 15)
        res = "quince";
      else if (num >= 16 && num < 20)
        res = "dieci" + unidades(num - 10, valor);
      else if (num >= 20 && num < 30)
        res = "veint" + (num - 20 == 0 ? "e" : "i" + unidades(num - 20, valor));
      else if (num >= 30 && num < 40)
        res = "treinta" + (num - 30 == 0 ? "" : " y " + unidades(num - 30, valor));
      else if (num >= 40 && num < 50)
        res = "cuarenta" + (num - 40 == 0 ? "" : " y " + unidades(num - 40, valor));
      else if (num >= 50 && num < 60)
        res = "cincuenta" + (num - 50 == 0 ? "" : " y " + unidades(num - 50, valor));
      else if (num >= 60 && num < 70)
        res = "sesenta" + (num - 60 == 0 ? "" : " y " + unidades(num - 60, valor));
      else if (num >= 70 && num < 80)
        res = "setenta" + (num - 70 == 0 ? "" : " y " + unidades(num - 70, valor));
      else if (num >= 80 && num < 90)
        res = "ochenta" + (num - 80 == 0 ? "" : " y " + unidades(num - 80, valor));
      else if (num >= 90 && num < 100) res = "noventa" + (num - 90 == 0 ? "" : " y " + unidades(num - 90, valor));

      return res;
    }

    centenas(num, valor) {
      var res = "";

      if (num < 100)
        res = decenas(num, valor);
      else if (num >= 100 && num < 200)
        res = "cien" + (num - 100 == 0 ? "" : "to " + decenas(num - 100, valor));
      else if (num >= 200 && num < 300)
        res = "doscientos" + (num - 200 == 0 ? "" : " " + decenas(num - 200, valor));
      else if (num >= 300 && num < 400)
        res = "trescientos" + (num - 300 == 0 ? "" : " " + decenas(num - 300, valor));
      else if (num >= 400 && num < 500)
        res = "cuatrocientos" + (num - 400 == 0 ? "" : " " + decenas(num - 400, valor));
      else if (num >= 500 && num < 600)
        res = "quinientos" + (num - 500 == 0 ? "" : " " + decenas(num - 500, valor));
      else if (num >= 600 && num < 700)
        res = "seiscientos" + (num - 600 == 0 ? "" : " " + decenas(num - 600, valor));
      else if (num >= 700 && num < 800)
        res = "setecientos" + (num - 700 == 0 ? "" : " " + decenas(num - 700, valor));
      else if (num >= 800 && num < 900)
        res = "ochocientos" + (num - 800 == 0 ? "" : " " + decenas(num - 800, valor));
      else if (num >= 900 && num < 1000) res = "novecientos" + (num - 900 == 0 ? "" : " " + decenas(num - 900, valor));

      return res;
    }

    unidadMiles(num) {
      var res = "";
      if (num < 1000)
        res = centenas(num, false);
      else if (num >= 1000 && num < 2000)
        res = "mil " + centenas(num % 1000, false);
      else
        res = centenas(int.parse(num / 1000), true) + " mil " + centenas(num % 1000, false);

      return res;
    }

    millon(num) {
      var res = "";

      if (num < 1000000)
        res = unidadMiles(num);
      else if (num == 1000000)
        res = "Un millón ";
      else
        res = unidades(num / 1000000, true) + " millones " + unidadMiles(num % 1000000);

      return res;
    }

    convertir(num) {
      if (num == 0)
        return "cero";
      else if (num > 0 && num <= 9999999) {
        var res = millon(num);
        var primero = res[0];
        return primero.toUpperCase() + res.substring(1);
      } else
        return "FUERA DEL RANGO!!";
    }

    getMonto(String valor) {
      var numero = valor + "";
      var punto = numero.indexOf(".");
      var entero = convertir(int.parse(numero.substring(0, punto)));
      var decimal = numero.substring(punto + 1);

      return entero + " y " + decimal + "/100 " + Moneda;
    }

    return getMonto(Monto);
  }
}
