import 'package:flutter/material.dart';
import 'package:runmate_app/presentation/widgets/paged_scrollable.dart/models/page_info.dart';

abstract class PagedDataScrollableWidget extends StatefulWidget {
  final int requestPageThreshold;
  final ScrollController scrollController;
  final PageInfo Function() getCurrentPage;
  final Future<PageInfo> Function() pagingRequest;

  const PagedDataScrollableWidget({
    super.key,
    required this.pagingRequest,
    required this.getCurrentPage,
    this.requestPageThreshold = 0,
    required this.scrollController,
  });

  @override
  PagedDataScrollableWidgetState createState();
}

abstract class PagedDataScrollableWidgetState<T extends PagedDataScrollableWidget> extends State<T> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(_requestPageOnScroll);

    _requestPageUntilScrollable();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_requestPageOnScroll);
    super.dispose();
  }

  void _requestPageOnScroll() async {
    final position = widget.scrollController.position;

    if (position.maxScrollExtent - position.pixels <= 200 && widget.getCurrentPage().hasNextPage) {
      await _paging();
    }
  }

  void _requestPageUntilScrollable() {
    if (widget.getCurrentPage().hasNextPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.scrollController.positions.isNotEmpty) {
          if (widget.scrollController.position.maxScrollExtent == 0) {
            _paging().then((pageInfo) {
              if (pageInfo?.hasNextPage == true) {
                _requestPageUntilScrollable();
              }
            });
          }
        }
      });
    }
  }

  Future<PageInfo?> _paging() async {
    PageInfo? result;
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      result = await widget.pagingRequest();
      setState(() {
        isLoading = false;
      });
    }
    return result;
  }
}
