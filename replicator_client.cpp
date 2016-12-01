#include <iostream>
#include <memory>
#include <string>
#include <grpc++/grpc++.h>
#include "replicator.grpc.pb.h"

#define RPC_FAILED 500

using grpc::Channel;
using grpc::ClientContext;
using grpc::Status;
using replicator::AddNode;
using replicator::Replicator;

class ReplicatorClient {
 public:
  ReplicatorClient(std::shared_ptr<Channel> channel)
      : stub_(Replicator::NewStub(channel)) {}
.
  int SendAddNode(const uint64_t node_id) {
    Node node;
    node.set_node_id(node_id);

    Ack ack;

    ClientContext context;

    Status status = stub_->SendAddNode(&context, node, &ack);

    if (status.ok()) {
      return ack.status();
    } else {
      std::cout << status.error_code() << ": " << status.error_message()
                << std::endl;
      return RPC_FAILED;
    }
  }


 private:
  std::unique_ptr<Replicator::Stub> stub_;
};

ReplicatorClient init_client() {
  ReplicatorClient client(grpc::CreateChannel(
      "localhost:50051", grpc::InsecureChannelCredentials()));
  return client;
}