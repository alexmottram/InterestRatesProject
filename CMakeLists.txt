cmake_minimum_required(VERSION 3.10)
project(InterestRates)

set(CMAKE_CXX_STANDARD 11)

add_executable(InterestRates main.cpp VasicekModel.cpp VasicekModel.h)