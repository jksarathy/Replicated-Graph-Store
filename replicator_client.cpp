// Copyright 2015, Google Inc.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//     * Neither the name of Google Inc. nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

//#include <iostream.h>
#include <memory.h>
#include <string.h>

#include <grpc++/grpc++.h>
#include "replicator.grpc.pb.h"

#define RPC_FAILED 500

using grpc::Channel;
using grpc::ClientContext;
using grpc::Status;
using replicator::Node;
using replicator::Ack;
using replicator::ReplicatorService;

class ReplicatorClient {
 public:
  ReplicatorClient(std::shared_ptr<Channel> channel)
      : stub_(ReplicatorService::NewStub(channel)) {}

  int SendAddNode(const uint64_t node_id) {
    Node node;
    node.set_node_id(node_id);

    Ack ack;

    ClientContext context;

    Status status = stub_->AddNode(&context, node, &ack);

    if (status.ok()) {
      return ack.status();
    } else {
//      std::cout << status.error_code() << ": " << status.error_message()
//                << std::endl;
      return RPC_FAILED;
    }
  }

 private:
  std::unique_ptr<ReplicatorService::Stub> stub_;
};
