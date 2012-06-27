package hu.cubussapiens.r4jx

import org.eclipse.xtext.xbase.lib.IterableExtensions

import static extension hu.akarnokd.reactive4java.interactive.Interactive.*
import static extension hu.cubussapiens.r4jx.Iterables.*

class Iterables {

	private new() {
	}

	// Create

	def static <T> Iterable<T> makeIterable(T... values) {
		toIterable(values)
	}

	/**
	 * Returns {@link count} numbers from {@link start} incremented by {@link step}.
	 */
	def static Iterable<Integer> range(int start, int count, int step) {
		generate(start, [it < start + count * step], [it + step])
	}

	// Transform

	/**
	 * Takes the first {@link count} elements from {@link source}. 
	 */
	def static <T> Iterable<? extends T> takeFirst(Iterable<? extends T> source, int count) {
		IterableExtensions::take(source, count)
	}

	/**
	 * Returns {@link count} elements starting from {@link startIndex} from {@link source}.
	 */
	def static <T> Iterable<? extends T> subsequence(Iterable<T> source, int startIndex, int count) {
		source.drop(startIndex).takeFirst(count)
	}

	// Compare

	/**
	 * Whether {@link source} starts with the same elements as {@link prefix}.
	 */
	def static <T> boolean startsWith(Iterable<? extends T> source, Iterable<? extends T> prefix) {
		prefix.elementsEqual(source.take(prefix.size))
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