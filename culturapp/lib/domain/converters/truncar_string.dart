/*
  Función para cortar string i poner '...', para evitar overflown de bytes
  maxLength -> de normal es 22-24, pero obviamente depende de si hay más widgets
*/
String truncarString(String noms, int maxLength) {
  if (noms.length <= maxLength) {
    return noms;
  } else {
    return '${noms.substring(0, maxLength - 3)}...';
  }
}
