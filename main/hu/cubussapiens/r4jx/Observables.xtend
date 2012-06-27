package hu.cubussapiens.r4jx

import hu.akarnokd.reactive4java.reactive.Observable

import static extension hu.cubussapiens.r4jx.Observables.*
import static extension hu.akarnokd.reactive4java.reactive.Reactive.*
import static extension hu.akarnokd.reactive4java.interactive.Interactive.*
import hu.akarnokd.reactive4java.base.Scheduler
import hu.akarnokd.reactive4java.reactive.Observer
import java.util.List
import com.google.common.collect.Lists

class Observables {

	private new() {
	}

	/**
	 * Emits the first {@link count} elements from {@link source}. 
	 */
	def static <T> Observable<T> takeFirst(Observable<? extends T> source, int count) {
		source.where[index, _ | index < count]
	}

	/**
	 * Emits the first element of {@link source}, if any.
	 */
	def static <T> Observable<T> takeFirst(Observable<? extends T> source) {
		source.takeFirst(1)
	}

	/**
	 * Emits the last element of {@link source}, if any.
	 */
	def static <T> Observable<T> takeLast(Observable<? extends T> source) {
		source.takeLast(1)
	}
	
	/**
	 * Buffer the nodes as they become available and send them out in bufferSize chunks.
	 * The observers return a new and modifiable list of T on every next() call.
	 * @param <T> the type of the elements
	 * @param source the source observable
	 * @param bufferSize the target buffer size
	 * @param skip the number of new elements in the next buffer (0 means bufferSize)
	 * @return the observable of the list
	 */
	def static <T> Observable<List<T>> buffer(Observable<? extends T> source, int bufferSize, int skip) {
		[observer | source.register(new BufferObserver(bufferSize, skip, observer))]
	}
	
	/**
	 * Emits whether {@link source} started with the same elements as {@link prefix}.
	 */
	def static <T> Observable<Boolean> startsWith(Observable<? extends T> source, Iterable<? extends T> prefix) {
		toObservable(prefix).sequenceEqual(source.takeFirst(prefix.size))
	}

	/**
	 * Emits true whenever {@link source} emitted the event sequence represented by {@link infix}.
	 */
	def static <T> Observable<Boolean> emitted(Observable<? extends T> source, Iterable<? extends T> infix) {
		source.buffer(infix.size, 1).select[infix.elementsEqual(it)].where[it]
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

	/**
	 * Varargs version of {@link Reactive#toObservable(Iterable)}.
	 */
	def static <T> makeObservable(T... values) {
		toObservable(toIterable(values))
	}
	
	/**
	 * Varargs version of {@link Reactive#toObservable(Iterable, Scheduler)}.
	 */
	def static <T> makeObservable(Scheduler pool, T... values) {
		toObservable(toIterable(values), pool)
	}

}

class BufferObserver<T> implements Observer<T> {

	new(int bufferSize, int skip, Observer<? super List<T>> observer) {
		this.bufferSize = bufferSize
		this.skip = skip
		this.observer = observer
	}

	val int bufferSize

	val int skip

	val Observer<? super List<T>> observer

	var List<T> buffer = newArrayList()

	override void error(Throwable ex) {
		observer.error(ex)
	}

	override void finish() {
		if (buffer != null && buffer.size() > 0) {
			observer.next(buffer)
		}
		observer.finish()
	}

	override void next(T value) {
		buffer.add(value as T)
		if (buffer.size() == bufferSize) {
			observer.next(buffer)
			buffer = if (skip == 0) <T>newArrayList else Lists::<T>newArrayList(buffer.drop(skip))
		}
	}
	
}