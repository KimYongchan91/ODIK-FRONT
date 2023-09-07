bool isSameList<K, V>(List<K> listA, List<V> listB) {
  return K.runtimeType == V.runtimeType &&
      listA.length == listB.length &&
      listA.every((element) => listB.contains(element));
}
