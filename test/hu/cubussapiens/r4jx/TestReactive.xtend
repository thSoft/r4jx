package hu.cubussapiens.r4jx

import hu.akarnokd.reactive4java.reactive.Reactive
import java.util.NoSuchElementException
import org.junit.Test
import hu.akarnokd.reactive4java.base.TooManyElementsException
import hu.akarnokd.reactive4java.reactive.Observable

import static hu.akarnokd.reactive4java.interactive.Interactive.*
import static hu.cubussapiens.r4jx.Observables.*
import static junit.framework.Assert.*

import static extension hu.akarnokd.reactive4java.reactive.Reactive.*
import static extension hu.cubussapiens.r4jx.Iterables.*
import static extension hu.cubussapiens.r4jx.TestInteractive.*
import static extension hu.cubussapiens.r4jx.TestReactive.*

class TestReactive {

	def static makeString(Observable<?> source) {
		source.toIterable.makeString
	}

	def static <T> assertCompare(Observable<? extends T> expected, Observable<? extends T> actual, boolean eq) {
		val message = "expected: " + expected.makeString + "; actual: " + actual.makeString
		val condition = expected.sequenceEqual(actual).single
		assertTrue(message, if (eq) condition else !condition)
	}

	def static <T> assertEqual(Observable<? extends T> expected, Observable<? extends T> actual) {
		assertCompare(expected, actual, true)
	}

	def static <T> assertNotEqual(Observable<? extends T> expected, Observable<? extends T> actual) {
		assertCompare(expected, actual, false)
	}

	@Test def take() {
		val prefix = makeObservable(1, 2)
		val o = prefix.concat(makeObservable(3, 4))
		assertEqual(o.take(prefix.toIterable.size), prefix)
	}

	@Test def sequenceEquals() {
		val o = makeObservable(1, 2)
		assertEqual(o, o)
	}

	@Test def sequenceEqualsNotBecauseJustPrefix() {
		val prefix = makeIterable(1, 2).toObservable
		val o = prefix.concat(makeObservable(3, 4))
		assertNotEqual(o, prefix)
	}

	@Test def sequenceEqualsCommutative() {
		val prefix = makeIterable(1, 2).toObservable
		val o = prefix.concat(makeObservable(3, 4))
		assertEqual(prefix.sequenceEqual(o), o.sequenceEqual(prefix))
	}

	@Test def windowWithSkip() {
		val i = makeIterable(1, 2, 3, 4, 5)
		val bufferSize = 4
		val skip = 2
		val result = i.toObservable.window(bufferSize, skip).select[<Integer>toIterable]
		val expected = makeObservable(i.subsequence(0, bufferSize), i.subsequence(skip, bufferSize))
		assertTrue(expected.sequenceEqual(result, [a, b | a.elementsEqual(b)]).single)
	}

	@Test def single() {
		val expected = 42
		val o = makeObservable(expected)
		assertEquals(expected, o.single)
	}

	@Test(expected = typeof(NoSuchElementException)) def void singleNoSuchElement() {
		Reactive::empty.single
	}

	@Test(expected = typeof(TooManyElementsException)) def void singleTooManyElements() {
		makeObservable(1, 2).single
	}

}