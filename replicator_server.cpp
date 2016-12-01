#include <algorithm>
#include <chrono>
#include <cmath>
#include <iostream>
#include <memory>
#include <string>

#include <grpc/grpc.h>
#include <grpc++/server.h>
#include <grpc++/server_builder.h>
#include <grpc++/server_context.h>
#include <grpc++/security/server_credentials.h>
#include "Graph.h"
#include "replicator.grpc.pb.h"

using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::ServerReader;
using grpc::ServerReaderWriter;
using grpc::ServerWriter;
using grpc::Status;
using replicator::Node;
using replicator::Ack;
using replicator::Replicator;

class ReplicatorImpl final : public Replicator::Service {
 public:
  explicit ReplicatorImpl(Graph *g) {
    graph = g;
  }

  Status AddNode(ServerContext* context, const Node* node, Ack *ack) override {
    int status;
    status = graph->addNode(node->node_id);
    ack->set_status(status);
    return Status::OK;
  }

 private:
  Graph *graph;
};

void RunServer(const Graph *g) {
  std::string server_address("0.0.0.0:50051");
  RouteGuideImpl service(g);

  ServerBuilder builder;
  builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
  builder.RegisterService(&service);
  std::unique_ptr<Server> server(builder.BuildAndStart());
  std::cout << "Server listening on " << server_address << std::endl;
  server->Wait();
}