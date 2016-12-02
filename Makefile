
# CC = g++
# CFLAGS = -std=gnu++11 -g -Wall

# all: cs426_graph_server

# cs426_graph_server: cs426_graph_server.c mongoose.c Graph.cpp 
# 	$(CC) $(CFLAGS) -o $@ $^

# test: cs426_graph_server
# 	./cs426_graph_server

# clean:
# 	$(RM) cs426_graph_server *.o

#------------------------------------------------------

CXX = g++
CXXFLAGS = -std=c++11 #-g3
LDFLAGS += -L/usr/local/lib `pkg-config --libs grpc++ grpc`       \
           -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed \
           -lprotobuf -lpthread -ldl

PROTOC = protoc
GRPC_CPP_PLUGIN = grpc_cpp_plugin
GRPC_CPP_PLUGIN_PATH ?= `which $(GRPC_CPP_PLUGIN)`

PROTOS_PATH = .

vpath %.proto $(PROTOS_PATH)

EXE = cs426_graph_server

HDRS = mongoose.h Graph.h replicator.grpc.pb.h replicator.pb.h

SRCS = cs426_graph_server.c mongoose.c Graph.cpp 

OBJS = $(SRCS:.c=.o) replicator.pb.o replicator.grpc.pb.o replicator_client.o replicator_server.o

$(EXE): $(OBJS) $(HDRS)
	$(CXX) $^ $(CXXFLAGS) $(LDFLAGS) -o $@ #$(OBJS)

$(OBJS): $(HDRS)

.PRECIOUS: %.grpc.pb.cc
%.grpc.pb.cc: %.proto
	$(PROTOC) -I $(PROTOS_PATH) --grpc_out=. --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<
.PRECIOUS: %.pb.cc
%.pb.cc: %.proto
	$(PROTOC) -I $(PROTOS_PATH) --cpp_out=. $<

clean:
	rm -f core $(EXE) *.o

#------------------------------------------------------

# all: system-check replicator_client replicator_server cs426_graph_server 

# cs426_graph_server: cs426_graph_server.c mongoose.c Graph.cpp 
# 	$(CXX) $(CXXFLAGS) -o $@ $^

# replicator_client.o: replicator.pb.o replicator.grpc.pb.o replicator_client.o
# 	$(CXX) $^ $(LDFLAGS) -o $@

# replicator_server: replicator.pb.o replicator.grpc.pb.o replicator_server.o
# 	$(CXX) $^ $(LDFLAGS) -o $@

# .PRECIOUS: %.grpc.pb.cc
# %.grpc.pb.cc: %.proto
# 	$(PROTOC) --grpc_out=. --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<

# .PRECIOUS: %.pb.cc
# %.pb.cc: %.proto
# 	$(PROTOC) --cpp_out=. $<

# clean:
# 	rm -f *.o *.pb.cc *.pb.h replicator_client replicator_server 


# # The following is to test your system and ensure a smoother experience.
# # They are by no means necessary to actually compile a grpc-enabled software.

# PROTOC_CMD = which $(PROTOC)
# PROTOC_CHECK_CMD = $(PROTOC) --version | grep -q libprotoc.3
# PLUGIN_CHECK_CMD = which $(GRPC_CPP_PLUGIN)
# HAS_PROTOC = $(shell $(PROTOC_CMD) > /dev/null && echo true || echo false)
# ifeq ($(HAS_PROTOC),true)
# HAS_VALID_PROTOC = $(shell $(PROTOC_CHECK_CMD) 2> /dev/null && echo true || echo false)
# endif
# HAS_PLUGIN = $(shell $(PLUGIN_CHECK_CMD) > /dev/null && echo true || echo false)

# SYSTEM_OK = false
# ifeq ($(HAS_VALID_PROTOC),true)
# ifeq ($(HAS_PLUGIN),true)
# SYSTEM_OK = true
# endif
# endif

# system-check:
# ifneq ($(HAS_VALID_PROTOC),true)
# 	@echo " DEPENDENCY ERROR"
# 	@echo
# 	@echo "You don't have protoc 3.0.0 installed in your path."
# 	@echo "Please install Google protocol buffers 3.0.0 and its compiler."
# 	@echo "You can find it here:"
# 	@echo
# 	@echo "   https://github.com/google/protobuf/releases/tag/v3.0.0"
# 	@echo
# 	@echo "Here is what I get when trying to evaluate your version of protoc:"
# 	@echo
# 	-$(PROTOC) --version
# 	@echo
# 	@echo
# endif
# ifneq ($(HAS_PLUGIN),true)
# 	@echo " DEPENDENCY ERROR"
# 	@echo
# 	@echo "You don't have the grpc c++ protobuf plugin installed in your path."
# 	@echo "Please install grpc. You can find it here:"
# 	@echo
# 	@echo "   https://github.com/grpc/grpc"
# 	@echo
# 	@echo "Here is what I get when trying to detect if you have the plugin:"
# 	@echo
# 	-which $(GRPC_CPP_PLUGIN)
# 	@echo
# 	@echo
# endif
# ifneq ($(SYSTEM_OK),true)
# 	@false
# endif