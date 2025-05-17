# analyze_results.py
# results/*.csv içindeki perf çıktısını okuyup
# basit bir özet tablo ve grafik üretir.

import pandas as pd
import glob
import matplotlib.pyplot as plt

df_list = []
for path in glob.glob('results/*_perf.csv'):
    policy, workload, _ = path.split('/')[-1].split('_')
    # perf -x, çıktısı: metric,value,...; biz ilk iki kolonu alıyoruz
    tmp = pd.read_csv(path, header=None, names=['metric','value','rest'], usecols=[0,1])
    tmp['policy'] = policy
    tmp['workload'] = workload
    df_list.append(tmp[['policy','workload','metric','value']])

df = pd.concat(df_list, ignore_index=True)
df['value'] = df['value'].str.replace(',', '').astype(float)

pivot = df.pivot_table(index=['metric','workload'], columns='policy', values='value')
print("\n=== Summary Table ===")
print(pivot)

for wl in df['workload'].unique():
    sub = df[(df.metric=='cycles') & (df.workload==wl)]
    sub = sub.groupby('policy').value.mean()
    plt.figure()
    sub.plot(kind='bar')
    plt.title(f'Cycles for {wl}')
    plt.xlabel('Policy')
    plt.ylabel('Mean cycles')
    plt.tight_layout()
    plt.savefig(f'cycles_{wl}.png')
    print(f"Saved figure: cycles_{wl}.png")
