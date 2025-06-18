// class AppImageBrand {
//   int totalPages = 0;
//   int currentPage = 0;
//   int count = 0;
//   int pageSize = 0;
//   List<AppImage> data = [];

//   AppImageBrand({
//     this.totalPages = 0,
//     this.currentPage = 0,
//     this.count = 0,
//     this.pageSize = 0,
//     this.data = const [],
//   });

//   factory AppImageBrand.fromJson(Map<String, dynamic> json) => AppImageBrand(
//         totalPages: json["total_pages"] ?? 0,
//         currentPage: json["current_page"] ?? 0,
//         count: json["count"] ?? 0,
//         pageSize: json["page_size"] ?? 0,
//         data: List<AppImage>.from(
//             json["data"]?.map((x) => AppImage.fromJson(x)) ?? const []),
//       );

//   Map<String, dynamic> toJson() => {
//         "total_pages": totalPages,
//         "current_page": currentPage,
//         "count": count,
//         "page_size": pageSize,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class AppImage {
//   int id = 0;
//   String logo = '';
//   String favicon = '';
//   String themeColor = '';
//   Organization? organization;

//   AppImage({
//     this.id = 0,
//     this.logo = '',
//     this.favicon = '',
//     this.themeColor = '',
//     this.organization,
//   });

//   factory AppImage.fromJson(Map<String, dynamic> json) => AppImage(
//         id: json["id"] ?? 0,
//         logo: json["logo"] ?? '',
//         favicon: json["favicon"] ?? '',
//         themeColor: json["theme_color"] ?? '',
//         organization: Organization.fromJson(json["organization"] ?? {}),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "logo": logo,
//         "favicon": favicon,
//         "theme_color": themeColor,
//         "organization": organization?.toJson(),
//       };
// }

// class Organization {
//   String id = '';
//   String title = '';
//   String description = '';
//   String location = '';
//   String apiKey = '';

//   Organization({
//     this.id = '',
//     this.title = '',
//     this.description = '',
//     this.location = '',
//     this.apiKey = '',
//   });

//   factory Organization.fromJson(Map<String, dynamic> json) => Organization(
//         id: json["id"] ?? '',
//         title: json["title"] ?? '',
//         description: json["description"] ?? '',
//         location: json["location"] ?? '',
//         apiKey: json["api_key"] ?? '',
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "description": description,
//         "location": location,
//         "api_key": apiKey,
//       };
// }
