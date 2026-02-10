from pathlib import Path

import streamlit as st
from streamlit.components.v1 import html

import sys

# Add project root to Python path to fix 'src' module not found
project_root = str(Path(__file__).resolve().parent.parent)
if project_root not in sys.path:
    sys.path.append(project_root)

from src.utils.config import load_config

BASE_DIR = Path(__file__).resolve().parents[1]
REPORTS_DIR = BASE_DIR / "reports"
DASHBOARD_DIR = BASE_DIR / "dashboard"


st.set_page_config(page_title="BiciCoruna Dashboard", layout="wide")

cfg = load_config()

st.title("BiciCoruna Dashboard")
st.caption("Analisis y visualizaciones del sistema de bicis publicas")

col1, col2, col3, col4 = st.columns(4)
col1.metric("Empty threshold", cfg["empty_threshold"])
col2.metric("Full threshold", cfg["full_threshold"])
col3.metric("Decision threshold", cfg["decision_threshold"])
col4.metric("Horizon (min)", cfg["horizon_minutes"])

summary_path = REPORTS_DIR / "resumen_analisis.txt"
with st.expander("Resumen analisis", expanded=False):
    if summary_path.exists():
        st.text(summary_path.read_text(encoding="utf-8"))
    else:
        st.info("No se encontro reports/resumen_analisis.txt")


def render_html(path, height=650):
    if path.exists():
        html(path.read_text(encoding="utf-8"), height=height, scrolling=True)
    else:
        st.info(f"No se encontro {path.name}")


st.header("Mapa de flujos")
render_html(DASHBOARD_DIR / "mapa_flujos.html", height=650)
