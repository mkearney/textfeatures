#define _XOPEN_SOURCE 600

#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME:
   Check these declarations against the C/Fortran source code.
*/

/* .C calls */
extern void cwrapper_word2vec(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);

static const R_CMethodDef CEntries[] = {
    {"cwrapper_word2vec", (DL_FUNC) &cwrapper_word2vec, 11},
    {NULL, NULL, 0}
};

void R_init_textfeatures(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
