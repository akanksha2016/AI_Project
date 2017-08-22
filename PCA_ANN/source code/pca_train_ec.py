# Program to reduce variables into PCs for training data.

import numpy as np
import pandas as pd
import csv

# reading training data into list
data = []
with open('train_inp.csv', 'r') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        data.append([val for val in row])
myarray1 = np.asarray(data) # convertion list to array.

myarray = np.transpose(myarray1) # transpose of array

a = myarray.astype(np.float)

# finding co-relation matrix in form of nd array.
b = np.corrcoef(a)

# rounding off co-relation coefficients.
c = np.around(b, decimals=3)
names = ['BEN', 'BP', 'CO', 'MPXY', 'NO', 'NO2', 'O3', 'RH', 'SO2', 'TEMP', 'TOL', 'WD', 'WS']
# storing co-reation matrix to csv file.
df = pd.DataFrame(c, index=names, columns=names)
df.to_csv('Corelation.csv', index=True, header=True, sep=',')

# finding eigen values and eigen vector for corelation matrix.
eig_vals, eig_vecs = np.linalg.eig(b)

# Make a list of (eigenvalue, eigenvector) tuples
eig_pairs = [(np.abs(eig_vals[i]), eig_vecs[:,i]) for i in range(len(eig_vals))]

# Sort the (eigenvalue, eigenvector) tuples from high to low
eig_pairs.sort(key=lambda x: x[0], reverse=True)

# Visually confirm that the list is correctly sorted by decreasing eigenvalues
print('Eigenvalues in descending order:')
for i in eig_pairs:
    print(i[0])

# variance explained
tot = sum(eig_vals)
var_exp = [(i / tot)*100 for i in sorted(eig_vals, reverse=True)]
print('Variance explained:')
print var_exp

# cumulative amounts of variance
cum_var_exp = np.cumsum(var_exp)
print('Cumulative amounts of variance:')
print cum_var_exp
# taking PCs, whose cumulative amounts of variance are approximately 80%, count is stored in top_eigen_vec .
top_eigen_vec = 0
for k in cum_var_exp:
	if (k < 90.0):
		top_eigen_vec = top_eigen_vec + 1
print top_eigen_vec

# reducing given variables to PCs whose cumulative amounts of variance are approximately 80%.
new_r, new_c = myarray1.shape
new = np.empty((new_r, top_eigen_vec))
i = 0
k = 0
for i in range(new_r):
	for k in range(top_eigen_vec):
		new[i][k] = np.dot(map(lambda x: float(x),myarray1[i]), map(lambda x: float(x),eig_vecs[:,k]))

# adding target output in the end.
z = myarray1[:,5].reshape((new_r,1))
z1 = np.empty((new_r,1))
for i in range(new_r):
	z1[i] = map(lambda x: float(x),z[i])

new1 = np.append(new, z1 ,axis = 1)

y = myarray1[:,6].reshape((new_r,1))
z2 = np.empty((new_r,1))
for i in range(new_r):
	z2[i] = map(lambda x: float(x),y[i])

new2 = np.append(new, z2 ,axis = 1)

# storing updated input data for NO2 as well as O3 after PCA.
np.savetxt("pca_inp_train_NO2_ec.csv", new1, delimiter=",")
np.savetxt("pca_inp_train_O3_ec.csv", new2, delimiter=",")
k = 0
#storing top eigen vector to find PCs for validation and test data.
eig_vecs = eig_vecs[:, :(top_eigen_vec)]
np.savetxt("eign_vec_ec.csv", eig_vecs, delimiter=",")



