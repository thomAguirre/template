##################################################
#Get OS
ifeq ($(OS), Windows_NT)      # is Windows_NT on XP, 2000, 7, Vista, 10...
detected_OS = Windows
else
detected_OS = $(shell uname)  # same as "uname -s"
endif

#OS Specifics
#Windows Stuff
ifeq ($(detected_OS), Windows)
CC = cl
DEL = del /Q
CWD := $(shell echo .\)
SLSH := $(shell echo \)
HSH = --no-print-directory -s
CFLAGS = /EHsc /W4 /WX /O2
else
#Linux Stuff
CC = g++
DEL = rm -r
CWD = ./
SLSH = /
HSH = --no-print-directory -s
CFLAGS = -O -Wall -Wextra -ansi -pedantic -Werror
endif

#Directories
SRC = ./src/
RSRC = ./resources/
OUT = ./out/

#Files
OBJ = $(OUT)main.o #Add all object files here for dependency checking
EXE = program
HED =              #All external headers for dependency checking

##################################################


$(EXE): $(OBJ)
ifeq ($(detected_OS), Windows)
	$(CC) $(CFLAGS) /Fe$@ $^
else
	$(CC) $^ -o $@ $(CFLAGS)
endif
	

$(OUT)%.o: $(SRC)%.cpp $(HED)
ifeq ($(detected_OS), Windows)
	$(CC) /c /Fo$@ $(CFLAGS) $< 
else
	$(CC) -c  $< -o $@ $(CFLAGS)
endif


clean:
clean:
ifeq ($(detected_OS), Windows)
	-$(DEL) .\out\*
	-$(DEL) $(EXE).exe
	-$(DEL) $(EXE)
	-$(DEL) docs
else
	-$(DEL) $(OUT)*
	-$(DEL) $(EXE).exe
	-$(DEL) $(EXE)
	-$(DEL) $(CWD)docs
endif


docs: $(EXE)
	doxygen

rerun:
	make clean $(HSH)
	make run $(HSH)

run: $(EXE)
	$(CWD)$(EXE)