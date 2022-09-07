#1. Выведите топ10 самых частотных запросов в каждой платформе (desktop, touch). Какие отличия вы видите?
#2. Посмотрите, чем отличается трафик запросов в течении дня. Как можно объяснить отличие
#3. Выделите тематики запросов, контрастные для мобильных и компьютеров - темы, доля которых отличаются на разных платформах


import pandas as pd

#df = pd.DataFrame({
#  'txt':    ['Секс', 'русский', 'эналаприл', 'с днем рождения парню', 'распространенное предложение'],
#  'id':     [1632064263, 1632036433, 1632083410, 1632000850, 1632074474],
#  'device': ['touch', 'touch', 'touch', 'desktop', 'touch']
#})


df = pd.read_csv("C:\\Users\\mkb1\\Desktop\\data.tsv", sep="\t")

df_desktop = df[df['device'] == 'desktop'].groupby(df['txt']).size().reset_index().rename(columns = {0 : 'count'})
df_touch = df[df['device'] == 'touch'].groupby(df['txt']).size().reset_index().rename(columns = {0 : 'count'})

print(df_desktop.sort_values(by = 'count', ascending = False).head(10))
print(df_touch.sort_values(by = 'count', ascending = False).head(10))