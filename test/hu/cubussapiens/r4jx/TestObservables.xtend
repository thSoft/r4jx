package hu.cubussapiens.r4jx

import org.junit.Test

import static junit.framework.Assert.*

import static extension hu.akarnokd.reactive4java.interactive.Interactive.*
import static extension hu.akarnokd.reactive4java.reactive.Reactive.*
import static extension hu.cubussapiens.r4jx.Observables.*
import static extension hu.cubussapiens.r4jx.Iterables.*

class TestObservables {

	@Test def takeFirst() {
		val expected = 1
		val o = makeObservable(expected, 2)
		assertEquals(expected, o.takeFirst.single)
	}
	
	@Test def takeLast() {
		val expected = 2
		val o = makeObservable(1, expected)
		assertEquals(expected, o.takeLast.single)
	}

	@Test def startsWith() {
		val i = makeIterable(1, 2)
		val o = toObservable(i).concat(makeObservable(3, 4))
		assertTrue(o.startsWith(i).single)
	}
	
	@Test def startsWithNotBecauseLonger() {
		val prefix = makeIterable(1, 2)
		val i = prefix.concat(makeIterable(3, 4))
		val o = toObservable(prefix)
		assertTrue(o.startsWith(i).single)
	}
	
	@Test def startsWithNot() {
		val o = makeObservable(1, 2)
		val i = makeIterable(3, 2)
		assertFalse(o.startsWith(i).single)
	}

}