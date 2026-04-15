# tegin uue faili streamlit_emta.py. .py sest see on tavaline Python'i skript, mida saab käivitada terminalis. Selles failis kasutame streamlit'i, 
# et luua interaktiivne veebirakendus, mis kuvab ettevõtluse statistikat maakondade lõikes.

# impordin streamlit, pandas ja duckdb teegid, et saaksime luua interaktiivse veebirakenduse, töödelda andmeid ja teha SQL-päringuid.

import streamlit as st
import pandas as pd
import duckdb

#import seaborn ja matplotlib, et saaksime luua graafikuid, mis visualiseerivad ettevõtluse statistikat maakondade lõikes.
import seaborn as sns
import matplotlib.pyplot as plt

#kirjutame pealdise, mis kuvatakse rakenduse ülaosas
st.write("# Ettevõtluse statistika maakondade lõikes")

#loeme andmed CSV-failist, mille salvestasime eelnevalt emta.ipynb-s
data = pd.read_csv("emta_data.csv")


#aasta = st.slider(min_value=2020, max_value=2026, label="Vali aasta") #loome liuguri, mille abil saab valida aasta, mille kohta soovitakse statistikat näha. 
#aasta = st.selectbox("Vali aasta", options=sorted(data["aasta"].unique(), reverse=True)) #teine võimalus valida aasta rippmenüü kaudu. reverse pöörab järjekorra vastupidi

#kvartal = st.slider(min_value=1, max_value=4, label="Vali kvartal") #loome liuguri, mille abil saab valida kvartali, mille kohta soovitakse statistikat näha. 
#kvartal = st.selectbox("Vali kvartal", options=[1, 2, 3, 4]) #teine võimalus valida kvartal rippmenüü kaudu

col1, col2 = st.columns(2) #loome kaks veergu, kuhu saame paigutada erinevaid elemente
with col1: #esimese veeru sees
   aasta = st.selectbox("Vali aasta", options=sorted(data["aasta"].unique(), reverse=True)) #loome rippmenüü, mille abil saab valida aasta, mille kohta soovitakse statistikat näha. reverse pöörab järjekorra vastupidi
with col2: #teise veeru sees
    kvartal = st.selectbox("Vali kvartal",
        options=duckdb.sql(f"SELECT DISTINCT kvartal FROM data WHERE aasta = {aasta} ORDER BY kvartal desc")) 
    #loome rippmenüü, mille abil saab valida kvartali, mille kohta soovitakse statistikat näha. 
    # Kvartali valik sõltub valitud aastast, seega teeme SQL-päringu, et saada unikaalsed kvartalid, mis on seotud valitud aastaga.
    #desc järjestab kvartalid kahanevalt, et uusim kvartal oleks nimekirja alguses.

#teeme SQL-päringu, et saada kokkuvõte ettevõtete arvust igas maakonnas. Kasutame duckdb, et teha SQL-päring otse pandas DataFrame'i peal.
count_by_county = duckdb.sql(f"""
    SELECT maakond, 
    COUNT(DISTINCT registrikood) AS ettevotete_arv
    FROM data
    WHERE aasta = {aasta} AND kvartal = {kvartal} AND maakond IS NOT NULL   
    GROUP BY maakond
    --having maakond IS NOT NULL #et välistada null väärtused, mis võivad tekkida, kui mõnel ettevõttel pole maakonda määratud. 
    --Võin kasutada having või panna where klausli sisse

    ORDER BY ettevotete_arv DESC 
""").df()

st.write("## Ettevõtete arv maakondade lõikes") #pealdise teine tase, mis kuvatakse enne graafikut
st.bar_chart(count_by_county, y="ettevotete_arv", x="maakond", sort=False) #kuvame tulpdiagrammi, kus x-teljel on maakonnad ja y-teljel ettevõtete arv


# teine võimalus
fig = plt.figure(figsize=(10, 6)) #määra graafiku suurus
sns.barplot(data=count_by_county, x="ettevotete_arv", y="maakond") #kuvame tulpdiagrammi, kus x-teljel on maakonnad ja y-teljel ettevõtete arv
st.pyplot(fig) #kuvame graafiku streamlit rakenduses



#st.write(data.head(5)) #näita esimest 5 rida andmetest

#loome rippmenüü, kus kasutaja saab valida maakonna, mille kohta ta soovib statistikat näha. Valikud pärinevad andmetes olevatest unikaalsetest maakondadest.
maakond: str = st.selectbox("Maakond", options=data["maakond"].unique())


#numbrid on käepärast, tabel maakonna nimi harju, sellele vasta väärtus
#sns.barplot(data, y= "maakond")

#näitab, mitu ettevõtet on igas maakonnas, x-teljel maakond, y-teljel ettevõtete arv
#sns.countplot(data, y= "maakond")

#teeme SQL-päringu, et saada kokkuvõte ettevõtete arvust, keskmisest kuise ja kvartaalne käibe suurusest valitud maakonna kohta 2026. aasta 1. kvartalis. 
# Tulemused järjestatakse keskmise kuise käibe suuruse järgi kahanevalt.    
st.write(duckdb.sql(f"""
    SELECT
        kov,
        count(DISTINCT registrikood) AS ettevotete_arv,
        round(avg(kaive) / 3)::int AS keskmine_kuine_kaive,
        round(avg(kaive))::int AS keskmine_kvartaalne_kaive
    FROM data
    WHERE aasta = 2026 AND kvartal = 1 AND maakond = '{maakond}'
    GROUP BY kov
    ORDER BY keskmine_kuine_kaive DESC
""").df())

#new terminal command to run streamlit app:
# streamlit run streamlit_emta.py
# python -m streamlit run streamlit_emta.py



# mis on keskmine palk mida igas harus makstakse, et näha, millises harus on kõige kõrgem keskmine palk.
# me teame tööjõu makse ja töötajate arvu, seega saame arvutada keskmise palga, jagades tööjõu makse töötajate arvuga.