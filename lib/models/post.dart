class ImageResponse {
  List<Images> images;
  int imagesProcessed;
  int customClasses;

  ImageResponse({this.images, this.imagesProcessed, this.customClasses});

  ImageResponse.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    imagesProcessed = json['images_processed'];
    customClasses = json['custom_classes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['images_processed'] = this.imagesProcessed;
    data['custom_classes'] = this.customClasses;
    return data;
  }
}

class Images {
  List<Classifiers> classifiers;
  String image;

  Images({this.classifiers, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    if (json['classifiers'] != null) {
      classifiers = new List<Classifiers>();
      json['classifiers'].forEach((v) {
        classifiers.add(new Classifiers.fromJson(v));
      });
    }
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.classifiers != null) {
      data['classifiers'] = this.classifiers.map((v) => v.toJson()).toList();
    }
    data['image'] = this.image;
    return data;
  }
}

class Classifiers {
  String classifierId;
  String name;
  List<Classes> classes;

  Classifiers({this.classifierId, this.name, this.classes});

  Classifiers.fromJson(Map<String, dynamic> json) {
    classifierId = json['classifier_id'];
    name = json['name'];
    if (json['classes'] != null) {
      classes = new List<Classes>();
      json['classes'].forEach((v) {
        classes.add(new Classes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classifier_id'] = this.classifierId;
    data['name'] = this.name;
    if (this.classes != null) {
      data['classes'] = this.classes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Classes {
  String classa;
  double score;

  Classes({this.classa, this.score});

  Classes.fromJson(Map<String, dynamic> json) {
    classa = json['class'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['class'] = this.classa;
    data['score'] = this.score;
    return data;
  }
}