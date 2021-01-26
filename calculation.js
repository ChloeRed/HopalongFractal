inlets = 1; 
outlets = 2;

function calculateXY(a,b,c,x,y) {
	var xx = y - (findSign(x)) * Math.pow(Math.abs((b*x) - c), 0.5); 
    var yy = a - x; 
	outlet(0, xx); 
	outlet(1, yy);  
	}

function findSign(x) {
	if (x < 0) {
		return -1; 
	} else if (x >0) {
		return 1; 
	}else {
		return 0; 
	}
}