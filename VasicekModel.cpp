//
// Created by Alex on 14/06/2018.
//

#include "VasicekModel.h"
VasicekModel::VasicekModel(double Gamma_, double MeanR_, double Sigma_, double DeltaT_, double InitialInterestR_) :
        Gamma(Gamma_), MeanR(MeanR_), Sigma(Sigma_), DeltaT(DeltaT_), InterestRate(InitialInterestR_), Time(0)
{}

double VasicekModel::NextInterestRate()
{
    std::random_device rd;  //Will be used to obtain a seed for the random number engine
    std::mt19937 gen(rd()); //Standard mersenne_twister_engine seeded with rd()
    std::normal_distribution<double> distribution(0,1.0);

    const double brownian = distribution(gen);
    const double deltaR = Gamma*(MeanR-InterestRate)*DeltaT + (Sigma*brownian);

    InterestRate += deltaR;
    Time += DeltaT;

    return InterestRate;
}

const double VasicekModel::GetTime() { return Time; }

const double VasicekModel::GetInterestRate() { return InterestRate; }