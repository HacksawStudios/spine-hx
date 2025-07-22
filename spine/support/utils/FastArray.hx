package spine.support.utils;

@:allow(FastArray)
class FastArrayInternal<T> {
	public var length:Int;

	public var data:std.Array<T>;

	public function new(shouldAlloc = true) {
		length = 0;
		if (shouldAlloc)
			data = new std.Array<T>();
	}
}

@:forward(length, data)
abstract FastArray<T>(FastArrayInternal<T>) from FastArrayInternal<T> {
	public function new(shouldAlloc = true) {
		this = new FastArrayInternal<T>();
	}

	public static function toFastArray<T>(x:std.Array<T>):FastArray<T> {
		var array = new FastArray(false);
		array.data = x;
		array.length = x.length;
		return array;
	}

	@:op([]) public function get(index:Int):T {
		return this.data[index];
	}

	@:op([]) public function set(index:Int, value:T):T {
		this.data[index] = value;
		return value;
	}

	public function push(x:T):Int {
		if (this.length >= this.data.length) {
			this.data.push(x);
		} else {
			this.data[this.length] = x;
		}
		return this.length++;
	}

	public function pop():Null<T> {
		this.length--;
		return this.data[this.length];
	}

	public function concat(a:FastArray<T>):FastArray<T> {
		var x = new FastArray<T>();
		x.data = this.data.concat(a.data);
		x.length = this.length + a.length;
		return x;
	}

	public function reverse():Void {
		this.data.reverse(); // Will cause issues
	}

	public function shift():Null<T> {
		var x = this.data.shift();
		final x = this.data[0];
		for (i in 0...(this.length - 1)) {
			this.data[i] = this.data[i + 1];
		}
		return x;
	}

	public function unshift(x:T):Void {
		push(null);
		for (j in 0...(this.length - 1)) {
			final i = this.length - j;
			this.data[i] = this.data[i - 1];
		}
		this.data[0] = x;
	}

	public function slice(pos:Int, ?end:Int):FastArray<T> {
		end = (end == null || end > this.length) ? this.length : end;
		pos = (pos < 0) ? pos + this.length : pos;
		end = (end < 0) ? end + this.length : end;
		pos = (pos < 0) ? 0 : pos;
		end = (end < 0) ? 0 : end;
		if (pos > this.length || end <= pos)
			return new FastArray<T>();

		var x:FastArray<T> = new FastArray<T>();
		for (i in pos...end) {
			x.push(this.data[i]);
		}
		return x;
	}

	public function sort(f:T->T->Int):Void {
		this.data.sort(f); // Will cause issues
	}

	public function splice(pos:Int, len:Int):FastArray<T> {
		if (len < 0 || pos > this.length)
			return new FastArray();
		if (pos < 0)
			pos = this.length + pos;
		if ((len + pos) > this.length)
			len = this.length - pos;

		var x = new FastArray<T>();
		for (i in 0...len) {
			x.push(this.data[pos + i]);
			if ((pos + len + i) < this.length)
				this.data[pos + i] = this.data[pos + len + i];
		}
		this.length -= len;
		return x;
	}

	public function toString():String {
		return this.data.toString();
	}

	public function toStdArray():std.Array<T> {
		untyped this.data.length = this.length;
		return this.data;
	}

	public function iterator():Iterator<T> {
		var i = 0;
		return {
			hasNext: function() {
				return i < this.length;
			},
			next: function() {
				return this.data[i++];
			}
		};
	}

	public function unsafeSet(index:Int, value:T):Void {
		this.data[index] = value;
	}

	public function unsafeGet(index:Int):T {
		return this.data[index];
	}

	public function indexOf(x:T, ?fromIndex:Int):Int {
		return this.data.indexOf(x, fromIndex);
	}

	public var length(get, set):Int;

	function get_length():Int
		return this.length;

	function set_length(x:Int):Void
		this.length = x;
}
