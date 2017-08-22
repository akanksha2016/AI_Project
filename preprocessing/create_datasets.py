import csv
import operator
from datetime import date

def merge_files(folders):
    values_merged = dict()
    for folder in folders:
        for attr in ['BEN','BP','CO','MPXY','NO','NO2','O3','RH','SO2','TEMP','TOL','WD','WS']:
            with open(folder+attr+'.csv', 'rb') as csvfile:
                reader = csv.reader(csvfile)
                for row in reader:
                    '''if attr != '':
                        row[0] = row[0][1:]
                        row[1] = row[1][1:]
                        row[2] = row[2][1:]'''
                    #print row[0]
                    #print row[1]
                    #print row[2]
                    d_m_y = row[2].split('/')
                    #print d_m_y
                    #print row[0]
                    #print row[1]
                    if len(d_m_y) == 3:
                        dt = date(int(d_m_y[2]),int(d_m_y[1]),int(d_m_y[0]))
                        key = (row[0],row[1],dt)
                        if key not in values_merged:
                            values_merged[key] = dict()
                        values_merged[key][attr] = row[3]

        with open(folder+'.csv', 'w') as csvfile:
            keys = sorted(values_merged.keys(),key=operator.itemgetter(2, 0))
            writer = csv.DictWriter(csvfile,restval='NA',fieldnames=['from','to','date','BEN','BP','CO','MPXY','NO','NO2','O3','RH','SO2','TEMP','TOL','WD','WS'])
            writer.writeheader()
            for key in keys:
                dt = str(key[2].day) + "/" + str(key[2].month) + "/" + str(key[2].year)
                writer.writerow(dict({'from':str(key[0]),'to':str(key[1]),'date':dt},**values_merged[key]))

if __name__=="__main__":
    folders = []
    """
        Creating the list of folders containing respective attributes of the quarters
    """
    for year in range(5):
        for quarter in range(4):
            folders.append(str(2011+year)+'/Q'+str(quarter+1)+'/'+'IGI'+str(2011+year)+'Q'+str(quarter+1))

    #print folders
    merge_files(folders)
