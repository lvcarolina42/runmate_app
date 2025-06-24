class PageInfo {
  final int nextPage;
  final int totalItems;
  final bool hasNextPage;

  PageInfo({
    this.nextPage = 1,
    required this.totalItems,
    required this.hasNextPage,
  });

  PageInfo copyWith({
    int? nextPage,
    int? totalItems,
    bool? hasNextPage,
  }) {
    return PageInfo(
      nextPage: nextPage ?? this.nextPage,
      totalItems: totalItems ?? this.totalItems,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}
