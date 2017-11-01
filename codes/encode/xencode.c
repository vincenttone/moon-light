#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

int xencode(char *in, size_t s1, char *out, size_t s2)
{
	uint8_t a1;
	uint8_t a2;
	uint8_t *o;
	size_t i = 0;
	size_t l = 0; // len
	size_t k = 0;
	memset(out, 0x0, s2);
	for (; i < s1; i++) {
		a1 = (uint8_t)(*(in + i));
		o = (uint8_t*)(out + l);
		if (k == 0) {
			a2 = a1 << 6 >> 2;
			k = 4;
			*o = (*o) | a1;
			l += 8;
		} else if (k == 1) {
			*o = (*o) | a2 | (a1 >> 7);
			l += 8;
			o = (uint8_t*)(out + l);
			a2 = a1 << 7 >> 2;
			*o = (*o) | (a1 >> 2);
			l += 8;
			k = 7;
		} else {
			*o = (*o) | a2 | (a1 >> k);
			l += 8;
			o = (uint8_t*)(out + l);
			a2 = a1 << (8 - k) >> 2;
			k = 6 - k;
		}
	}
	if (k != 0) {
		*o = (*o) | a2;
		l += 8;
	}
	return l;
}

int encode(char *in, size_t s, char *out)
{
	uint8_t mask;
	uint8_t cur;
	uint8_t *o;
	size_t l = 0; // len
	size_t c = 0;
	size_t m;
	size_t n = 0;
	o = (uint8_t*)(out + l);
	for (;c < s; c++) {
		m = 8;
		cur = (uint8_t)(*(in + c));
		printf("read: %d\n", cur);
	append:
		if (m == 0) {
			continue;
		}
		if (n == 0) {
			goto cover;
		}
		if (m == 8 - n) {
			mask = ~ (0x7f << m);
			cur = cur & mask;
			*o = (*o) | cur;
			printf("output: %d.\n", *o);
			o = o + 8;
			l += m;
			n = 0;
		} else if (m > 8 - n) {
			mask = ~ (0x7f << (8 - n));
			cur = cur & mask;
			*o = (*o) | cur;
			printf("output: %d..\n", *o);
			o = o + 8;
			m = m + n - 8;
			l += 8;
			n = 0;
			goto cover;
		} else if (m < 8 - n) {
			cur = (cur << (8 - m)) >> n;
			*o = (*o) | cur;
			n -= m;
			m = 0;
		}
		continue;
	cover:
		printf("len: %zu, m: %zu, n: %zu\n", l, m, n);
		if (m > 6) {
			mask = (~ (0x7f << (m - 6))) & cur;
			cur = cur >> 2;
			*o = (*o) | cur;
			printf("output: %d...\n", *o);
			o = o + 8;
			cur = mask;
			m -= 6;
			l += 8;
			n = 0;
			goto append;
		} else {
			cur = (cur << m) >> 2;
			*o = (*o) | cur;
			printf("keep: %d....\n", *o);
			n = 6 - m;
			m = 0;
		}
	}
	printf("len: %zu, m: %zu, n: %zu\n", l, m, n);
	return n;
}

int main()
{
	char *buf = calloc(8, sizeof(char));
	size_t s = xencode("abcd", 4, buf, 8);
	printf("rest count: %zu\n", s);
	uint8_t *m;
	size_t x = 0;
	for (; x < 8; x++) {
		m = (uint8_t*)(buf + x);
		printf("%d\n", *m);
	}
	return 0;
}
