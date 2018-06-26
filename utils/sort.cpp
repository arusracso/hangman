#include <algorithm>
#include <iostream>
#include <fstream>
#include <set>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
using namespace std;

static void calculateNumDirectories();
static void buildDirectoryHierarchy();
static void sortLexicon();

static const string kDefaultDirectoryName = "len";
static const int kScriptFailureError = -1;
static const int kMakeDirectoryError = -2;
static const int kSortSuccess = 0;
static int kMaximumDirectories = 0;
static set<string> kExistingDirectories;
int main() {
    calculateNumDirectories();
    buildDirectoryHierarchy();
    sortLexicon();
    return kSortSuccess;
}

static const string kPythonScript = "python longest-word.py";
static void calculateNumDirectories() {
    int status = system(kPythonScript.c_str());
    if (!WIFEXITED(status)) {
        cout << "Aborting, the python script could not be invoked with the command:" << endl;
        cout << kPythonScript << endl;
        exit(kScriptFailureError);
    }
    kMaximumDirectories = WEXITSTATUS(status);
}

static const int kNamingThreshold = 10;
static const int kNamingPrefix = 0;
static void buildDirectoryHierarchy() {
    for (int i = 1; i < kMaximumDirectories+ 1; i++) {
       string dir = kDefaultDirectoryName;
       string num = i < kNamingThreshold ? to_string(kNamingPrefix) + to_string(i) : to_string(i);
       dir += num;
       int err = mkdir(dir.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
       if (err) {
            cout << "Fatal error in making directory, aborting..." << endl;
            exit(kMakeDirectoryError);
       }
       kExistingDirectories.insert(dir);
    }
    assert(kExistingDirectories.size() == kMaximumDirectories);
}

const string kDefaultLexiconFilepath = "../lexicon.data";
const string kDefaultDumpPath = "words.data"; 
static void sortLexicon() {
    string line;
    ifstream file(kDefaultLexiconFilepath);
    while (getline(file, line)) {
        transform(line.begin(), line.end(), line.begin(), ::tolower);
        unsigned int length = line.length();
        string num = length < kNamingThreshold ? to_string(kNamingPrefix) + to_string(length) : to_string(length);
        string outputFilepath = kDefaultDirectoryName + num + "/" + kDefaultDumpPath;
        ofstream output;
        output.open(outputFilepath, fstream::app);
        output << line << endl;
        output.close();
    }
}
