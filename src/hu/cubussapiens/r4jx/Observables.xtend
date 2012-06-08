package hu.cubussapiens.r4jx

import hu.akarnokd.reactive4java.reactive.Observable

import static extension hu.cubussapiens.r4jx.Observables.*
import static extension hu.akarnokd.reactive4java.reactive.Reactive.*

class Observables {

	private new() {
	}

	/**
	 * Emits the last element of {@link source}, if any.
	 */
	def static <T> Observable<T> takeLast(Observable<? extends T> source) {
		source.takeLast(1)
	}

	/**
	 * Emits the first element of {@link source}, if any.
	 */
	def static <T> Observable<T> takeFirst(Observable<? extends T> source) {
		source.take(1)
	}
	
	/**
	 * Emits whether {@link first} and {@link second} emitted the same elements when either one completes.
	 */
	def static <T> Observable<Boolean> startWithSameValues(Observable<? extends T> first, Observable<? extends T> second) {
		zip(first, second, [a, b | a == b]).all[true]
	}
	
	/**
	 * Emits whether {@link source} emitted the same elements as {@link prefix} when {@link prefix} completes.
	 */
	def static <T> Observable<Boolean> startsWith(Observable<? extends T> source, Observable<? extends T> prefix) {
		source.takeUntil(prefix.takeLast).sequenceEqual(prefix)
	}

	/**
	 * Registers an observer with an {@link onNext} handler concisely.
	 */
	def static <T> register(Observable<? extends T> source, (T) => void onNext) {
		source.register(toObserver(onNext))
	}

	/**
	 * Registers an observer with an {@link onNext} and {@link onFinish} handler concisely.
	 */
	def static <T> register(Observable<? extends T> source, (T) => void onNext, () => void onFinish) {
		source.register(toObserver(onNext, [], onFinish))
	}

	/**
	 * Registers an observer with an {@link onNext}, {@link onFinish} and {@link onError} handler concisely.
	 */
	def static <T> register(Observable<? extends T> source, (T) => void onNext, () => void onFinish, (Throwable) => void onError) {
		source.register(toObserver(onNext, onError, onFinish))
	}

}
