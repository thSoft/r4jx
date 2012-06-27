package hu.cubussapiens.r4jx

import org.junit.Test

import static junit.framework.Assert.*
import static java.lang.Math.*

import static extension hu.akarnokd.reactive4java.interactive.Interactive.*
import static extension hu.akarnokd.reactive4java.reactive.Reactive.*
import static extension hu.cubussapiens.r4jx.Observables.*
import static extension hu.cubussapiens.r4jx.Iterables.*

class TestInteractive {
	
	@Test def take() {
		val prefix = makeIterable(1, 2)
		val i = prefix.concat(makeIterable(3, 4))
		assertTrue(i.take(prefix.size).elementsEqual(prefix))
	}

}