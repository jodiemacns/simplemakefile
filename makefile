################################################################################
#
################################################################################
LIB_NAME = example
exe=$(LIB_NAME).exe

################################################################################
# Include directories.
INCLUDES = -I./ 

################################################################################
# Compiler defines.
CC=gcc
CFLAGS= -O0 -g3 -fmessage-length=0 -ggdb $(INCLUDES)

################################################################################
# LIB
LIB	     = lib$(LIB_NAME).a
LIB_SRC = ./$(LIB_NAME).c 	

LIB_OBJ = $(patsubst %.c,%.o,$(wildcard $(LIB_SRC)))
LIB_H   = $(patsubst %.c,%.h,$(wildcard $(LIB_SRC)))

# Libraries that this may rely on
S_LIBS =      #libLibraryname.a
LINK_S_LIBS = #-lLibraryname

# May need to modify the LIB build to something like this to add library to 
# library. Extract objects and add them back 
#$(LIB): $(S_LIBS)
#   -rm -f $(LIB_NAME)main.o
#   -del $(LIB_NAME)main.o
#   ar x $(S_LIBS)
#   ar rcs $(LIB) *.o

################################################################################
ifeq ($(MAKECMDGOALS),$(filter $(MAKECMDGOALS), test deepclean))
endif

################################################################################
# Targets
all:lib
test:$(exe)

$(S_LIBS):
	@echo ----------------- Compiling Support Library ----------
	make -C $(dir $@) 

$(exe): $(LIB) $(S_LIBS) $(LIB_NAME)main.o 
	$(CC) -L. $(LIB_NAME)main.o -l$(LIB_NAME)  -o $(exe) 

lib: $(LIB) $(LIB_OBJS) 

%.o: %.c %.h makefile
	$(CC) -c $(CFLAGS) $< -o $@

%.o: %.c makefile
	$(CC) -c $(CFLAGS) $< -o $@

$(LIB): $(LIB_OBJ) 
	ar rcs $(LIB) $(LIB_OBJ)

cleanunix:
	-find . -name "*.[o,a]" -exec rm -rf {} \;;
	-find . -name "*.exe" -exec rm -rf {} \;;	  

clean: 
	del /S *.a *.o *.exe *.d
