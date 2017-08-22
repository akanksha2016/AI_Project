import pandas as pd
import math
def create_folders():
    folders = dict()

    for year in range(5):
        for quarter in range(4):
            key = str(year+2011)
            if key not in folders:
                folders[key] = list()
            folders[key].append('IGI'+key+'Q'+str(quarter+1)+'.csv')

    return folders

def nearest_neighbour(i,j,l):
    if i == -1 and j == len(l):
        return
    if i == -1:
        i = 0
        while i < j:
            l[i] = l[j]
            i = i + 1
    else:
        if j == len(l):
            j = j - 1
            while j > i:
                l[j] = l[i]
                j = j - 1
        else:
            k = i + (j-i)/2
            i = i + 1
            while i <= k:
                l[i] = l[i-1]
                i = i + 1
            j = j - 1
            while j > k:
                l[j] = l[j+1]
                j = j - 1

def remove_NAs(params_dict):
    for key in params_dict:
        i = -1
        j = 0
        while j < len(params_dict[key]):
            if math.isnan(float(params_dict[key][j])) == True:
                while j < len(params_dict[key]) and math.isnan(float(params_dict[key][j])) == True:
                    j = j + 1
                nearest_neighbour(i,j,params_dict[key])
            i = j
            j = j + 1

def save_file(df,params_dict,params,year):
    f = pd.DataFrame(columns=params)
    index = 0

    for tup in zip(*[params_dict[key] for key in params]):
        f.loc[index] = [tup[i] for i in range(len(tup))]
        index = index + 1

    f.join(df).to_csv(year+'.csv',index=False)


def preprocess(folders):
    for year in folders:
        df_list = list()
        for file in folders[year]:
            df_list.append(pd.read_csv(year+'/'+file))

        df = pd.concat(df_list)
        df.to_csv('blah.csv',index=False)
        headers = list(df.columns.values)
        params = list(df.columns.values)[3:]

        params_dict = dict()

        for _,row in df.iterrows():
            for key in params:
                if float(row[key]) < 0.0:
                    row[key] = str(abs(row[key]))
                if key == 'RH' and float(row[key]) > 150:
                    row[key] = str(int(0))
                if key == 'TEMP' and float(row[key]) > 100:
                    row[key] = 'nan'

                if key not in params_dict:
                    params_dict[key] = list()
                params_dict[key].append(row[key])

        remove_NAs(params_dict)
        with open('dump.txt','w') as f:
            f.write(str(params_dict))

        save_file(df[[0,1,2]],params_dict,params,year)


if __name__=="__main__":
    folders = create_folders()

    preprocess(folders)
