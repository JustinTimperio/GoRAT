################
# FILL THESE IN BEFORE BUILDING
SERVER_DEST = 00.00.00.00:1337
# SERVER_DEST = https:\/\/yoururl.com\/sus:443
EXE_NAME = goRAT
############

# Vars and Flags
VERSION := $(shell git rev-list --count HEAD)
BUILD_DIR = BUILD
SRC_DIR = .BUILD_SOURCE
LDFLAGS = -ldflags="-s -w"

# Source Files
CORE = goRAT.go
COMPILE_CORE = '$(SRC_DIR)'/goRAT.go

all: pre-build
	######################
	## 64 Bit Systems
	####################
	
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_64 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_64
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_macos_64 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_macos_64
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_windows_64.exe $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_windows_64.exe
	CGO_ENABLED=0 GOOS=freebsd GOARCH=amd64 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_64 $(LDFLAGS) $(COMPILE_CORE)
	# RIP no UPX for freebsd
	CGO_ENABLED=0 GOOS=openbsd GOARCH=amd64 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_64 $(LDFLAGS) $(COMPILE_CORE)
	# RIP no UPX for openbsd
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_mips_64 $(LDFLAGS) $(COMPILE_CORE)
	# RIP no UPX for MIPS64
	
	GOOS=linux GOARCH=arm64 GOARM=5 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_arm64_ARM5 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_arm64_ARM5
	GOOS=linux GOARCH=arm64 GOARM=6 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_arm64_ARM6 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_arm64_ARM6
	GOOS=linux GOARCH=arm64 GOARM=7 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_arm64_ARM7 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_arm64_ARM7
	
	GOOS=linux GOARCH=arm64 GOARM=5 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_arm64_ARM5 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_arm64_ARM5
	GOOS=linux GOARCH=arm64 GOARM=6 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_arm64_ARM6 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_arm64_ARM6
	GOOS=linux GOARCH=arm64 GOARM=7 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_arm64_ARM7 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_arm64_ARM7
	
	GOOS=linux GOARCH=arm64 GOARM=5 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_arm64_ARM5 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_arm64_ARM5
	GOOS=linux GOARCH=arm64 GOARM=6 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_arm64_ARM6 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_arm64_ARM6
	GOOS=linux GOARCH=arm64 GOARM=7 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_arm64_ARM7 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_arm64_ARM7
	
	
	######################
	## 32 Bit Systems
	####################
	
	CGO_ENABLED=0 GOOS=linux GOARCH=386 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_32 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_32
	CGO_ENABLED=0 GOOS=windows GOARCH=386 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_windows_32.exe $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_windows_32.exe
	CGO_ENABLED=0 GOOS=freebsd GOARCH=386 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_32 $(LDFLAGS) $(COMPILE_CORE)
	# RIP no UPX for freebsd
	CGO_ENABLED=0 GOOS=openbsd GOARCH=386 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_32 $(LDFLAGS) $(COMPILE_CORE)
	# RIP no UPX for openbsd
	CGO_ENABLED=0 GOOS=linux GOARCH=mips go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_mips_32 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_mips_32
	
	GOOS=linux GOARCH=arm GOARM=5 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_arm32_ARM5 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_arm32_ARM5
	GOOS=linux GOARCH=arm GOARM=6 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_arm32_ARM6 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_arm32_ARM6
	GOOS=linux GOARCH=arm GOARM=7 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_arm32_ARM7 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_linux_arm32_ARM7
	
	GOOS=linux GOARCH=arm GOARM=5 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_arm32_ARM5 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_arm32_ARM5
	GOOS=linux GOARCH=arm GOARM=6 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_arm32_ARM6 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_arm32_ARM6
	GOOS=linux GOARCH=arm GOARM=7 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_arm32_ARM7 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_openbsd_arm32_ARM7
	
	GOOS=linux GOARCH=arm GOARM=5 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_arm32_ARM5 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_arm32_ARM5
	GOOS=linux GOARCH=arm GOARM=6 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_arm32_ARM6 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_arm32_ARM6
	GOOS=linux GOARCH=arm GOARM=7 go build -o $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_arm32_ARM7 $(LDFLAGS) $(COMPILE_CORE)
	upx $(BUILD_DIR)/$(EXE_NAME)_v$(VERSION)_freebsd_arm32_ARM7
	

pre-build:
	# Clean Before Stage
	rm -rf $(BUILD_DIR)
	rm -rf $(SRC_DIR)
	mkdir $(BUILD_DIR)
	mkdir $(SRC_DIR)

	# Stage Files and Inject Vars Before Compile
	cp $(CORE) $(COMPILE_CORE)
	sed -i "s/@ENDPOINT_HERE@/$(SERVER_DEST)/g" $(COMPILE_CORE)
