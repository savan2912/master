class ResponseAboutUs {
  String? result;
  String? message;
  AboutUs? data;

  ResponseAboutUs({this.result, this.message, this.data});

  ResponseAboutUs.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new AboutUs.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
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

  AboutUs(
      {this.id,
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
        this.updatedAt});

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
        faq!.add(new Faq.fromJson(v));
      });
    }
    if (json['how_it_works'] != null) {
      howItWorks = <HowItWorks>[];
      json['how_it_works'].forEach((v) {
        howItWorks!.add(new HowItWorks.fromJson(v));
      });
    }
    if (json['stats'] != null) {
      stats = <Stats>[];
      json['stats'].forEach((v) {
        stats!.add(new Stats.fromJson(v));
      });
    }
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['about_title'] = this.aboutTitle;
    data['about_subtitle'] = this.aboutSubtitle;
    data['about_content'] = this.aboutContent;
    data['about_image'] = this.aboutImage;
    data['how_it_works_title'] = this.howItWorksTitle;
    data['how_it_works_subtitle'] = this.howItWorksSubtitle;
    data['why_choose_title'] = this.whyChooseTitle;
    data['why_choose_content'] = this.whyChooseContent;
    data['why_choose_image'] = this.whyChooseImage;
    if (this.faq != null) {
      data['faq'] = this.faq!.map((v) => v.toJson()).toList();
    }
    if (this.howItWorks != null) {
      data['how_it_works'] = this.howItWorks!.map((v) => v.toJson()).toList();
    }
    if (this.stats != null) {
      data['stats'] = this.stats!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['answer'] = this.answer;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['step_no'] = this.stepNo;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['label'] = this.label;
    data['image'] = this.image;
    return data;
  }
}
