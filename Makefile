# ---------------------------
# Alex's, separate rpc

# CXX = g++
# CXXFLAGS = -std=c++11 #-g3
# CLAGS = -std=gnu++11 -g -Wall
# LDFLAGS += -L/usr/local/lib `pkg-config --libs grpc++ grpc`       \
#            -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed \
#            -lprotobuf -lpthread -ldl

# PROTOC = protoc
# GRPC_CPP_PLUGIN = grpc_cpp_plugin
# GRPC_CPP_PLUGIN_PATH ?= `which $(GRPC_CPP_PLUGIN)`

# PROTOS_PATH = .
# INCLUDE_PATH = /usr/include/c++/4.8.4

# vpath %.proto $(PROTOS_PATH)

# EXE = cs426_graph_server

# HDRS = mongoose.h Graph.h headers.h replicator.grpc.pb.h replicator.pb.h

# SRCS = cs426_graph_server.cpp mongoose.c Graph.cpp 

# OBJS = $(SRCS:.c=.o) replicator.pb.o replicator.grpc.pb.o replicator_client.o replicator_server.o

# $(EXE): $(OBJS) $(HDRS)
# 	$(CXX) $^ $(CXXFLAGS) $(LDFLAGS) -o $@ #$(OBJS)

# $(OBJS): $(HDRS)

# .PRECIOUS: %.grpc.pb.cc
# %.grpc.pb.cc: %.proto
# 	$(PROTOC) -I $(PROTOS_PATH) --grpc_out=. --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<
# .PRECIOUS: %.pb.cc
# %.pb.cc: %.proto
# 	$(PROTOC) -I $(PROTOS_PATH) --cpp_out=. $<

# clean:
# 	rm -f core $(EXE) *.o

#----------------------------------------
# Alex's, combined rpc

# CXX = g++
# CXXFLAGS = -std=c++11 #-g3
# LDFLAGS += -L/usr/local/lib `pkg-config --libs grpc++ grpc`       \
#            -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed \
#            -lprotobuf -lpthread -ldl

# PROTOC = protoc
# GRPC_CPP_PLUGIN = grpc_cpp_plugin
# GRPC_CPP_PLUGIN_PATH ?= `which $(GRPC_CPP_PLUGIN)`

# PROTOS_PATH = .

# vpath %.proto $(PROTOS_PATH)

# EXE = cs426_graph_server

# HDRS = mongoose.h Graph.h replicator.grpc.pb.h replicator.pb.h

# SRCS = cs426_graph_server.c mongoose.c Graph.cpp 

# OBJS = $(SRCS:.c=.o) replicator.pb.o replicator.grpc.pb.o 

# $(EXE): $(OBJS) $(HDRS)
# 	$(CXX) $^ $(CXXFLAGS) $(LDFLAGS) -o $@ #$(OBJS)

# $(OBJS): $(HDRS)

# .PRECIOUS: %.grpc.pb.cc
# %.grpc.pb.cc: %.proto
# 	$(PROTOC) -I $(PROTOS_PATH) --grpc_out=. --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<
# .PRECIOUS: %.pb.cc
# %.pb.cc: %.proto
# 	$(PROTOC) -I $(PROTOS_PATH) --cpp_out=. $<

# clean:
# 	rm -f core $(EXE) *.o

# -------------------------------------------
# Mine, first

# CC = g++
# CFLAGS = -std=gnu++11 -g -Wall

# LDFLAGS += -L/usr/local/lib `pkg-config --libs grpc++ grpc`       \
#            -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed \
#            -lprotobuf -lpthread -ldl

# PROTOC = protoc
# GRPC_CPP_PLUGIN = grpc_cpp_plugin
# GRPC_CPP_PLUGIN_PATH ?= `which $(GRPC_CPP_PLUGIN)`

# PROTOS_PATH = .

# vpath %.proto $(PROTOS_PATH)

# all: cs426_graph_server

# cs426_graph_server: cs426_graph_server.c mongoose.c Graph.cpp replicator.pb.o replicator.grpc.pb.o 
# 	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

# replicator.pb.o: replicator.pb.h 

# replicator.grpc.pb.o: replicator.grpc.pb.h 

# .PRECIOUS: %.grpc.pb.cc
# %.grpc.pb.cc: %.proto
# 	$(PROTOC) -I $(PROTOS_PATH) --grpc_out=. --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<
# .PRECIOUS: %.pb.cc
# %.pb.cc: %.proto
# 	$(PROTOC) -I $(PROTOS_PATH) --cpp_out=. $<

# clean:
# 	rm -f core $(EXE) *.o

# ----------------------------------------------
# Bo's 

CC = g++
CPPFLAGS += -I/usr/local/include -pthread
CFLAGS = -std=g++11 -g -Wall
LDFLAGS += -L/usr/local/lib `pkg-config --libs grpc++ grpc`       \
           -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed \
           -lprotobuf -lpthread -ldl

PROTOC = protoc
GRPC_CPP_PLUGIN = grpc_cpp_plugin
GRPC_CPP_PLUGIN_PATH ?= `which $(GRPC_CPP_PLUGIN)`


PROTOS_PATH = .

vpath %.proto $(PROTOS_PATH)

all: cs426_graph_server

cs426_graph_server: cs426_graph_server.c mongoose.c Graph.cpp replicator_client.cc replicator_server.cc
	g++ $^ -L/usr/local/lib -lprotobuf -lpthread -ldl -std=c++0x -pthread -o cs426_graph_server

.PRECIOUS: %.grpc.pb.cc
%.grpc.pb.cc: %.proto
	$(PROTOC) -I $(PROTOS_PATH) --grpc_out=. --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<
.PRECIOUS: %.pb.cc
%.pb.cc: %.proto
	$(PROTOC) -I $(PROTOS_PATH) --cpp_out=. $<

clean:
	rm -f core $cs426_graph_server *.o


