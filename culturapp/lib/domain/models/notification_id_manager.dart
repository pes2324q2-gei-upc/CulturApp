class NotificationIdManager {
  static int _counter = 1;

  static int getNextId() {
    return _counter++;
  }
}
