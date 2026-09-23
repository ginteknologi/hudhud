class EventCountDownData {
  String title;
  String limitDate;
  String description;
  String imageUrl;
  bool status;
  EventCountDownData(
      {required this.title,
      required this.limitDate,
      required this.description,
      required this.imageUrl,
      this.status = false});
}
