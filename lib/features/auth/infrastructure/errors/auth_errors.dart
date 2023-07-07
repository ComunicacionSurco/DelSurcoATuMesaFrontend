/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

class ConnectionTimeOut implements Exception{}
class WrongCredentials implements Exception{}
class InvalidToken implements Exception{}

class CustomError implements Exception{
  final String message;
  //final int errorCode;

  CustomError(this.message);

}