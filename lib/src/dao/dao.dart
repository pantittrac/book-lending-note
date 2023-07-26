abstract class Dao<T, K> {

  Future<int> insert(T item);

  Future<List<T>> getAll();

  Future<T> getItem(K key);

  Future<int> updateItem(T item);  

  Future<int> deleteItem(K key);
}