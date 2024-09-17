#include <iostream>
#include <vector>
#include <cmath>
#include <string>
#include <sstream>

using namespace std;

vector<vector<double> > rot(double r, double p, double t);
vector<double> motorAngles(const vector<vector<double> >& rf, const vector<vector<double> >& rs);
vector<vector<double> > matrixMultiply(const vector<vector<double> >& a, const vector<vector<double> >& b);
vector<double> matrixVectorMultiply(const vector<vector<double> >& matrix, const vector<double>& vector);
vector<vector<double> > matrixInverse(const vector<vector<double> >& m);

extern "C" {

const char* calculate(double r_in, double p_in, double t_in,
                      double dx_in, double dy_in, double dz_in,
                      double fr_in, double fp_in, double ft_in, int isRadian) {
    double py_r = isRadian ? r_in : r_in * M_PI / 180;
    double py_t = isRadian ? t_in : t_in * M_PI / 180;
    double py_p = isRadian ? p_in : p_in * M_PI / 180;

    double dx = dx_in;
    double dy = dy_in;
    double dz = dz_in;

    double f_r = isRadian ? fr_in : fr_in * M_PI / 180;
    double f_p = isRadian ? fp_in : fp_in * M_PI / 180;
    double f_t = isRadian ? ft_in : ft_in * M_PI / 180;

    vector<vector<double> > rs = rot(py_r, py_p, py_t);
    vector<vector<double> > rf = rot(f_r, f_p, f_t);
    vector<double> output = motorAngles(rf, rs);

    stringstream ss;
    ss << "R1 setting: " << output[1] * 180 / M_PI << " degrees\n";
    ss << "Azimuthal setting: " << -output[0] / (2 * M_PI) << " rotations\n";
    ss << "Tilt setting: " << output[2] / (2 * M_PI) << " rotations\n";

    vector<vector<double> > R = rot(output[0], output[1], output[2]);
    vector<double> D(3);
    D[0] = dx;
    D[1] = dy;
    D[2] = dz;
    vector<double> offset = matrixVectorMultiply(R, D);

    ss << "\nX adjustment: " << -1 / sqrt(2) * (offset[0] - offset[2]) << " mm\n";
    ss << "Y adjustment: " << 1 / sqrt(2) * (offset[0] + offset[2]) << " mm\n";
    ss << "Z adjustment: " << -offset[1] << " mm";

    static string result;
    result = ss.str();

    return result.c_str();
}
}


vector<vector<double> > rot(double r, double p, double t) {
    vector<vector<double> > rr(3, vector<double>(3));
    rr[0][0] = cos(r); rr[0][1] = -sin(r); rr[0][2] = 0;
    rr[1][0] = sin(r); rr[1][1] = cos(r); rr[1][2] = 0;
    rr[2][0] = 0;      rr[2][1] = 0;      rr[2][2] = 1;

    vector<vector<double> > rt(3, vector<double>(3));
    rt[0][0] = 1; rt[0][1] = 0; rt[0][2] = 0;
    rt[1][0] = 0; rt[1][1] = cos(t); rt[1][2] = -sin(t);
    rt[2][0] = 0; rt[2][1] = sin(t); rt[2][2] = cos(t);

    vector<vector<double> > rp(3, vector<double>(3));
    rp[0][0] = cos(p); rp[0][1] = 0; rp[0][2] = sin(p);
    rp[1][0] = 0; rp[1][1] = 1; rp[1][2] = 0;
    rp[2][0] = -sin(p); rp[2][1] = 0; rp[2][2] = cos(p);

    return matrixMultiply(matrixMultiply(rp, rt), rr);
}

vector<double> motorAngles(const vector<vector<double> >& rf, const vector<vector<double> >& rs) {
    vector<vector<double> > rm = matrixMultiply(rf, matrixInverse(rs));
    vector<double> output;
    double theta = -asin(rm[1][2]);
    double phi = asin(rm[0][2] / cos(theta));
    if (rm[2][2] / cos(theta) < 0) {
        phi = M_PI - phi;
    }
    double rotation = asin(rm[1][0] / cos(theta));
    if (rm[1][1] / cos(theta) < 0) {
        rotation = M_PI - rotation;
    }

    if (rotation > M_PI) {
        rotation -= 2 * M_PI;
    } else if (rotation < -M_PI) {
        rotation += 2 * M_PI;
    }

    if (phi > M_PI) {
        phi -= 2 * M_PI;
    } else if (phi < -M_PI) {
        phi += 2 * M_PI;
    }

    output.push_back(rotation);
    output.push_back(phi);
    output.push_back(theta);

    return output;
}

vector<vector<double> > matrixMultiply(const vector<vector<double> >& a, const vector<vector<double> >& b) {
    vector<vector<double> > result(a.size(), vector<double>(b[0].size(), 0.0));
    for (size_t i = 0; i < a.size(); i++) {
        for (size_t j = 0; j < b[0].size(); j++) {
            for (size_t k = 0; k < a[0].size(); k++) {
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    return result;
}

vector<double> matrixVectorMultiply(const vector<vector<double> >& matrix, const vector<double>& vector) {
    if (matrix.size() != 3 || vector.size() != 3) {
        throw invalid_argument("Matrix must be 3x3 and vector must be of size 3.");
    }

    std::vector<double> output;
    
    output.push_back(matrix[0][0] * vector[0] + matrix[0][1] * vector[1] + matrix[0][2] * vector[2]);
    output.push_back(matrix[1][0] * vector[0] + matrix[1][1] * vector[1] + matrix[1][2] * vector[2]);
    output.push_back(matrix[2][0] * vector[0] + matrix[2][1] * vector[1] + matrix[2][2] * vector[2]);
    
    return output;
}

vector<vector<double> > matrixInverse(const vector<vector<double> >& m) {
    double det = m[0][0] * (m[1][1] * m[2][2] - m[2][1] * m[1][2]) -
                 m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0]) +
                 m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]);
    double invDet = 1 / det;

    std::vector<vector<double> > output;

    std::vector<double> row1;
    row1.push_back(invDet * (m[1][1] * m[2][2] - m[2][1] * m[1][2]));
    row1.push_back(invDet * (m[0][2] * m[2][1] - m[0][1] * m[2][2]));
    row1.push_back(invDet * (m[0][1] * m[1][2] - m[0][2] * m[1][1]));
    output.push_back(row1);

    std::vector<double> row2;
    row2.push_back(invDet * (m[1][2] * m[2][0] - m[1][0] * m[2][2]));
    row2.push_back(invDet * (m[0][0] * m[2][2] - m[0][2] * m[2][0]));
    row2.push_back(invDet * (m[1][0] * m[0][2] - m[0][0] * m[1][2]));
    output.push_back(row2);

    std::vector<double> row3;
    row3.push_back(invDet * (m[1][0] * m[2][1] - m[2][0] * m[1][1]));
    row3.push_back(invDet * (m[2][0] * m[0][1] - m[0][0] * m[2][1]));
    row3.push_back(invDet * (m[0][0] * m[1][1] - m[1][0] * m[0][1]));
    output.push_back(row3);

    return output;
}

