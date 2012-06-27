package hu.cubussapiens.r4jx

import org.junit.Test
import static junit.framework.Assert.*

import static hu.cubussapiens.r4jx.Iterables.*

class TestIterables {
	
	@Test def rangeWithStep() {
		assertTrue(makeIterable(1, 3, 5).elementsEqual(range(1, 3, 2)))
	}

}