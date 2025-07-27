class Outputs {
  PredictionData? predictionData;

	Outputs({this.predictionData});

	Outputs.fromJson(Map<String, dynamic> json) {
		predictionData = json['outputs'][0] != null ? PredictionData.fromJson(json['outputs'][0]) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		if (predictionData != null) {
      data['outputs'] = predictionData!.toJson();
    }
		return data;
	}
}

class PredictionData {
	Prediction? predictions;

	PredictionData({this.predictions});

	PredictionData.fromJson(Map<String, dynamic> json) {
		predictions = json['predictions'] != null ? Prediction.fromJson(json['predictions']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		if (predictions != null) {
      data['predictions'] = predictions!.toJson();
    }
		return data;
	}
}

class Prediction {
	PredictionImage? image;
	List<Predictions>? predictions;

	Prediction({this.image, this.predictions});

	Prediction.fromJson(Map<String, dynamic> json) {
		image = json['image'] != null ? PredictionImage.fromJson(json['image']) : null;
		if (json['predictions'] != null) {
			predictions = <Predictions>[];
			json['predictions'].forEach((v) { predictions!.add(Predictions.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		if (image != null) {
      data['image'] = image!.toJson();
    }
		if (predictions != null) {
      data['predictions'] = predictions!.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class PredictionImage {
	int? width;
	int? height;

	PredictionImage({this.width, this.height});

	PredictionImage.fromJson(Map<String, dynamic> json) {
		width = json['width'];
		height = json['height'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['width'] = width;
		data['height'] = height;
		return data;
	}
}

class Predictions {
	double? width;
	double? height;
	double? x;
	double? y;
	double? confidence;
	int? classId;
	String? className;
	String? detectionId;
	String? parentId;

	Predictions({this.width, this.height, this.x, this.y, this.confidence, this.classId, this.className, this.detectionId, this.parentId});

	Predictions.fromJson(Map<String, dynamic> json) {
		width = json['width'];
		height = json['height'];
		x = json['x'];
		y = json['y'];
		confidence = json['confidence'];
		classId = json['class_id'];
		className = json['class'];
		detectionId = json['detection_id'];
		parentId = json['parent_id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['width'] = width;
		data['height'] = height;
		data['x'] = x;
		data['y'] = y;
		data['confidence'] = confidence;
		data['class_id'] = classId;
		data['class'] = className;
		data['detection_id'] = detectionId;
		data['parent_id'] = parentId;
		return data;
	}
}