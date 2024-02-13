// To parse this JSON data, do
//
//     final exercises = exercisesFromJson(jsonString);

import 'dart:convert';

List<Exercises> exercisesFromJson(String str) => List<Exercises>.from(json.decode(str).map((x) => Exercises.fromJson(x)));

String exercisesToJson(List<Exercises> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Exercises {
    String name;
    Type type;
    String muscle;
    String equipment;
    Difficulty difficulty;
    String instructions;

    Exercises({
        this.name,
        this.type,
        this.muscle,
        this.equipment,
        this.difficulty,
        this.instructions,
    });

    factory Exercises.fromJson(Map<String, dynamic> json) => Exercises(
        name: json["name"],
        type: typeValues.map[json["type"]],
        muscle: json["muscle"],
        equipment: json["equipment"],
        difficulty: difficultyValues.map[json["difficulty"]],
        instructions: json["instructions"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "type": typeValues.reverse[type],
        "muscle": muscle,
        "equipment": equipment,
        "difficulty": difficultyValues.reverse[difficulty],
        "instructions": instructions,
    };
}

enum Difficulty {
    BEGINNER,
    INTERMEDIATE
}

final difficultyValues = EnumValues({
    "beginner": Difficulty.BEGINNER,
    "intermediate": Difficulty.INTERMEDIATE
});

enum Type {
    OLYMPIC_WEIGHTLIFTING,
    STRENGTH,
    STRONGMAN
}

final typeValues = EnumValues({
    "olympic_weightlifting": Type.OLYMPIC_WEIGHTLIFTING,
    "strength": Type.STRENGTH,
    "strongman": Type.STRONGMAN
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
