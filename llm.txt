import torch
from transformers import FlanForSequenceClassification, FlanTokenizer
from sklearn.metrics.pairwise import cosine_similarity
import psycopg2

# Database connection setup
db_config = {
    'dbname': 'your_db_name',
    'user': 'your_username',
    'password': 'your_password',
    'host': 'your_host',
    'port': 'your_port'
}
conn = psycopg2.connect(**db_config)

# Load the model and tokenizer
model_name = "google/flan-ul2"
model = FlanForSequenceClassification.from_pretrained(model_name)
tokenizer = FlanTokenizer.from_pretrained(model_name)

# Fetch and preprocess data from the database
def fetch_data_from_db():
    query = "SELECT column1, column2, column3 FROM your_table;"
    with conn.cursor() as cursor:
        cursor.execute(query)
        data = cursor.fetchall()
    return data

data = fetch_data_from_db()

# Generate contextual embeddings for each concatenated text
contextual_embeddings = []
for row in data:
    concatenated_text = f"{row['column1']} {row['column2']} {row['column3']}"
    input_ids = tokenizer.encode(concatenated_text, return_tensors="pt")
    with torch.no_grad():
        embeddings = model.base_model(input_ids).last_hidden_state.mean(dim=1)
    contextual_embeddings.append(embeddings)

# Encode and process a query
query = "What are the benefits of exercise?"
query_input_ids = tokenizer.encode(query, return_tensors="pt")
query_embedding = model.base_model(query_input_ids).last_hidden_state.mean(dim=1)

# Calculate cosine similarity with each concatenated text snippet
similarities = cosine_similarity(query_embedding, torch.stack(contextual_embeddings))
most_similar_index = torch.argmax(similarities)
most_similar_text = data[most_similar_index]

print("Most relevant data:", most_similar_text)
