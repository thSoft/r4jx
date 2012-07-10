package hu.cubussapiens.r4jx

import org.junit.Test

import static hu.cubussapiens.r4jx.Iterables.*
import static junit.framework.Assert.*

import static extension hu.cubussapiens.r4jx.TestInteractive.*
import static extension hu.akarnokd.reactive4java.interactive.Interactive.*
import org.eclipse.xtext.xbase.lib.IterableExtensions

class TestInteractive {

	def static <T> makeString(Iterable<T> source) {
		IterableExtensions::join(source, ", ")
	}

	def static <T> assertCompare(Iterable<? extends T> expected, Iterable<? extends T> actual, boolean eq) {
		val message = "expected: " + expected.makeString + "; actual: " + actual.makeString
		val condition = expected.elementsEqual(actual)
		assertTrue(message, if (eq) condition else !condition)
	}

	def static <T> assertEqual(Iterable<? extends T> expected, Iterable<? extends T> actual) {
		assertCompare(expected, actual, true)
	}

	def static <T> assertNotEqual(Iterable<? extends T> expected, Iterable<? extends T> actual) {
		assertCompare(expected, actual, false)
	}

	@Test def take() {
		val prefix = makeIterable(1, 2)
		val i = prefix.concat(makeIterable(3, 4))
		assertEqual(i.take(prefix.size), prefix)
	}

}