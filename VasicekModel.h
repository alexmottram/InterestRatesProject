//
// Created by Alex on 14/06/2018.
//

#ifndef INTERESTRATES_VASICEKMODEL_H
#define INTERESTRATES_VASICEKMODEL_H

#include <random>

class VasicekModel {
public:
    VasicekModel(double Gamma_, double MeanR_, double Sigma_, double DeltaT_, double InitialInterestR_);
    double NextInterestRate();
    const double GetInterestRate();
    const double GetTime();

private:
    const double Gamma;
    const double MeanR;
    const double Sigma;
    const double DeltaT;
    double InterestRate;
    double Time; // time in years
};


#endif //INTERESTRATES_VASICEKMODEL_H
