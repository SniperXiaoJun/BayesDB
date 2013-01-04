OPTIMIZED = 
ifdef OPTIMIZED
CXXOPTS := -O2 -g $(CXXOPTS)
else
CXXOPTS := -g $(CXXOPTS)	
endif

CC = gcc
CXX = g++
CXXOPTS :=  -lm -lboost_program_options

INC=include/CrossCat
SRC=src
OBJ=obj
TEST=tests
#
BIN = model
MAIN = main
NAMES = Cluster Suffstats utils numerics View RandomNumberGenerator
TEST_NAMES = unit_test_test other_unit_test_test test_view
HEADERS = $(foreach name, $(NAMES), $(INC)/$(name).h)
SOURCES = $(foreach name, $(NAMES) $(MAIN), $(SRC)/$(name).cpp)
OBJECTS = $(foreach name, $(NAMES), $(OBJ)/$(name).o)
TESTS = $(foreach test, $(TEST_NAMES), $(TEST)/$(test))


all: $(BIN)

# run each test
tests: $(TESTS)
	@echo tests are: $(TESTS)
	@$(foreach test, $(TESTS), ./$(test);)

$(BIN): $(OBJECTS)
	$(CXX) -o $(BIN) $(OBJECTS) $(CXXOPTS) $(SRC)/$(MAIN).cpp

$(OBJ)/%.o: $(SRC)/%.cpp $(INC)/%.h $(HEADERS)
	$(CXX) -c $< -o $@ $(CXXOPTS) -I$(INC)

$(TEST)/%: $(TEST)/%.cpp $(HEADERS) $(OBJECTS)
	$(CXX) $< -o $@ $(CXXOPTS) -I$(INC) $(OBJECTS)

clean:
	rm -f $(BIN) $(OBJECTS) core *.stackdump *.gch $(TESTS)
