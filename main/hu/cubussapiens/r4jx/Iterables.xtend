package hu.cubussapiens.r4jx

import static extension hu.cubussapiens.r4jx.Iterables.*
import static extension hu.akarnokd.reactive4java.interactive.Interactive.*
import org.eclipse.xtext.xbase.lib.IterableExtensions
import static org.eclipse.xtext.xbase.lib.IterableExtensions.*
import static com.google.common.base.Objects.*

class Iterables {

	private new() {
	}

	def static <T> Iterable<T> makeIterable(T... values) {
		toIterable(values)
	}

	/**
	 * Whether {@link source} starts with the same elements as {@link prefix}.
	 */
	def static <T> boolean startsWith(Iterable<? extends T> source, Iterable<? extends T> prefix) {
		prefix.elementsEqual(source.take(prefix.size))
	}

	/**
	 * Returns {@link count} elements starting from {@link startIndex} from {@link source}.
	 */
	def static <T> Iterable<T> subsequence(Iterable<T> source, int startIndex, int count) {
		IterableExtensions::take(source.drop(startIndex), count)
	}

	/**
	 * Whether {@link first} and {@link second} are pairwise equal.
	 */
	def static <T> boolean sequenceEqual(Iterable<? extends T> first, Iterable<? extends T> second) {
		sequenceEqual(first, second, [a, b | a == b])
	}
	
	/**
	 * Whether {@link first} and {@link second} are pairwise equal according to {@link comparator}.
	 */
	def static <T> boolean sequenceEqual(Iterable<? extends T> first, Iterable<? extends T> second, (T, T) => boolean comparator) {
		first.size == second.size && zip(first, second, comparator).all[it].first
	}

}