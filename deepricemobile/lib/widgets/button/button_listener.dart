abstract class ButtonListener {
  void onClick();
}

class CustomDefaultListener extends ButtonListener {
  CustomDefaultListener();


  @override
  void onClick() {
    print("this is the default listener");
  }

}