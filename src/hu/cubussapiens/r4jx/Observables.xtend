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
	 * Emits true whenever {@link source} emitted the event sequence represented by {@link infix}.
	 */
	def static <T> Observable<Boolean> emitted(Observable<? extends T> source, Iterable<? extends T> infix) {
		source.selectMany[source.startsWith(toObservable(infix))].where[it]
	}

	/**
	 * Emits a combination of the latest values of the given streams whenever one sends a new value.
	 */
	def static <A, B, C, D> Observable<D> combineLatest(Observable<? extends A> oa, Observable<? extends B> ob, Observable<? extends C> oc, (A, B, C) => D selector) {
		combineLatest(oa, ob, [a, b | new Tuple2(a, b)]).combineLatest(oc, [ab, c | selector.apply(ab.a, ab.b, c)]) 
	}

	/**
	 * Emits a combination of the latest values of the given streams whenever one sends a new value.
	 */
	def static <A, B, C, D, E> Observable<E> combineLatest(Observable<? extends A> oa, Observable<? extends B> ob, Observable<? extends C> oc, Observable<? extends D> od, (A, B, C, D) => E selector) {
		combineLatest(oa, ob, oc, [a, b, c | new Tuple3(a, b, c)]).combineLatest(od, [abc, d | selector.apply(abc.a, abc.b, abc.c, d)]) 
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
