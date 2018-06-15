#include <iostream>
#include <fstream>
#include <string>
#include "VasicekModel.h"

int main() {

    int noYears = 5;
    int noPaths = 10000;
    std::string FileName = "data_file.csv";

    std::ofstream CSVfile;
    CSVfile.open (FileName);

    CSVfile << "Year 0" << "," << "Year 1" << "," << "Year 2" << ","
            << "Year 3" << "," << "Year 4" << "," << "Year 5" << "\n";

    for (int i = 0; i < noPaths; i++){

        VasicekModel VAS1( 0.65, 0.06,  0.015, 1, 0.01);
        CSVfile << VAS1.GetInterestRate() << ",";

        for (int j = 0; j < noYears; j++){
            CSVfile << VAS1.NextInterestRate() << ",";
        }
        CSVfile << "\n";
    }

    std::cout << "All done." << std::endl;
    return 0;
}