import pandas as pd
import networkx as nx
import glob
import os

# Define the path to your CSV files
path = 'csvs'
all_files = glob.glob(os.path.join(path, "*.csv"))

# Initialize an empty graph
G = nx.Graph()

# Process each file separately
for file in all_files:
    df = pd.read_csv(file)
    
    # Add nodes and edges for each file
    for i in range(len(df) - 1):
        node1 = df.iloc[i]['sp-tekst-r']
        node2 = df.iloc[i + 1]['sp-tekst-r']
        distance = float(df.iloc[i + 1]['sp-km'].replace(',', '.')) - float(df.iloc[i]['sp-km'].replace(',', '.'))
        G.add_edge(node1, node2, weight=distance)

# Draw the combined graph
pos = nx.spring_layout(G)
nx.draw(G, pos, with_labels=True, node_size=700, node_color='lightblue', font_size=10, font_weight='bold')
labels = nx.get_edge_attributes(G, 'weight')
nx.draw_networkx_edge_labels(G, pos, edge_labels=labels)
plt.show()
