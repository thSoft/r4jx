package hu.cubussapiens.r4jx

import hu.akarnokd.reactive4java.reactive.Reactive
import java.util.NoSuchElementException
import org.junit.Test

import static hu.akarnokd.reactive4java.interactive.Interactive.*
import static hu.cubussapiens.r4jx.Observables.*
import static junit.framework.Assert.*

import static extension hu.akarnokd.reactive4java.reactive.Reactive.*
import static extension hu.cubussapiens.r4jx.Iterables.*
import hu.akarnokd.reactive4java.base.TooManyElementsException

class TestReactive {
	
	@Test(timeout = 500) def take() {
		val i = makeIterable(1, 2)
		val o = toObservable(i).concat(makeObservable(3, 4))
		assertTrue(o.take(i.size).toIterable.elementsEqual(i))
	}
	
	@Test def sequenceEquals() {
		val o = makeObservable(1, 2)
		assertTrue(o.sequenceEqual(o).single)
	}

	@Test def sequenceEqualsNotJustPrefix() {
		val prefix = makeIterable(1, 2).toObservable
		val o = prefix.concat(makeObservable(3, 4))
		assertFalse(o.sequenceEqual(prefix).single)
	}

	@Test def sequenceEqualsCommutative() {
		val prefix = makeIterable(1, 2).toObservable
		val o = prefix.concat(makeObservable(3, 4))
		assertEquals(prefix.sequenceEqual(o).single, o.sequenceEqual(prefix).single)
	}

	@Test def windowWithSkip() {
		val i = makeIterable(1, 2, 3, 4, 5)
		val bufferSize = 4
		val skip = 2
		val result = i.toObservable.window(bufferSize, skip).select[toIterable].toIterable
		val expected = makeIterable(i.subsequence(0, bufferSize), i.subsequence(skip, bufferSize))
		assertTrue(sequenceEqual(expected, result, [a, b | a.elementsEqual(b)]))
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