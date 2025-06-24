class PageData {
  final int total;
  final int perPage;
  final int totalPages;
  final int currentPage;

  PageData({
    required this.total,
    required this.perPage,
    required this.totalPages,
    required this.currentPage,
  });

  const PageData.horizontalDefault({
    this.perPage = 0,
    required this.total,
    this.totalPages = 0,
    this.currentPage = 0,
  });

  bool get hasNextPage => currentPage < totalPages;

  PageData copyWith({
    int? total,
    int? perPage,
    int? totalPages,
    int? currentPage,
  }) {
    return PageData(
      total: total ?? this.total,
      perPage: perPage ?? this.perPage,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
