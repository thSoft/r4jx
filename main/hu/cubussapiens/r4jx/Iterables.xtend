package hu.cubussapiens.r4jx

import static extension hu.cubussapiens.r4jx.Iterables.*
import static extension hu.akarnokd.reactive4java.interactive.Interactive.*

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

}