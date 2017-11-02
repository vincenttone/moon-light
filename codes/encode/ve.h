#ifndef _VE_H_
#define _VE_H_ 1

typedef struct _VeData{
	size_t is;
	size_t os;
	size_t len;
	char *in;
	char *out;
} VeData;

int ve_encode(VeData*);


#endif
