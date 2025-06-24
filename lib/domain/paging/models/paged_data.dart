
import 'package:runmate_app/domain/paging/models/page_data.dart';

class PagedData<T> {
  final List<T> items;
  final PageData pageData;

  const PagedData({
    required this.items,
    required this.pageData, 
  });

  PagedData<T> copyWith({
    List<T>? items,
    PageData? pageData,
  }) {
    return PagedData<T>(
      items: items ?? this.items,
      pageData: pageData ?? this.pageData,
    );
  }
}
