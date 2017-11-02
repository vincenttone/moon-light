#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "ve.h"

#define XE_MASK 0xff

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
		printf("in: %d\n", a1);
	compute:
		printf("left: %zu, need: %zu\n", l, n);
		if (l >= n) {
			l = l - n;
			printf("((%d & %d) >> %zu) | %d\n", a1, (0xff << l) & 0xff, l, a2);
			a2 = ((a1 & ((0xff << l) & 0xff)) >> l) | a2;
			a3 = vd->out + j;
			*a3 = a2;
			printf("out: %d.\n", a2);
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
		printf("out: %d\n", a2);
	}
	return n;
}

int ve_encode_v0(VeData *vd)
{
	uint32_t a1;
	uint32_t *a2;
	size_t i = 0;
	size_t j;
	vd->len = 0;
	for (; i< vd->is; i++) {
		j = 8;
		printf("input: %d\n", *(vd->in + i));
		switch (i % 3) {
		case 0:
			if (i != 0) {
				printf("%d\n", a1);
				a2 = (uint32_t*)(vd->out + (32 * i / 3));
				*a2 = (*a2) | a1;
				vd->len++;
			}
			a1 = 0x0;
			a1 = ((*(vd->in + i) & 0xfc) << 22) | a1;
			j -= 6;
			if (j == 0) continue;
			printf("A1: %d\n", a1);
			a1 = ((*(vd->in + i) & 0x3) << 20) | a1;
			j -= 2;
			if (j == 0) continue;
			printf("A1: %d\n", a1);
		case 1:
			a1 = ((*(vd->in + i) & 0xfa) << 12) | a1;
			j -= 4;
			if (j == 0) continue;
			printf("A1: %d\n", a1);
			a1 = ((*(vd->in + i) & 0xe) << 10) | a1;
			printf("A1: %d\n", a1);
			j -= 4;
			if (j == 0) continue;
		case 2:
			a1 = ((*(vd->in + i) & 0x3) << 2) | a1;
			printf("A1: %d\n", a1);
			j -= 2;
			if (j == 0) continue;
			a1 = (*(vd->in + i) & 0x40) | a1;
			printf("A1: %d\n", a1);
			j -= 6;
			if (j == 0) continue;
		}
	}
	if (i % 3 != 0) {
		printf("%d.\n", a1);
		*a2 = (*a2) | a1;
		vd->len++;
	}
	return i;
}

int xencode(char *in, size_t s1, char *out, size_t s2)
{
	uint8_t a1;
	uint8_t a2;
	uint8_t *o;
	size_t i = 0;
	size_t l = 0; // len
	size_t k = 0;
	memset(out, 0x0, s2);
	o = (uint8_t*)out;
	for (; i < s1; i++) {
		a1 = (uint8_t)(*(in + i));
		if (k == 0) {
			a2 = (a1 << 6 & XE_MASK) >> 2;
			printf("A2.: %d, A1: %d, k: %zu\n", a2, a1, k);
			k = 4;
			*o = (*o) | (a1 >> 2);
			printf("---output: %d.\n", *o);
			o = (uint8_t*)(out + l);		
			l += 8;
		} else if (k == 1) {
			*o = (*o) | a2 | (a1 >> 7);
			printf("---output: %d..\n", *o);
			o = (uint8_t*)(out + l);
			l += 8;
			a2 = (a1 << 7 & XE_MASK) >> 2;
			printf("A2: %d..\n", a2);
			*o = (*o) | (a1 >> 2);
			printf("---output: %d...\n", *o);
			o = (uint8_t*)(out + l);
			l += 8;
			k = 7;
		} else {
			*o = (*o) | a2 | (a1 >> (8 - k));
			printf("---output: %d....\n", *o);
			l += 8;
			o = (uint8_t*)(out + l);
			a2 = (a1 << (8 - k) & XE_MASK) >> 2;
			printf("A2: %d, A1: %d, k: %zu\n", a2, a1, k);
			k = k - 2;
			if (k == 0) {
				*o = (*o) | a2;
				printf("---output: %d......\n", *o);
				l += 8;
				o = (uint8_t*)(out + l);
			}
		}
	}
	if (k != 0) {
		*o = (*o) | a2;
		printf("---output: %d.....\n", *o);
		l += 8;
	}
	return l;
}

int main()
{
	VeData *d = calloc(1, sizeof(VeData));
	char a[4] = "abcd";
	d->in = a;
	d->is = 4;
	d->out = malloc(sizeof(char) * 10);
	d->os = 10;
	size_t s = ve_encode(d);
	return 0;
}
