// To parse this JSON data, do
//
//     final resumeResponse = resumeResponseFromJson(jsonString);

import 'dart:convert';

ResumeResponse resumeResponseFromJson(String str) => ResumeResponse.fromJson(json.decode(str));

String resumeResponseToJson(ResumeResponse data) => json.encode(data.toJson());

class ResumeResponse {
    String? message;
    int? breakId;
    String? totalBreakDuration;

    ResumeResponse({
        this.message,
        this.breakId,
        this.totalBreakDuration,
    });

    factory ResumeResponse.fromJson(Map<String, dynamic> json) => ResumeResponse(
        message: json["message"],
        breakId: json["break_id"],
        totalBreakDuration: json["total_break_duration"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "break_id": breakId,
        "total_break_duration": totalBreakDuration,
    };
}
