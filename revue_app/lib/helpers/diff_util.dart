// A class that provides a mechanism for calculating the difference between two lists of items.
class DiffUtil {
  // This is a static method that accepts two lists representing old and new versions of data,
  // along with a function that takes in two instances of the generic type T and returns a boolean value to indicate whether they are equal or not.
  // It returns a list of `DiffUtilUpdate` objects that describe the changes between the two input lists.
  static List<DiffUtilUpdate> calculateDiff<T>(
    List<T> oldList, // The original list.
    List<T> newList, // The updated list.
    {
    bool Function(T, T)? areItemsTheSame, // An optional equality function.
  }) {
    final result = <DiffUtilUpdate>[]; // An empty list to hold the results.

    // Create mutable copies of both input lists.
    final oldListCopy = oldList.toList(growable: false);
    final newListCopy = newList.toList(growable: false);

    // Create maps that hold the position of each item in its respective list.
    final oldItemPositions = <T, int>{};
    final newItemPositions = <T, int>{};

    // Populate the maps by iterating over the items in each list and storing their positions.
    int oldIndex = 0;
    for (final oldItem in oldListCopy) {
      oldItemPositions[oldItem] = oldIndex++;
    }

    int newIndex = 0;
    for (final newItem in newListCopy) {
      newItemPositions[newItem] = newIndex++;
    }

    // Store the size of each list.
    final int oldSize = oldListCopy.length;
    final int newSize = newListCopy.length;

    // Initialize pointers to the start of each list.
    int oldPosition = 0;
    int newPosition = 0;

    // Create an additional copy of the original list but with nulls added where there are items removed due to a move operation
    final List<T?> oldListCopyNulls = oldListCopy.toList(growable: false);

    // While neither pointer has reached the end of its list...
    while (oldPosition < oldSize && newPosition < newSize) {
      // Get the item at the current position in each list.
      final T? oldItem = oldListCopyNulls[oldPosition];
      final T newItem = newListCopy[newPosition];

      // If the two items are equal, increment both pointers and continue.
      if (oldItem == newItem) {
        oldPosition++;
        newPosition++;
      } else {
        // Otherwise, look for the current old item position in the new list
        final oldItemNewPosition = newItemPositions[oldItem];
        if (oldItemNewPosition != null) {
          // If it's found, add a DiffUtilUpdate object to the result list indicating that the item was moved to a new position.
          result.add(DiffUtilUpdate(
            type: DiffUtilUpdateType.move,
            from: oldItemNewPosition,
            to: newPosition,
          ));

          // Replace the old item with a null in the old list with null so that we don't use it again when looking for the new position of other already-moved items.
          oldListCopyNulls[oldItemNewPosition] = null;

          // Increment the new position pointer.
          newPosition++;
        } else {
          // If the current new item position is not found in the old list
          final newItemOldPosition = oldItemPositions[newItem];
          if (newItemOldPosition != null) {
            // If it is found, add a DiffUtilUpdate object to the result list indicating that the item was moved from its old position to the current new position.
            result.add(DiffUtilUpdate(
              type: DiffUtilUpdateType.move,
              from: oldPosition,
              to: newItemOldPosition,
            ));

            // Replace the old item with a null to avoid using it again when checking for new position of other moved items.
            oldListCopyNulls[oldPosition] = null;

            // Increment the old position pointer.
            oldPosition++;
          } else {
            // If the old item does not have a corresponding new position and the new item does not have a corresponding old position,
            // and the items are not equal according to the provided areItemsTheSame function (if it exists),
            // then assume that the old item was removed from the list.
            final isItemsTheSame = oldItem == null
                ? false
                : areItemsTheSame?.call(oldItem, newItem) ?? false;

            if (isItemsTheSame) {
              // If the provided equality function indicates the items are different, add a DiffUtilUpdate object indicating that the item was changed.
              result.add(DiffUtilUpdate(
                type: DiffUtilUpdateType.change,
                from: oldPosition,
                to: newPosition,
              ));
              // Increment both position pointers.
              oldPosition++;
              newPosition++;
            } else {
              // Otherwise, add a DiffUtilUpdate object indicating that the old item was removed from the list.
              result.add(DiffUtilUpdate(
                type: DiffUtilUpdateType.remove,
                from: oldPosition,
                to: null,
              ));
              // Replace the old item with a null in the old list to avoid using it again.
              oldListCopyNulls[oldPosition] = null;
              // Increment the old position pointer.
              oldPosition++;
            }
          }
        }
      }
    }

    // Add remaining items to remove in old list after reaching the end of the new list.
    for (int i = oldSize - 1; i >= oldPosition; i--) {
      result.add(DiffUtilUpdate(
        type: DiffUtilUpdateType.remove,
        from: i,
        to: null,
      ));
    }

    // Add remaining items to add in new list after reaching the end of the old list.
    for (int i = newSize - 1; i >= newPosition; i--) {
      result.add(DiffUtilUpdate(
        type: DiffUtilUpdateType.add,
        from: null,
        to: i,
      ));
    }

    // Return the list of differences between the two input lists.
    return result;
  }
}

// Enum to represent the types of updates provided by DiffUtil calcuation.
class DiffUtilUpdate {
  const DiffUtilUpdate({
    required this.type, // Indicates update type. Either Add, Remove, Move or Change.
    required this.from, // Represents previous index or position.
    required this.to, // Represents new index or position.
  });

  final DiffUtilUpdateType
      type; // the type of the update. Check enum DiffUtilUpdateType class definition above.
  final int? from; // from position
  final int? to; // to position
}

// Enumeration listing possible types of updates provided by DiiffUtil calculation.
enum DiffUtilUpdateType { add, remove, move, change }
