package hu.cubussapiens.r4jx

import org.eclipse.xtext.xbase.lib.IterableExtensions

import static extension hu.akarnokd.reactive4java.interactive.Interactive.*
import static extension hu.cubussapiens.r4jx.Iterables.*
import static com.google.common.collect.ImmutableList.*
import static hu.akarnokd.reactive4java.base.Functions.*
import static com.google.common.collect.Iterables.*
import static com.google.common.base.Predicates.*

class Iterables {

	private new() {
	}

	// Create

	/**
	 * Returns the given elements.
	 */
	def static <T> Iterable<T> makeIterable(T... values) {
		toIterable(values)
	}

	/**
	 * Returns {@link count} numbers from {@link start} incremented by {@link step}.
	 */
	def static Iterable<Integer> range(int start, int count, int step) {
		generate(start, [it < start + count * step], [it + step])
	}

	/**
	 * Returns the repeated applications of {@link function} starting from {@link seed}.
	 */
	def static <T> Iterable<T> iterate(T seed, (T) => T function) {
		generate(seed, [true], function)
	}

	// Transform

	/**
	 * Takes the first {@link count} elements from {@link source}.
	 */
	def static <T> Iterable<T> takeFirst(Iterable<T> source, int count) {
		IterableExtensions::take(source, count)
	}

	/**
	 * Returns {@link count} elements starting from {@link startIndex} from {@link source}.
	 */
	def static <T> Iterable<T> subsequence(Iterable<T> source, int startIndex, int count) {
		source.drop(startIndex).takeFirst(count)
	}

	/**
	 * Returns the elements from {@link source} except the first ones which satisfy {@link predicate}.
	 */
	def static <T> Iterable<T> dropWhile(Iterable<T> source, (T) => boolean predicate) {
		source.drop(indexOf(source, not(predicate)))
	}

	/**
	 * Returns the elements from {@link source} in reverse order.
	 */
	def static <T> Iterable<T> reverse(Iterable<T> source) {
		copyOf(source).reverseView
	}

	/**
	 * Returns the product of the elements from {@link source}.
	 */
	def static <T extends Number> Iterable<Double> product(Iterable<T> source) {
		source.aggregate([double accumulator, value | accumulator * value.doubleValue], identityFirst)
	}

	// Compare

	/**
	 * Whether {@link source} starts with {@link prefix}.
	 */
	def static boolean startsWith(Iterable<?> source, Iterable<?> prefix) {
		prefix.elementsEqual(source.take(prefix.size))
	}

	/**
	 * Whether {@link source} ends with {@link suffix}.
	 */
	def static boolean endsWith(Iterable<?> source, Iterable<?> suffix) {
		suffix.elementsEqual(source.takeLast(suffix.size))
	}

	/**
	 * Whether the elements of {@link first} and {@link second} are pairwise equal.
	 */
	def static boolean sequenceEqual(Iterable<?> first, Iterable<?> second) {
		sequenceEqual(first, second, [a, b | a == b])
	}

	/**
	 * Whether the elements of {@link first} and {@link second} are pairwise equal according to {@link comparator}.
	 */
	def static <T> boolean sequenceEqual(Iterable<? extends T> first, Iterable<? extends T> second, (T, T) => boolean comparator) {
		first.size == second.size && zip(first, second, comparator).all[it].first
	}

}