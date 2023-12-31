import pandas as pd
files = ['file1.csv', 'file2.csv']
df = pd.DataFrame()
for file in os.listdir("C:/Users):
    if file.endswith(".csv"):
        data = pd.read_csv(file, encoding = "latin-1")
        df = pd.concat([df, data], axis=0)
df.to_csv('merged_files.csv', index=False)
