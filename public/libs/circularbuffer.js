// Circular buffer storage. Externally-apparent 'length' increases indefinitely
// while any items with indexes below length-n will be forgotten (undefined
// will be returned if you try to get them, trying to set is an exception).
// n represents the initial length of the array, not a maximum
function CircularBuffer(n, m) {
    this._array= new Array(n);
    this.length= 0;
    if(m > 1) {
      for(j = 0; j < n; j++) {
        this._array[j] = new Uint8Array (m);
      }
    }
}
CircularBuffer.prototype.toString= function() {
    return '[object CircularBuffer('+this._array.length+') length '+this.length+']';
};
CircularBuffer.prototype.get= function(i) {
    if (i<0 || i<this.length-this._array.length)
        return undefined;
    return this._array[i%this._array.length];
};
CircularBuffer.prototype.set= function(i, v) {
    if (i<0 || i<this.length-this._array.length)
        throw CircularBuffer.IndexError;
    while (i>this.length) {
        this._array[this.length%this._array.length]= undefined;
        this.length++;
    }
    this._array[i%this._array.length]= v;
    if (i==this.length)
        this.length++;
};
CircularBuffer.prototype.push = function(v) { 
  this._array[this.length%this._array.length] = v; 
  this.length++; 
};
CircularBuffer.prototype.avg=function(){
  if(this._array[0].length != undefined) {
    var n = this._array.length;
    var m = this._array[0].length;
    var avg = new Uint8Array(m);
    for(var i = 0; i < m; i++) {
      var sum = 0;
      for(j = 0; j < n; j++) {
        sum += this._array[j][i];
      }
      avg[i] = sum / n;
    }
    return avg;
  }
  return null;
} 
CircularBuffer.IndexError= {};
