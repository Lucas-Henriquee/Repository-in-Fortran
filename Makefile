# Fortran compiler and flags
FC      := gfortran
FFLAGS  := -O2 -Wall -fcheck=all -g

# Directory for executables
BUILD_DIR := bin

# Compiler check
FC_CHECK := $(strip $(shell command -v $(FC) 2>/dev/null))
ifeq ($(FC_CHECK),)
    $(error Fortran compiler '$(FC)' not found. Please install it and ensure it is in your system's PATH.)
endif

# OS-specific settings
ifeq ($(OS),Windows_NT)
    MKDIR_CMD := @if not exist $(subst /,\,$(BUILD_DIR)) mkdir $(subst /,\,$(BUILD_DIR))
    RM_CMD    := @if exist $(subst /,\,$(BUILD_DIR)) rmdir /s /q $(subst /,\,$(BUILD_DIR))
else
    MKDIR_CMD := @mkdir -p
    RM_CMD    := @rm -rf $(BUILD_DIR)
endif

# Dynamic target logic
SOURCE_FILES := $(filter %.f90,$(MAKECMDGOALS))

ifeq ($(SOURCE_FILES),)
    TARGET :=
else
    TARGET := $(patsubst %.f90,$(BUILD_DIR)/%,$(word 1,$(SOURCE_FILES)))
endif

# Targets
.PHONY: all help run clean build

all: help

help:
	@echo "Usage:"
	@echo "  make programa.f90              # compile only"
	@echo "  make run programa.f90          # compile and run"
	@echo "  make \"main.f90 utils.f90\"      # compile with multiple sources"
	@echo "  make run \"main.f90 utils.f90\"  # compile and run with multiple sources"
	@echo "  make clean                     # remove build directory"

# Real compilation rule
$(BUILD_DIR)/%:
	$(MKDIR_CMD) $(@D)
	@$(FC) $(FFLAGS) -o $@ $(SOURCE_FILES)
	@echo "Compiled: $@"

# Wrapper: intercepta `make prog.f90`
%.f90:
	@$(MAKE) -s build SOURCE_FILES="$(SOURCE_FILES)"

# Força compilação via wrapper
build: $(TARGET)

# Run target
run:
	@if [ -z "$(SOURCE_FILES)" ]; then \
		echo "Error: please specify one or more .f90 files (ex: make run main.f90)"; \
	else \
		target=$(patsubst %.f90,$(BUILD_DIR)/%,$(word 1,$(SOURCE_FILES))); \
		$(MAKE) -s build SOURCE_FILES="$(SOURCE_FILES)" >/dev/null && ./$$target $(ARGS); \
	fi

# Cleaning
clean:
	-$(RM_CMD)
