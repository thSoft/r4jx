package hu.cubussapiens.r4jx

import org.junit.Test

import static hu.cubussapiens.r4jx.Iterables.*
import static junit.framework.Assert.*

class TestIterables {
	
	@Test def rangeWithStep() {
		assertTrue(makeIterable(1, 3, 5).elementsEqual(range(1, 3, 2)))
	}

}