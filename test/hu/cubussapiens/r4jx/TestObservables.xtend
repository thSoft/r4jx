package hu.cubussapiens.r4jx

import org.junit.Test
import hu.akarnokd.reactive4java.query.IterableBuilder
import org.eclipse.xtext.xbase.lib.InputOutput

import static junit.framework.Assert.*
import static java.lang.Math.*

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

	@Test def bufferWithSkip() {
		val e1 = 1
		val e2 = 2
		val e3 = 3
		val e4 = 4
		val e5 = 5
		val i = makeIterable(e1, e2, e3, e4, e5)
		val result = i.toObservable.buffer(4, 2).toIterable
		val expected = makeIterable(makeIterable(e1, e2, e3, e4), makeIterable(e3, e4, e5))
		IterableBuilder::from(expected.select[toList]).print
		InputOutput::println
		IterableBuilder::from(result).print
		assertEquals(expected.size, result.size)
		assertTrue(zip(expected, result, [a, b | a.elementsEqual(b)]).all[it].first)
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

	@Test def emittedOnce() {
		val i = makeIterable(1, 2)
		val o = makeObservable(0).concat(toObservable(i)).concat(makeObservable(3, 4))
		assertTrue(o.emitted(i).single)
	}
	
	@Test def emittedMultipleTimes() {
		val i = makeIterable(1, 2)
		val o = makeObservable(0).concat(toObservable(i)).concat(toObservable(i)).concat(makeObservable(3, 4))
		assertTrue(o.emitted(i).toIterable.elementsEqual(makeIterable(true, true)))
	}
	
	@Test def emittedNot() {
		val o = makeObservable(1, 2, 3)
		val i = makeIterable(3, 2)
		assertFalse(o.startsWith(i).single)
	}

}