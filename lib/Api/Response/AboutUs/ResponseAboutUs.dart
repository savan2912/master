class ResponseAboutUs {
  String? result;
  String? message;
  AboutUs? data;

  ResponseAboutUs({this.result, this.message, this.data});

  ResponseAboutUs.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? AboutUs.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AboutUs {
  int? id;
  String? aboutTitle;
  String? aboutSubtitle;
  String? aboutContent;
  String? aboutImage;
  String? howItWorksTitle;
  String? howItWorksSubtitle;
  String? whyChooseTitle;
  String? whyChooseContent;
  String? whyChooseImage;
  List<Faq>? faq;
  List<HowItWorks>? howItWorks;
  List<Stats>? stats;
  int? status;
  String? createdAt;
  String? updatedAt;

  AboutUs({
    this.id,
    this.aboutTitle,
    this.aboutSubtitle,
    this.aboutContent,
    this.aboutImage,
    this.howItWorksTitle,
    this.howItWorksSubtitle,
    this.whyChooseTitle,
    this.whyChooseContent,
    this.whyChooseImage,
    this.faq,
    this.howItWorks,
    this.stats,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  AboutUs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    aboutTitle = json['about_title'];
    aboutSubtitle = json['about_subtitle'];
    aboutContent = json['about_content'];
    aboutImage = json['about_image'];
    howItWorksTitle = json['how_it_works_title'];
    howItWorksSubtitle = json['how_it_works_subtitle'];
    whyChooseTitle = json['why_choose_title'];
    whyChooseContent = json['why_choose_content'];
    whyChooseImage = json['why_choose_image'];
    if (json['faq'] != null) {
      faq = <Faq>[];
      json['faq'].forEach((v) {
        faq!.add(Faq.fromJson(v));
      });
    }
    if (json['how_it_works'] != null) {
      howItWorks = <HowItWorks>[];
      json['how_it_works'].forEach((v) {
        howItWorks!.add(HowItWorks.fromJson(v));
      });
    }
    if (json['stats'] != null) {
      stats = <Stats>[];
      json['stats'].forEach((v) {
        stats!.add(Stats.fromJson(v));
      });
    }
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['about_title'] = aboutTitle;
    data['about_subtitle'] = aboutSubtitle;
    data['about_content'] = aboutContent;
    data['about_image'] = aboutImage;
    data['how_it_works_title'] = howItWorksTitle;
    data['how_it_works_subtitle'] = howItWorksSubtitle;
    data['why_choose_title'] = whyChooseTitle;
    data['why_choose_content'] = whyChooseContent;
    data['why_choose_image'] = whyChooseImage;
    if (faq != null) {
      data['faq'] = faq!.map((v) => v.toJson()).toList();
    }
    if (howItWorks != null) {
      data['how_it_works'] = howItWorks!.map((v) => v.toJson()).toList();
    }
    if (stats != null) {
      data['stats'] = stats!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Faq {
  String? question;
  String? answer;

  Faq({this.question, this.answer});

  Faq.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}

class HowItWorks {
  String? stepNo;
  String? title;
  String? description;
  String? image;

  HowItWorks({this.stepNo, this.title, this.description, this.image});

  HowItWorks.fromJson(Map<String, dynamic> json) {
    stepNo = json['step_no'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['step_no'] = stepNo;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    return data;
  }
}

class Stats {
  String? count;
  String? label;
  String? image;

  Stats({this.count, this.label, this.image});

  Stats.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    label = json['label'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['label'] = label;
    data['image'] = image;
    return data;
  }
}
