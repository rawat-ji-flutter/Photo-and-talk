class SliderModel {
  String? image;
  String? title;
  String? subTitle;

// images given
  SliderModel({this.image});

// setter for image
  void setImage(
      {required String setImage,
        required String setTitle,
        required String setSubTitle}) {
    image = setImage;
    title = setTitle;
    subTitle = setSubTitle;
  }

// getter for image
  String? getImage() {
    return image;
  }

  // getter for image
  String? getTitle() {
    return title;
  }

  // getter for image
  String getSubTitle() {
    return subTitle ?? "";
  }

}

List<SliderModel> getSlides() {
  List<SliderModel> slides = <SliderModel>[];
  SliderModel sliderModel = SliderModel();

// 1
  sliderModel.setImage(
      setImage: "assets/intro/pexels-cottonbro-5082578.png",
      setTitle: "Import",
      setSubTitle: "Take photos with the camera or import from your gallery.");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

// 2
  sliderModel.setImage(
      setImage: "assets/intro/pexels-marlene-leppÃ¤nen-2066896.png",
      setTitle: "Create",
      setSubTitle:
      "Add voice overs to photos to add more details.");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

// 3
  sliderModel.setImage(
    setImage: "assets/intro/photo-talk-intro-3.png",
    setTitle: "Share",
    setSubTitle:
    "Share your new talking photos with friends and family.",
  );
  slides.add(sliderModel);

  sliderModel = new SliderModel();
  return slides;
}
