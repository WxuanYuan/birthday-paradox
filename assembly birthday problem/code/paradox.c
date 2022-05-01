#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

extern float birthday_num(unsigned long n, float p);

/*
 * um die Perfomanz und Ergenisse zu vergleichen 
 * zwischen dem C-Code und dem Asm-Code
 */
static float birthday_num_C(unsigned long n, float p) {
	return (float)(((float)1 + sqrt(1 - 8 * n * log(1 - p))) / 2);
}

static void printUsage(char** argv) {
	printf("Usage: %s <number(> 0)> <possibility(0 to 1)>\n", argv[0]);
}

int main(int argc, char** argv) {
	unsigned long n = 0;
	float p = 0.0;

	/* ** Parameters checken
	 * wenn es nicht genug Parameters gibt oder,
	 * wenn n oder p eine negative Zahl ist
	 * erinnern den Benutzer an das richtige USAGE
	 */
	if (argc < 3 || argv[1][0] == '-' || argv[2][0] == '-') {
		printUsage(argv);
		return 1;
	}

	int i = 0;
	/* 
	 * argv[1] in eine vorzeichenlose LONG Zahl n umwandeln
	 */
	for (i = 0; argv[1][i] != '\0'; i++) {
		if (i > 0) n = n * 10;
		n += (argv[1][i] - '0');
	}

	/* 
	 * argv[2] in eine Gleitkommazahl p umwandeln
	 */ 
	for (i = 0; argv[2][i] != '\0'; i++) {
		if (argv[2][i] == '.') break;
	}
	/* ** Parameters checken
	 * wenn es gibt keine Komma in argv[2], d.h. 
	 * argv[2] nicht Gleitkommazahl ist,
	 * erinnern den Benutzer an das richtige USAGE
	 */
	if (argv[2][i] == '\0') {
		printUsage(argv);
		return 1;
	}
	/* ** Parameters checken
	 * String vor '.' von argv[2] in eine LONG Zahl pd umwandeln,
	 * um zu checken, ob es eine Zahl zwischen 0 und 1
	 */
	long pd = 0;
	for (int j = 0; j < i; j++) {
		if (j > 0) pd = pd * 10;
		pd += (argv[2][j] - '0');
	}
	if (pd < 0 || pd >= 1) {
		printUsage(argv);
		return 1;
	}

	/*
	 * String nach '.' von argv[2] in eine Gleitkommazahl p umwandeln
	 */
	for (i = i + 1; argv[2][i] != '\0'; i++) {
		p += (float)((argv[2][i] - '0') / pow(10, (i - 1) * (1)));
	}

	printf("n = %lu, p = %f\n", n, p);

	printf("Compare the results:\nC: ");
	float k = 0.0;
	double timeC = 0.0;
	double startTime = clock();
	k = birthday_num_C(n, p);
	double endTime = clock();
	printf("k >= %f\n", k);
	timeC = endTime - startTime;

	printf("Assembly: ");
	double timeAsm = 0.0;
	startTime = clock();
	k = birthday_num(n, p);
	endTime = clock();
	printf("k >= %f\n", k);
	timeAsm = endTime - startTime;

	printf("Time of calculation\nC: %f\nAssembly: %f\n", timeC, timeAsm);

	return 0;
}

