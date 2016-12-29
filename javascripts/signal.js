// The amount of segment points we want to create:
var amount = 6;

// The maximum height of the wave:
var height = 60;

// Create a new path and style it:
var path = new Path({
	// 80% black:
	strokeColor: [0.8],
	// strokeWidth: 30,
	strokeCap: 'square'
});

// Add 5 segment points to the path spread out
// over the width of the view:
for (var i = 0; i <= amount; i++) {
	path.add(new Point(i / amount, 1) * view.size);
}
var path2 = new Path({
	// 80% black:
	strokeColor: [0.8],
	// strokeWidth: 30,
	strokeCap: 'square'
});

for (var i = 0; i <= amount; i++) {
	path2.add(new Point(i / amount, 1) * view.size);
}

var path3 = new Path({
	// 80% black:
	strokeColor: [0.8],
	// strokeWidth: 30,
	strokeCap: 'square'
});

for (var i = 0; i <= amount*2; i++) {
	path3.add(new Point(i / 2 / amount, 1) * view.size);
}

var path4 = new Path({
	// 80% black:
	strokeColor: [0.8],
	// strokeWidth: 30,
	strokeCap: 'square'
});

for (var i = 0; i <= amount; i++) {
	path4.add(new Point(i * 2 / amount, 1) * view.size);
}

var path5 = new Path({
	// 80% black:
	strokeColor: [0.8],
	// strokeWidth: 30,
	strokeCap: 'square'
});

for (var i = 0; i <= amount; i++) {
	path5.add(new Point(i / amount, 1) * view.size);
}

var pathTS = new Path({
// 	100% black:
	strokeColor: [0],
	// strokeWidth: 30,
	strokeCap: 'square'
});

for (var i = 0; i <= 10; i++) {
	pathTS.add(new Point(i / 10, 1) * view.size);
}

var underline = new Path({
// 	100% black:
	strokeColor: [0],
	// strokeWidth: 30,
	strokeCap: 'square'
});

for (var i = 0; i <= 10; i++) {
	underline.add(new Point(i / 10, 1) * view.size);
}

// Select the path, so we can see how it is constructed:
// pathTS.selected = true;

function onFrame(event) {
	// Loop through the segments of the path:

    if (event.count < 300) {
        
    for (var i = 0; i <= amount; i++) {
		var segment = path.segments[i];

		// A cylic value between -1 and 1
		var sinus = Math.sin(event.time * 3 + i);
		
		// Change the y position of the segment point:
		segment.point.y = sinus * height * (event.time % 2)  + 100;
		segment.smooth();
	}
	
	for (var i = 0; i <= amount; i++) {
		var segment2 = path2.segments[i];

		// A cylic value between -1 and 1
		var cosinus = Math.cos(event.time * 3 + i);
		
		// Change the y position of the segment point:
		segment2.point.y = cosinus * height * ((event.time-1) % 2)  + 100;
		segment2.smooth();
	}
	
	for (var i = 0; i <= amount*2; i++) {
		var segment3 = path3.segments[i];

		// A cylic value between -1 and 1
		var fourier = Math.sin(event.time * 5 + amount - i) + Math.cos(event.time * 5 + amount - i);
		// Change the y position of the segment point:
		segment3.point.y = fourier * height * ((event.time-1) % 2)  + 100;
		segment3.smooth();
	}
	
	for (var i = 0; i <= amount; i++) {
		var segment4 = path4.segments[i];

		// A cylic value between -1 and 1
		var fourier1 = Math.sin(event.time * 5 + amount - i) + Math.cos(event.time * 5 + amount - i);
		
		// Change the y position of the segment point:
		segment4.point.y = fourier1 * height * ((event.time-1) % 2)  + 100;
		segment4.smooth();
	}
	
	for (var i = 0; i <= amount; i++) {
		var segment5 = path5.segments[i];

		// A cylic value between -1 and 1
		var fourier2 = Math.cos(1/event.time * 5 + i) + Math.sin(event.time * 5 - amount + i);
		
		// Change the y position of the segment point:
		segment5.point.y = fourier2 * height * ((event.time-1) % 2)  + 100;
		segment5.smooth();
	}
	
    }

    if (event.count >= 300) {
        path.remove();
        path2.remove();
        path3.remove();
        path4.remove();
        path5.remove(); 
    // }   	
	for (var i = 0; i <= 10; i++) {
		var segmentTS = pathTS.segments[i];

		// A cylic value between -1 and 1
		var TS = Math.sin((i*.5-1))*(i*.5-1);
		segmentTS.point.y = TS * height  + 100;
		segmentTS.smooth();
		segmentTS.smooth();
	}
        
    }
}
