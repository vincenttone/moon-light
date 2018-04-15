#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "ve.h"

int ve_encode(VeData *vd)
{
	char a1;
	char a2 = 0;
	char *a3;
	size_t i;
	size_t j = 0;
	size_t l; // left
	size_t n = 6; // need
	vd->len = 0;
	for (i = 0; i< vd->is; i++) {
		a1 = *(vd->in + i);
		l = 8;
	compute:
		if (l >= n) {
			l = l - n;
			a2 = (((a1 & ((0xff << l) & 0xff)) >> l) | a2) & 0x3f;
			a3 = vd->out + j;
			*a3 = a2;
			vd->len++;
			n = 6;
			a2 = 0x0;
			if (++j > vd->os) {
				return -1;
			}
			goto compute;
		} else if (l == 0) {
			continue;
		} else {
			a2 = (((a1 << (8 - l)) & 0xff) >> (8 - n)) | a2;
			n = n - l;
			l = 0;
		}
	}
	if (n > 0) {
		a3 = vd->out + j;
		*a3 = a2;
		vd->len++;
	}
	return 3 - (vd->is % 3);
}


int main()
{
	static const char base64tbl[] = {// base64 alphabet
		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
		'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
		'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
		'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
		'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
		'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
		'w', 'x', 'y', 'z', '0', '1', '2', '3',
		'4', '5', '6', '7', '8', '9', '+', '/',
	};
	VeData *d = calloc(1, sizeof(VeData));
	char a[4] = "abcd";
	d->in = a;
	d->is = 4;
	d->out = malloc(sizeof(char) * 10);
	d->os = 10;
	size_t s = ve_encode(d);
	printf("len: %zu, return: %zu\n", d->len, s);
	size_t i;
	for (i = 0; i< d->len; i++) {
		printf("%c", base64tbl[*(d->out + i)]);
	}
	for (i = 0; i< s; i++) {
		printf("=");
	}
	printf("\n");
	return 0;
}
