package hu.cubussapiens.r4jx

import org.junit.Test

import static hu.akarnokd.reactive4java.TestInteractive.*
import static hu.cubussapiens.r4jx.Iterables.*

class TestIterables {

	@Test def rangeWithStep() {
		assertEqual(makeIterable(1, 3, 5), range(1, 3, 2))
	}

}