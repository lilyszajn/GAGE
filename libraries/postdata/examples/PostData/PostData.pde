import postdata.*;

PostData pd = new PostData(); // I invented this class... it would be the name of the library for Processing

// three things you need
// a URL
// an array of variable names
// an array of values to match those variables
// would be a great use of an associative array, but maybe that is confusing
/*
	TODO:
	We could make a "setURL" function
	and we could make a "setParam" function
	and finally a "postData" function
	to break up the work a bit
*/
//String url = "http://itp.nyu.edu/~cpa234/apps/hook/postTest.php";

// could be arbitrarily(spelling?) long
//String vars[] = { "id", "email" }; 

// must match length of vars (there is error checking). enter you're email here and get a surprise!
//String vals[] = { "4", "chrisallick@gmail.com" };

String url = "http://l:4567/log";
String vars[] = {"lat", "lng", "altitude", "time"};
String vals[] = {"10", "asdf", "123", "123"};

void setup() {
    

	String code = pd.post( url, vars, vals );
}

void draw() { }
