#ifndef __ComplexFloatArray_h__
#define __ComplexFloatArray_h__

#include "FloatArray.h"

struct ComplexFloat {
  float re;
  float im;
};

class ComplexFloatArray {
private:
  ComplexFloat* data;
  int size;
public:
  ComplexFloatArray() :
    data(NULL), size(0) {}
  ComplexFloatArray(ComplexFloat* d, int s) :
    data(d), size(s) {}
  float re(const int i){
    return data[i].re;
  }
  float im(const int i){
    return data[i].im;
  }
  float mag(const int i);
  void getMagnitudeValues(FloatArray& buf);
  float mag2(const int i);
  void getMagnitudeSquaredValues(FloatArray& buf);
  void getComplexConjugateValues(ComplexFloatArray& buf);
  void complexDotProduct(ComplexFloatArray& operand2, ComplexFloat& result);
  void complexByComplexMultiplication(ComplexFloatArray& operand2, ComplexFloatArray& result);
  void complexByRealMultiplication(FloatArray& operand2, ComplexFloatArray& result);
  int getSize(){
    return size;
  }
  float getMaxMagnitudeValue();
  int getMaxMagnitudeIndex();
  ComplexFloatArray subarray(int offset, int length);
  void getRealValues(FloatArray& buf);
  void getImaginaryValues(FloatArray& buf);
  void scale(float factor);
  ComplexFloat& operator [](const int i){
    return data[i];
  }
  operator ComplexFloat*() {
    return data;
  }
  operator float*() {
    return (float *)data;
  }
  ComplexFloat* getData(){
    return data;
  }
  static ComplexFloatArray create(int size);
  static void destroy(ComplexFloatArray);
};

#endif // __ComplexFloatArray_h__