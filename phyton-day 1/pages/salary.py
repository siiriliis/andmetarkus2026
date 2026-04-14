import streamlit as st

import duckdb
import matplotlib.pyplot as plt
import seaborn as sns       
import pandas as pd

# Annan lehele pealdise
"# Palgad tööstusharude lõikes"

# Loeme andmed CSV-failist, mille salvestasime eelnevalt emta.ipynb-s
data = pd.read_csv("emta_data.csv")

TAX_PRECENTAGE = 0.338 # Oletame, et maksud on 20% brutopalgast


#
salary_stats = (duckdb.sql(f"""
    SELECT tegevusala, 
        round(avg(toojoumaksud/{TAX_PRECENTAGE}/tootajate_arv/3), 2)  AS keskmine_palk,
        round(median(toojoumaksud/{TAX_PRECENTAGE}/tootajate_arv/3), 2)  AS median_palk
    FROM data
    where aasta = 2026 AND kvartal = 1 AND tegevusala IS NOT NULL
    GROUP BY tegevusala
    order by keskmine_palk desc

""").df())

# Võid kuvada ka tabeli, kui keegi tahab täpseid numbreid näha
with st.expander("Vaata täpseid andmeid tabelina"):
    st.dataframe(salary_stats, use_container_width=True)
#st.write(salary_stats) # Kuvame tabelina keskmise ja mediaanpalga tööstusharude lõikes

"## Keskmine palk tööstusharude lõikes" # Pealdise teine tase, mis kuvatakse enne graafikut
st.bar_chart(salary_stats, x="tegevusala", y="keskmine_palk", sort=False, horizontal=True) # Kuvame tulpdiagrammina keskmise palga tööstusharude lõikes

st.subheader("Keskmine vs mediaanpalk tegevusalade lõikes")

# 2. Teeme graafiku (Streamliti bar_chart on "tark" ja oskab nimekirja lugeda)
# Me määrame 'tegevusala' x-teljeks ja anname y-teljele listi kahest tulbast
st.bar_chart(
    salary_stats, 
    x="tegevusala", 
    y=["keskmine_palk", "median_palk"],
    color=["#1f77b4", "#ff7f0e"]  # Sinine keskmise ja oranž mediaani jaoks
)

