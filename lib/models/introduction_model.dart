class IntroductionModel{
  String title;
  String description;
  String image;
  IntroductionModel({required this.title, required this.description, required this.image});

}

List<IntroductionModel> contents = [
  IntroductionModel(
    title: "Welcome to Todoa",
    description: "A great Todo Task Manager app for anyone",
    image: "assets/images/TodoaLogo.jpg",
  ),
  IntroductionModel(
    title: "Stay Organized",
    description: "Simplify Your To-Do List, Stay Focused, and Achieve Your Goals.",
    image: "assets/images/TodoList.png",
  ),
  IntroductionModel(
    title: "Master Your Time",
    description: "Maximize Productivity with Our Time Management Features.",
    image: "assets/images/Time.png",
  ),
];