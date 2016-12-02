#include <pthread.h>

#include "Graph.h"

#define I2_ADDRESS "104.197.8.216:50051"
#define I3_ADDRESS "104.198.211.89:50051"

#define RPC_FAILED 500

#define ADD_NODE 0
#define REMOVE_NODE 1
#define ADD_EDGE 2
#define REMOVE_EDGE 3

#ifdef __cplusplus
	#define EXTERNC extern "C"
#else
	#define EXTERNC
#endif

EXTERNC void *RunServer(void *);
EXTERNC int Propogate(const int, const uint64_t, const uint64_t);

#undef EXTERNC