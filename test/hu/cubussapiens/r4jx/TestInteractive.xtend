package hu.cubussapiens.r4jx

import org.junit.Test

import static hu.cubussapiens.r4jx.Iterables.*
import static junit.framework.Assert.*

import static extension hu.akarnokd.reactive4java.interactive.Interactive.*

class TestInteractive {
	
	@Test def take() {
		val prefix = makeIterable(1, 2)
		val i = prefix.concat(makeIterable(3, 4))
		assertTrue(i.take(prefix.size).elementsEqual(prefix))
	}

}