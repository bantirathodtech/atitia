# Reusable Pagination System with Lazy Loading

A complete, reusable pagination solution for Firestore queries with automatic lazy loading.

## 📦 Components

1. **`PaginationController<T>`** - Manages pagination state and data loading
2. **`PaginatedListView<T>`** - UI widget that displays paginated lists
3. **`FirestorePaginationHelper`** - Helper to create controllers from Firestore queries

## 🚀 Quick Start

### Basic Usage

```dart
// 1. Create a pagination controller
final controller = FirestorePaginationHelper.createController<SubscriptionModel>(
  query: FirebaseFirestore.instance
      .collection('owner_subscriptions')
      .where('ownerId', isEqualTo: ownerId)
      .orderBy('createdAt', descending: true),
  documentMapper: (doc) => SubscriptionModel.fromMap(doc.data()!),
  pageSize: 20,
);

// 2. Use in your widget
PaginatedListView<SubscriptionModel>(
  controller: controller,
  itemBuilder: (context, subscription, index) {
    return SubscriptionCard(subscription: subscription);
  },
)
```

### Advanced Usage with Custom Query

```dart
final controller = PaginationController<RefundRequestModel>(
  queryFunction: (query) => query.get(),
  documentMapper: (doc) => RefundRequestModel.fromMap(doc.data()!),
  pageSize: 20,
  baseQuery: FirebaseFirestore.instance
      .collection('refund_requests')
      .where('status', isEqualTo: 'pending')
      .orderBy('requestedAt', descending: true),
);

// Load initial data
await controller.loadInitial();
```

## 📋 Features

✅ **Automatic Lazy Loading** - Loads more data when user scrolls near bottom  
✅ **Loading States** - Shows loading indicators during fetch  
✅ **Error Handling** - Displays errors with retry options  
✅ **Empty States** - Shows empty state when no data  
✅ **Refresh Support** - Pull to refresh functionality  
✅ **Memory Efficient** - Proper disposal and cleanup  

## 🎯 Cost Optimization

This pagination system automatically:
- ✅ Limits queries to 20 items per page (configurable)
- ✅ Only loads data when needed (lazy loading)
- ✅ Reduces Firestore reads by 80-90%

## 📝 Example: Subscription List

```dart
class SubscriptionListScreen extends StatefulWidget {
  @override
  _SubscriptionListScreenState createState() => _SubscriptionListScreenState();
}

class _SubscriptionListScreenState extends State<SubscriptionListScreen> {
  late PaginationController<OwnerSubscriptionModel> _controller;

  @override
  void initState() {
    super.initState();
    
    final ownerId = getIt.auth.currentUser?.uid ?? '';
    
    _controller = FirestorePaginationHelper.createController<OwnerSubscriptionModel>(
      query: FirebaseFirestore.instance
          .collection('owner_subscriptions')
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('createdAt', descending: true),
      documentMapper: (doc) => OwnerSubscriptionModel.fromMap(doc.data()!),
      pageSize: 20,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Subscriptions')),
      body: PaginatedListView<OwnerSubscriptionModel>(
        controller: _controller,
        itemBuilder: (context, subscription, index) {
          return SubscriptionCard(subscription: subscription);
        },
        emptyWidget: Center(child: Text('No subscriptions found')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _controller.refresh(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
```

## 🔧 Configuration Options

### PaginationController Options

- `pageSize` - Number of items per page (default: 20, max: 50)
- `baseQuery` - Firestore query to paginate
- `queryFunction` - Custom function to execute queries
- `documentMapper` - Function to convert Firestore documents to models

### PaginatedListView Options

- `triggerDistance` - Distance from bottom to trigger load more (default: 200px)
- `emptyWidget` - Custom empty state widget
- `loadingWidget` - Custom loading indicator
- `loadingMoreWidget` - Custom "loading more" indicator
- `errorWidget` - Custom error widget
- `padding` - List padding
- `scrollController` - Custom scroll controller

## 💡 Best Practices

1. **Always dispose controllers** to prevent memory leaks
2. **Use appropriate page sizes** (20 is recommended for lists)
3. **Order queries** for consistent pagination results
4. **Handle errors gracefully** with custom error widgets
5. **Cache static data** separately (not paginated)

## 📊 Cost Impact

**Before Pagination:**
- Loading 1000 subscriptions = 1000 Firestore reads

**After Pagination:**
- Loading first page (20 items) = 20 Firestore reads
- Loading more pages on demand = 20 reads per page
- **Savings: 80-95% reduction in reads**

