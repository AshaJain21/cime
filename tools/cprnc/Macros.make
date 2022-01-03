SUPPORTS_CXX := FALSE
ifeq ($(COMPILER),gnu)
  FFLAGS :=   -fconvert=big-endian -ffree-line-length-none -ffixed-line-length-none 
  SUPPORTS_CXX := TRUE
  CFLAGS :=  -std=gnu99 
  CXX_LINKER := FORTRAN
  FC_AUTO_R8 :=  -fdefault-real-8 
  FFLAGS_NOOPT :=  -O0 
  FIXEDFLAGS :=   -ffixed-form 
  FREEFLAGS :=  -ffree-form 
  HAS_F2008_CONTIGUOUS := FALSE
  MPICC :=  mpicc  
  MPICXX :=  mpicxx 
  MPIFC :=  mpif90 
  SCC :=  gcc 
  SCXX :=  g++ 
  SFC :=  gfortran 
endif
CPPDEFS := $(CPPDEFS)  -DCESMCOUPLED 
CPPDEFS := $(CPPDEFS)  -DSYSDARWIN 
ifeq ($(MODEL),pop)
  CPPDEFS := $(CPPDEFS)  -D_USE_FLOW_CONTROL 
endif
ifeq ($(MODEL),ufsatm)
  CPPDEFS := $(CPPDEFS)  -DSPMD 
  FFLAGS := $(FFLAGS)  $(FC_AUTO_R8) 
endif
ifeq ($(MODEL),mom)
  FFLAGS := $(FFLAGS)  $(FC_AUTO_R8) -Duse_LARGEFILE
endif
ifeq ($(COMPILER),gnu)
  CPPDEFS := $(CPPDEFS)  -DFORTRANUNDERSCORE -DNO_R16 -DCPRGNU
  LDFLAGS := $(LDFLAGS)  -framework Accelerate -Wl,-rpath $(NETCDF)/lib
  ifeq ($(compile_threaded),TRUE)
    FFLAGS := $(FFLAGS)  -fopenmp 
    CFLAGS := $(CFLAGS)  -fopenmp 
  endif
  ifeq ($(DEBUG),TRUE)
    FFLAGS := $(FFLAGS)  -g -Wall -Og -fbacktrace -ffpe-trap=zero,overflow -fcheck=bounds 
    CFLAGS := $(CFLAGS)  -g -Wall -Og -fbacktrace -ffpe-trap=invalid,zero,overflow -fcheck=bounds 
  endif
  ifeq ($(DEBUG),FALSE)
    FFLAGS := $(FFLAGS)  -O 
    CFLAGS := $(CFLAGS)  -O 
  endif
  ifeq ($(compile_threaded),TRUE)
    LDFLAGS := $(LDFLAGS)  -fopenmp 
  endif
endif
ifeq ($(MODEL),ufsatm)
  INCLDIR := $(INCLDIR)  -I$(EXEROOT)/atm/obj/FMS 
endif
