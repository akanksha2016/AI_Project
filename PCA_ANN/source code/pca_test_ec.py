# Program to reduce variables into PCs for testing data.

import numpy as np
import pandas as pd
import scipy
import csv

# reading testing data into list
data = []
with open('test_inp.csv', 'r') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        data.append([val for val in row])
data = np.asarray(data)
r1, c1 = data.shape

# reading eigen vector into list then convert it into array.
eig_vec = []
with open('eign_vec_ec.csv', 'r') as csvfile2:
    reader = csv.reader(csvfile2)
    for row in reader:
        eig_vec.append([val for val in row])
eig_vec = np.asarray(eig_vec)
r2, c2 = eig_vec.shape

# reducing given variables to PCs with eigen vector training data.
new = np.empty((r1, c2))
i = 0
k = 0
for i in range(r1):
	for k in range(c2):
		new[i][k] = np.dot(map(lambda x: float(x),data[i]), map(lambda x: float(x),eig_vec[:,k]))

z = data[:,5].reshape((r1,1))
z1 = np.empty((r1,1))
for i in range(r1):
	z1[i] = map(lambda x: float(x),z[i])

new1 = np.append(new, z1 ,axis = 1)


y = data[:,6].reshape((r1,1))
z2 = np.empty((r1,1))
for i in range(r1):
	z2[i] = map(lambda x: float(x),y[i])

new2 = np.append(new, z2 ,axis = 1)

np.savetxt("pca_inp_test_NO2_ec.csv", new1, delimiter=",")
np.savetxt("pca_inp_test_O3_ec.csv", new2, delimiter=",")
