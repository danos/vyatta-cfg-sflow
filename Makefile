PROTO_PATH = /usr/share/vyatta-dataplane/protobuf

SFlowConfig.pm: $(PROTO_PATH)/SFlowConfig.proto
	PROTO_PATH=$(PROTO_PATH) ./scripts/vyatta-generate-pb-perl.pl $^ $(@D)
