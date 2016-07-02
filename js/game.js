function setup() {
  console.log('hi');
}

// Create a two dimensional array given two dimensions and a function to fill the array
var spawnArr = function (w, h, pred) {
  var arr = Array(h);
  for (var i = 0; i < h; i += 1) {
    var arrRow = Array(w);
    for (var j = 0; j < w; j += 1) {
      arrRow[j] = 1;
    }
    arr[i] = arrRow;
  }
  return arr;
}
