#include <iostream>
#include <fstream>
#include <string>
#include <time.h>
#include <vector>

#include "tlocVersionFilePath.h"

using namespace std;

#define PROJECT_NAME "TLOC_DEP"

#define RETURN_SUCCESS return 0
#define RETURN_ERROR return -1

#define MAJOR_VERSION_M "_MAJOR_VERSION"
#define MINOR_VERSION_M "_MINOR_VERSION"
#define BUILD_NUMBER_M  "_BUILD_NUMBER"
#define DATE_TIME_M     "_DATE_TIME"
#define STRING_M        "_STR"

enum
{
  major_version = 0,
  minor_version,
  build_number,
  date_time,
  total_elements
};

const char* macroNames[] =
{
  "_MAJOR_VERSION",
  "_MINOR_VERSION",
  "_BUILD_NUMBER",
  "_DATE_TIME",
};

int main(int argc, char* argv[])
{
  ifstream tempFile;
  tempFile.open(VERSION_FILE_NAME);

  // First time file status
  const bool firstTime = tempFile.is_open() ? false : true;
  tempFile.close();

  // If this is the first time, create the file because fstream does not create
  // the file for us
  if (firstTime)
  {
    ofstream file(VERSION_FILE_NAME);
  }

  fstream file;
  file.open(VERSION_FILE_NAME);

  if (!file.is_open())
  {
    cout << "Could not open file for read/write: " << VERSION_FILE_NAME << endl;
    RETURN_ERROR;
  }

  vector<time_t> version;
  for (int i = 0; i < (int)total_elements; ++i)
  {
    version.push_back(0);
  }

  if (!firstTime)
  {
    char str[256];

    while (file.good())
    {
      file.getline(str, 256);

      string currLine = str;

      string strToMatch = "ifndef " PROJECT_NAME "_VERSION_";

      if (currLine.find(strToMatch) != string::npos &&
        currLine.find(strToMatch + "H") == string::npos)
      {
        size_t pos = currLine.find("_VERSION_");
        pos = currLine.find_first_of('_', pos+1); // last _ of _VERSION_

        size_t pos2 = currLine.find_first_of('_', pos + 1);

        for (int z = 0; z < 3; ++z)
        {
          string currentNum = currLine.substr(pos + 1, pos2 - pos - 1);
          if (!currentNum.empty())
          {
            version[z] = atoi(currentNum.c_str());
            if (z == build_number)
            {
              version[build_number]++;
            }
          }

          pos = pos2;
          pos2 = currLine.find_first_of('_', pos + 1);
        }

        goto DONE;
      }
    }

DONE:

    file.seekg(0, ios::beg);
    file.clear();
  }

  // The current time in milliseconds
  version[date_time] = time(NULL);

  file << "#ifndef " << PROJECT_NAME << "_VERSION_H" << "\n";
  file << "#define " << PROJECT_NAME << "_VERSION_H" << "\n\n";
  file <<
    "// << IF YOU HAVE A CONFLICT, READ THIS >> \n"
    "// Auto-generated file for automatic versioning. Do not edit this file \n"
    "// directly unless you are editing a CONFLICT, in which case simply \n"
    "// increment the time and your current build number to resolve the \n"
    "// conflict.\n"
    "// e.g. local-file version = x_x_5_12345 where 12345 = time and \n"
    "// incoming-file version = x_x_8_12350 where 12350 = time then... \n"
    "// take the build number (5) and increment it and increment the time (12345)\n"
    "// so the local-file will then have: x_x_6_12346\n"
    "// (please see end-of-file for rationalle behind this)\n\n";

  file << "#ifndef " << PROJECT_NAME << "_VERSION_"
    << version[major_version] << "_"
    << version[minor_version] << "_"
    << version[build_number] << "_"
    << version[date_time] << "\n";
  file <<
    "#  error \"You are building against an incorrect/older version of the "
    "library. The correct version is the macro above.\"\n";
  file << "#endif\n\n";

  file << "#endif\n\n";

  file << "// Rationale behind incrementing the build number and time is that \n";
  file << "// it will reduce the chances of a version number conflicting with \n";
  file << "// another previous version (or a version we do not know about yet \n";
  file << "// as our repository may not be up-to-date)";

  RETURN_SUCCESS;
}