import pandas as pd
from sklearn import preprocessing

def create_training_data():
    df1 = pd.read_csv('csvs/2011.csv')
    df2 = pd.read_csv('csvs/2012.csv')
    df3 = pd.read_csv('csvs/2013.csv')

    df = pd.concat([df1,df2,df3])
    params = list(df.columns.values)[3:]
    h = list(df.columns.values)

    std_scale = preprocessing.StandardScaler().fit(df[params])
    df_std = pd.DataFrame(data=std_scale.transform(df[params]),columns=params)
    #print df_std
    df[[h[0],h[1],h[2]]].join(df_std,how='inner').to_csv('standardized_training.csv',index=False)
    #df_std.to_csv('standardized_training.csv',index=False)

    with open('meta.txt','w') as f:
        f.write('mean\n')
        f.write(str(std_scale.mean_))
        f.write('variance\n')
        f.write(str(std_scale.var_))

    return std_scale

def create_testing_data(std):
    df = pd.read_csv('csvs/2014.csv')

    params = list(df.columns.values)[3:]
    h = list(df.columns.values)

    std_scale = preprocessing.StandardScaler().fit(df[params])
    df_std = pd.DataFrame(data=std_scale.transform(df[params]),columns=params)
    #print df_std
    df[[h[0],h[1],h[2]]].join(df_std,how='inner').to_csv('standardized_testing.csv',index=False)

def create_validation_data(std):
    df = pd.read_csv('csvs/2015.csv')

    params = list(df.columns.values)[3:]
    h = list(df.columns.values)

    std_scale = preprocessing.StandardScaler().fit(df[params])
    df_std = pd.DataFrame(data=std_scale.transform(df[params]),columns=params)
    #print df_std
    df[[h[0],h[1],h[2]]].join(df_std,how='inner').to_csv('standardized_validation.csv',index=False)

if __name__=="__main__":
    std = create_training_data()
    create_testing_data(std)
    create_validation_data(std)
