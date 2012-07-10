package hu.cubussapiens.r4jx

import org.junit.Test

import static hu.cubussapiens.r4jx.Iterables.*
import static hu.cubussapiens.r4jx.TestInteractive.*
import static junit.framework.Assert.*

class TestIterables {

	@Test def rangeWithStep() {
		assertEqual(makeIterable(1, 3, 5), range(1, 3, 2))
	}

}